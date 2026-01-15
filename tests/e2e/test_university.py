"""
대학 E2E 테스트.

Happy path + Edge cases for university operations.
"""
import pytest
from conftest import ApiClient, Endpoints


class TestUniversity:
    """대학 테스트"""

    # ==================== Happy Path ====================

    def test_get_universities(self, api_client: ApiClient):
        """대학 목록 조회 (인증 불필요)"""
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        universities = response.json()
        assert isinstance(universities, list)
        assert len(universities) > 0, "최소 1개 이상의 대학이 존재해야 합니다"

        # 대학 데이터 구조 확인
        university = universities[0]
        assert "id" in university
        assert "name" in university
        assert "code" in university

    def test_get_universities_without_auth(self, api_client: ApiClient):
        """인증 없이 대학 목록 조회 가능 확인"""
        api_client.clear_token()
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        universities = response.json()
        assert isinstance(universities, list)

    def test_university_data_integrity(self, api_client: ApiClient):
        """대학 데이터 무결성 확인"""
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        universities = response.json()
        codes = [u["code"] for u in universities]

        # 코드 중복 없어야 함
        assert len(codes) == len(set(codes)), "대학 코드는 고유해야 합니다"

        # 이름과 코드가 비어있으면 안됨
        for university in universities:
            assert university["name"], "대학 이름은 비어있으면 안됩니다"
            assert university["code"], "대학 코드는 비어있으면 안됩니다"

    # ==================== Edge Cases ====================

    def test_universities_response_format(self, api_client: ApiClient):
        """대학 목록 응답 형식 검증"""
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        # 응답은 배열 형식이어야 함 (Page 형식이 아님)
        universities = response.json()
        assert isinstance(universities, list), "대학 목록은 배열 형식이어야 합니다"
