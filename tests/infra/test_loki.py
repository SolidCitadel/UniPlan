"""
Loki 로그 집계 인프라 테스트.

검증 계층:
  Level 1 - 서비스 헬스: /ready
  Level 2 - 기본 API: labels, label values
  Level 3 - 데이터 파이프라인: 실제 로그 수집 및 structured_metadata 저장 확인

실행:
  docker compose -f docker-compose.yml -f docker-compose.test.yml --profile observability up -d --build
  cd tests/infra && uv run pytest test_loki.py -v
"""
import requests


class TestLoki:
    """Loki 로그 집계 인프라 테스트"""

    # ──────────────────────────────────────────────────────────────────────────
    # Level 1: 서비스 헬스
    # ──────────────────────────────────────────────────────────────────────────

    def test_loki_ready(self, loki_url: str):
        """/ready 엔드포인트가 200 + 'ready' 응답을 반환하는지 검증"""
        response = requests.get(f"{loki_url}/ready", timeout=10)

        assert response.status_code == 200, \
            f"Loki /ready should return 200 (Got {response.status_code})"
        assert "ready" in response.text.lower(), \
            f"Loki /ready response should contain 'ready', got: {response.text}"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 2: 기본 API
    # ──────────────────────────────────────────────────────────────────────────

    def test_loki_service_label_exists(self, loki_url: str):
        """/loki/api/v1/labels 응답에 'service' 레이블이 포함되는지 검증.

        Promtail이 Docker 컨테이너를 발견하고 레이블을 부여했음을 확인.
        """
        response = requests.get(f"{loki_url}/loki/api/v1/labels", timeout=10)

        assert response.status_code == 200, \
            f"Loki labels API should return 200 (Got {response.status_code})"

        data = response.json()
        assert data.get("status") == "success", \
            f"Loki labels response status should be 'success', got: {data.get('status')}"
        assert "service" in data.get("data", []), \
            f"'service' label should exist. Available labels: {data.get('data', [])}"

    def test_loki_level_label_exists(self, loki_url: str):
        """/loki/api/v1/labels 응답에 'level' 레이블이 포함되는지 검증.

        Promtail pipeline_stages의 labels.level 단계가 정상 동작함을 확인.
        """
        response = requests.get(f"{loki_url}/loki/api/v1/labels", timeout=10)

        assert response.status_code == 200
        data = response.json()
        assert "level" in data.get("data", []), \
            f"'level' label should exist (from pipeline_stages). Available labels: {data.get('data', [])}"

    def test_loki_level_label_has_valid_values(self, loki_url: str):
        """level 레이블 값이 유효한 로그 레벨(INFO 등)을 포함하는지 검증.

        Promtail pipeline의 labels 단계가 올바른 레벨 값을 추출했는지 확인.
        Spring Boot 기동 시 INFO 레벨 로그가 반드시 존재해야 함.
        """
        response = requests.get(
            f"{loki_url}/loki/api/v1/label/level/values",
            timeout=10,
        )

        assert response.status_code == 200, \
            f"Loki label values API should return 200 (Got {response.status_code})"

        data = response.json()
        level_values = data.get("data", [])
        assert "INFO" in level_values, \
            f"'INFO' should be in level label values. Got: {level_values}"

    def test_loki_all_services_collected(self, loki_url: str):
        """4개 서비스 모두 Loki service 레이블 값에 존재하는지 검증.

        Promtail은 Docker 컨테이너의 com.docker.compose.service 레이블(서비스 이름)을
        Loki 'service' 레이블로 매핑한다.
        test_prometheus.py / test_tempo.py와 일관되게 4개 서비스 모두 검증.
        """
        response = requests.get(
            f"{loki_url}/loki/api/v1/label/service/values",
            timeout=10,
        )

        assert response.status_code == 200, \
            f"Loki label values API should return 200 (Got {response.status_code})"

        data = response.json()
        services = set(data.get("data", []))
        expected = {"api-gateway", "user-service", "planner-service", "catalog-service"}
        missing = expected - services
        assert not missing, \
            f"Services missing from Loki: {missing}. Collected services: {services}"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 3: 데이터 파이프라인
    # ──────────────────────────────────────────────────────────────────────────

    def test_loki_logs_queryable_by_service(self, loki_url: str):
        """4개 서비스 로그가 각각 LogQL로 조회 가능한지 검증.

        test_prometheus.py / test_tempo.py와 일관되게 4개 서비스 모두 검증.
        """
        services = ["api-gateway", "user-service", "planner-service", "catalog-service"]
        for service in services:
            response = requests.get(
                f"{loki_url}/loki/api/v1/query_range",
                params={"query": f'{{service="{service}"}}', "limit": 5},
                timeout=10,
            )

            assert response.status_code == 200, \
                f"Loki query_range should return 200 for {service} (Got {response.status_code}): {response.text}"

            data = response.json()
            assert data.get("status") == "success", \
                f"Loki query for {service} should succeed"
            results = data.get("data", {}).get("result", [])
            assert results, \
                f"{service} 로그가 Loki에 수집되어야 합니다. Observability 스택 기동 후 충분한 대기 시간이 필요할 수 있습니다."

    def test_loki_structured_metadata_stored(self, loki_url: str):
        """traceId/requestId가 structured_metadata로 저장되는지 통계로 검증.

        Promtail pipeline의 structured_metadata 단계 동작 확인.
        detected_fields API는 로그 라인 콘텐츠만 분석하므로 structured_metadata를 반환하지 않음.
        query_range 응답의 stats.summary.totalStructuredMetadataBytesProcessed > 0으로
        실제 저장 여부를 간접 검증함.
        """
        response = requests.get(
            f"{loki_url}/loki/api/v1/query_range",
            params={"query": '{service="api-gateway"}', "limit": 1},
            timeout=10,
        )

        assert response.status_code == 200
        data = response.json()
        stats = data.get("data", {}).get("stats", {}).get("summary", {})
        assert stats.get("totalStructuredMetadataBytesProcessed", 0) > 0, \
            "structured_metadata(traceId, requestId)가 Loki에 저장되어야 합니다. " \
            "Promtail pipeline의 structured_metadata 단계를 확인하세요."

    def test_loki_log_message_is_not_raw_json(self, loki_url: str):
        """Promtail pipeline output 단계가 message 필드를 추출하는지 검증.

        pipeline_stages의 output.source: extracted_message 설정으로
        로그 라인이 원시 JSON이 아닌 message 필드 값이어야 합니다.
        """
        response = requests.get(
            f"{loki_url}/loki/api/v1/query_range",
            params={"query": '{service="api-gateway"}', "limit": 5},
            timeout=10,
        )

        assert response.status_code == 200
        data = response.json()
        results = data.get("data", {}).get("result", [])
        assert results, "No log results found"

        for stream in results:
            for entry in stream.get("values", []):
                if len(entry) >= 2:
                    log_line = entry[1]
                    assert not log_line.startswith('{"@timestamp"'), \
                        f"Log line should not be raw JSON (output stage failed). Got: {log_line[:100]}"
                    assert log_line.strip(), "Log line should not be empty"
                    return  # 첫 번째 유효한 항목으로 검증 완료
