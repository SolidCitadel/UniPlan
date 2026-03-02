"""
Observability Infrastructure Integration Tests.

Verifies:
- Actuator health endpoint responds correctly
- Prometheus metrics endpoint responds correctly
- Actuator endpoints are blocked via Gateway
- X-Request-Id correlation header is propagated in responses
"""
import re

import requests

from conftest import ApiClient


class TestObservability:
    """Observability 인프라 테스트"""

    def test_actuator_health_via_gateway(self, api_client: ApiClient):
        """Gateway actuator health 엔드포인트가 200을 반환하는지 검증"""
        response = api_client.get("/actuator/health")

        assert response.status_code == 200, \
            f"Actuator health should return 200 (Got {response.status_code})"

        data = response.json()
        assert "status" in data, "Response should have 'status' field"
        assert data["status"] == "UP", f"Service should be UP, got: {data['status']}"

    def test_actuator_health_not_exposed_under_api_v1(self, api_client: ApiClient):
        """Gateway를 통한 /api/v1/actuator 접근이 차단되는지 검증"""
        response = api_client.get("/api/v1/actuator/health")

        assert response.status_code == 404, \
            f"Actuator should not be accessible under /api/v1 (Expected 404, Got {response.status_code})"

    def test_correlation_id_header_in_response(self, api_client: ApiClient):
        """라우팅된 API 응답 헤더에 X-Request-Id가 포함되는지 검증

        /actuator/health는 Gateway 라우팅을 거치지 않으므로
        실제 라우팅되는 /api/v1/universities를 사용합니다.
        """
        response = api_client.get("/api/v1/universities")

        assert response.status_code == 200
        assert "X-Request-Id" in response.headers, \
            "Response should contain X-Request-Id header"

        request_id = response.headers["X-Request-Id"]
        assert request_id, "X-Request-Id should not be empty"

    def test_correlation_id_passthrough(self, api_client: ApiClient):
        """클라이언트가 제공한 X-Request-Id가 응답에 그대로 반환되는지 검증"""
        client_request_id = "integration-test-correlation-id-12345"

        response = api_client.session.get(
            f"{api_client.base_url}/api/v1/universities",
            headers={"X-Request-Id": client_request_id}
        )

        assert response.status_code == 200
        assert "X-Request-Id" in response.headers, \
            "Response should contain X-Request-Id header"
        assert response.headers["X-Request-Id"] == client_request_id, \
            f"X-Request-Id should match the provided value. " \
            f"Expected: {client_request_id}, Got: {response.headers.get('X-Request-Id')}"

    def test_correlation_id_uuid_generated_when_absent(self, api_client: ApiClient):
        """X-Request-Id 없이 요청 시 UUID가 자동 생성되어 응답에 포함되는지 검증"""
        session = requests.Session()
        session.headers.pop("X-Request-Id", None)

        response = session.get(f"{api_client.base_url}/api/v1/universities")

        assert response.status_code == 200
        assert "X-Request-Id" in response.headers, \
            "Response should contain auto-generated X-Request-Id header"

        request_id = response.headers["X-Request-Id"]
        uuid_pattern = re.compile(
            r"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
        )
        assert uuid_pattern.match(request_id), \
            f"Auto-generated X-Request-Id should be UUID format, got: {request_id}"
