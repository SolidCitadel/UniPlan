"""
Prometheus 메트릭 수집 인프라 테스트.

검증 계층:
  Level 1 - 서비스 헬스: /-/healthy, /-/ready
  Level 2 - Scrape 상태: /api/v1/targets (4개 서비스 모두 수집 중인지)
  Level 3 - 실제 메트릭: Spring Boot 메트릭이 실제로 수집됐는지

실행:
  docker compose -f docker-compose.yml -f docker-compose.test.yml --profile observability up -d --build
  cd tests/infra && uv run pytest test_prometheus.py -v
"""
import requests


EXPECTED_SERVICES = {"api-gateway", "user-service", "planner-service", "catalog-service"}


class TestPrometheus:
    """Prometheus 메트릭 수집 인프라 테스트"""

    # ──────────────────────────────────────────────────────────────────────────
    # Level 1: 서비스 헬스
    # ──────────────────────────────────────────────────────────────────────────

    def test_prometheus_healthy(self, prometheus_url: str):
        """Prometheus가 정상 상태인지 검증 (/-/healthy)."""
        response = requests.get(f"{prometheus_url}/-/healthy", timeout=10)

        assert response.status_code == 200, \
            f"Prometheus /-/healthy should return 200 (Got {response.status_code})"

    def test_prometheus_ready(self, prometheus_url: str):
        """Prometheus가 쿼리를 처리할 준비가 됐는지 검증 (/-/ready)."""
        response = requests.get(f"{prometheus_url}/-/ready", timeout=10)

        assert response.status_code == 200, \
            f"Prometheus /-/ready should return 200 (Got {response.status_code})"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 2: Scrape 상태
    # ──────────────────────────────────────────────────────────────────────────

    def test_prometheus_scrapes_all_services(self, prometheus_url: str):
        """4개 서비스(api-gateway, user-service, planner-service, catalog-service) 모두 scrape 중인지 검증.

        각 서비스의 /actuator/prometheus 엔드포인트를 Prometheus가 수집하고 있어야 함.
        """
        response = requests.get(f"{prometheus_url}/api/v1/targets", timeout=10)

        assert response.status_code == 200, \
            f"Prometheus targets API should return 200 (Got {response.status_code})"

        data = response.json()
        assert data.get("status") == "success"

        active_targets = data.get("data", {}).get("activeTargets", [])
        up_services = {
            t["labels"].get("application", t["labels"].get("job", ""))
            for t in active_targets
            if t.get("health") == "up"
        }
        down_errors = {
            t["labels"].get("job", ""): t.get("lastError", "")
            for t in active_targets
            if t.get("health") != "up"
        }

        missing = EXPECTED_SERVICES - up_services
        assert not missing, \
            f"다음 서비스의 Prometheus scrape 상태가 'up'이 아닙니다: {missing}. " \
            f"현재 up 상태 서비스: {up_services}. " \
            f"down 상태 서비스 오류: {down_errors}"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 3: 실제 메트릭
    # ──────────────────────────────────────────────────────────────────────────

    def test_prometheus_spring_application_metrics(self, prometheus_url: str):
        """Spring Boot application 레이블이 포함된 메트릭이 수집됐는지 검증.

        management.metrics.tags.application 설정으로 Spring Boot가 export하는
        모든 메트릭에 application 레이블이 자동 부여된다.
        Prometheus의 up 메트릭은 자체 메타 메트릭이라 application 레이블이 없으므로
        jvm_memory_used_bytes(Spring Boot export)로 검증한다.
        """
        response = requests.get(
            f"{prometheus_url}/api/v1/query",
            params={"query": 'jvm_memory_used_bytes{application=~".+"}'},
            timeout=10,
        )

        assert response.status_code == 200
        data = response.json()
        assert data.get("status") == "success"
        results = data.get("data", {}).get("result", [])
        assert results, \
            "Spring Boot 서비스의 jvm_memory_used_bytes 메트릭이 없습니다. " \
            "application 레이블을 포함한 서비스가 scrape되어야 합니다."

        applications = {r["metric"].get("application") for r in results}
        assert len(applications) == 4, \
            f"4개 서비스 모두 application 레이블이 있어야 합니다. 실제: {applications}"

    def test_prometheus_http_request_metrics(self, prometheus_url: str):
        """HTTP 요청 메트릭(http_server_requests_seconds_count)이 수집됐는지 검증.

        API 트래픽 생성 후 Spring Boot Actuator의 HTTP 요청 메트릭이 존재해야 함.
        """
        response = requests.get(
            f"{prometheus_url}/api/v1/query",
            params={"query": "http_server_requests_seconds_count"},
            timeout=10,
        )

        assert response.status_code == 200
        data = response.json()
        assert data.get("status") == "success"
        results = data.get("data", {}).get("result", [])
        assert results, \
            "HTTP 요청 메트릭이 없습니다. " \
            "API 트래픽 생성 후 http_server_requests_seconds_count 메트릭이 존재해야 합니다."
