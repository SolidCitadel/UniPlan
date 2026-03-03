"""
Gateway Security Integration Tests.

Verifies that internal APIs are not exposed through the API Gateway.
"""
from conftest import ApiClient


class TestGatewaySecurity:
    """Gateway 보안 테스트"""

    def test_internal_api_blocked_via_gateway(self, auth_client: ApiClient, test_course: dict):
        """Gateway를 통한 /internal API 접근이 차단되는지 검증"""
        # Given: A valid course ID
        course_id = test_course["id"]

        # When: Accessing /internal/courses via Gateway
        response = auth_client.get(f"/internal/courses?ids={course_id}")

        # Then: Should be blocked (404 Not Found as per FilterConfig)
        assert response.status_code == 404, \
            f"Internal API should be blocked by Gateway (Expected 404, Got {response.status_code})"
