"""
Grafana Tempo 분산 트레이싱 인프라 테스트.

검증 계층:
  Level 1 - 서비스 헬스: /ready
  Level 2 - 트레이스 수집: api-gateway 서비스 트레이스 존재 여부
  Level 3 - 트레이스 내용: 루트 스팬 정보 검증

실행:
  docker compose -f docker-compose.test.yml --profile observability up -d --build
  cd tests/infra && uv run pytest test_tempo.py -v
"""
import requests


class TestTempo:
    """Tempo 분산 트레이싱 인프라 테스트"""

    # ──────────────────────────────────────────────────────────────────────────
    # Level 1: 서비스 헬스
    # ──────────────────────────────────────────────────────────────────────────

    def test_tempo_ready(self, tempo_url: str):
        """Tempo가 정상 기동됐는지 검증 (/ready)."""
        response = requests.get(f"{tempo_url}/ready", timeout=10)

        assert response.status_code == 200, \
            f"Tempo /ready should return 200 (Got {response.status_code})"
        assert "ready" in response.text.lower(), \
            f"Tempo /ready response should contain 'ready', got: {response.text}"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 2: 트레이스 수집
    # ──────────────────────────────────────────────────────────────────────────

    def test_tempo_receives_traces(self, tempo_url: str):
        """api-gateway 서비스의 트레이스가 Tempo에 수집됐는지 검증.

        OTel 자동 계측으로 생성된 트레이스가 OTLP HTTP(4318)를 통해 Tempo에 저장되어야 함.
        """
        response = requests.get(
            f"{tempo_url}/api/search",
            params={"tags": "service.name=api-gateway", "limit": 5},
            timeout=10,
        )

        assert response.status_code == 200, \
            f"Tempo /api/search should return 200 (Got {response.status_code}): {response.text}"

        data = response.json()
        traces = data.get("traces", [])
        assert traces, \
            "api-gateway 트레이스가 Tempo에 없습니다. " \
            "OTLP_TRACING_ENDPOINT 설정과 트래픽 생성 후 충분한 대기 시간을 확인하세요."

    def test_tempo_receives_traces_all_services(self, tempo_url: str):
        """4개 서비스 모두의 트레이스가 Tempo에 수집됐는지 검증.

        api-gateway 요청이 planner/catalog/user 서비스로 전달될 때 각 서비스에서도
        OTel 스팬이 생성되어 Tempo에 저장되어야 함.
        """
        expected_services = {"api-gateway", "user-service", "planner-service", "catalog-service"}
        services_with_traces = set()

        for service in expected_services:
            response = requests.get(
                f"{tempo_url}/api/search",
                params={"tags": f"service.name={service}", "limit": 1},
                timeout=10,
            )
            if response.status_code == 200 and response.json().get("traces"):
                services_with_traces.add(service)

        missing = expected_services - services_with_traces
        assert not missing, \
            f"다음 서비스의 트레이스가 Tempo에 없습니다: {missing}. " \
            f"트레이스 수집 확인: {services_with_traces}. " \
            f"OTLP_TRACING_ENDPOINT 설정을 확인하세요."

    # ──────────────────────────────────────────────────────────────────────────
    # Level 3: 트레이스 내용
    # ──────────────────────────────────────────────────────────────────────────

    def test_tempo_trace_has_spans(self, tempo_url: str):
        """수집된 트레이스에 루트 스팬 정보가 포함되는지 검증.

        트레이스 ID로 상세 조회 시 rootServiceName, durationMs가 존재해야 함.
        """
        # 첫 번째 트레이스 ID 조회
        search_response = requests.get(
            f"{tempo_url}/api/search",
            params={"tags": "service.name=api-gateway", "limit": 1},
            timeout=10,
        )
        assert search_response.status_code == 200
        traces = search_response.json().get("traces", [])
        assert traces, "No traces found for span detail check"

        trace_id = traces[0].get("traceID")
        assert trace_id, "traceID should be present in search result"

        # 트레이스 상세 조회
        detail_response = requests.get(
            f"{tempo_url}/api/traces/{trace_id}",
            timeout=10,
        )

        assert detail_response.status_code == 200, \
            f"Tempo /api/traces/{trace_id} should return 200 (Got {detail_response.status_code})"

        detail = detail_response.json()
        # Tempo는 OTLP 형식으로 반환: resourceSpans 존재 여부 확인
        resource_spans = detail.get("batches", detail.get("resourceSpans", []))
        assert resource_spans, \
            f"Trace {trace_id} should contain resource spans. Got: {list(detail.keys())}"

        # service.name 리소스 속성 검증 (Tempo→Loki tracesToLogs 연계에 필수)
        found_service_name = None
        for span_batch in resource_spans:
            resource = span_batch.get("resource", {})
            for attr in resource.get("attributes", []):
                if attr.get("key") == "service.name":
                    found_service_name = attr.get("value", {}).get("stringValue")
                    break
            if found_service_name:
                break

        assert found_service_name, \
            f"Trace {trace_id} should have 'service.name' resource attribute for Tempo→Loki linking. " \
            f"Resource keys found: {[a.get('key') for batch in resource_spans for a in batch.get('resource', {}).get('attributes', [])]}"
