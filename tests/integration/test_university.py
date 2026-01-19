"""
대학 E2E 테스트.

Happy path + Edge cases for university operations.
"""
import pytest
from conftest import ApiClient, Endpoints
from models.generated.user_models import UniversityResponse


class TestUniversity:
    """대학 테스트"""

    # ==================== Happy Path ====================

    def test_get_universities(self, api_client: ApiClient):
        """대학 목록 조회 (인증 불필요)"""
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        data = response.json()
        assert isinstance(data, list)
        
        # Pydantic 모델 검증
        universities = [UniversityResponse(**item) for item in data]
        assert len(universities) > 0, "최소 1개 이상의 대학이 존재해야 합니다"

        # 대학 데이터 구조 및 값 확인 (Pydantic 파싱 성공 시 구조는 보장됨)
        university = universities[0]
        assert university.id is not None
        assert university.name
        assert university.code

    def test_get_universities_without_auth(self, api_client: ApiClient):
        """인증 없이 대학 목록 조회 가능 확인"""
        api_client.clear_token()
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        data = response.json()
        # Pydantic 모델 검증
        [UniversityResponse(**item) for item in data]

    def test_university_data_integrity(self, api_client: ApiClient):
        """대학 데이터 무결성 확인"""
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        universities = [UniversityResponse(**item) for item in response.json()]
        codes = [u.code for u in universities]

        # 코드 중복 없어야 함
        assert len(codes) == len(set(codes)), "대학 코드는 고유해야 합니다"

        # 이름과 코드가 비어있으면 안됨
        for university in universities:
            assert university.name, "대학 이름은 비어있으면 안됩니다"
            assert university.code, "대학 코드는 비어있으면 안됩니다"

    # ==================== Edge Cases ====================

    def test_universities_response_format(self, api_client: ApiClient):
        """대학 목록 응답 형식 검증"""
        response = api_client.get(Endpoints.UNIVERSITIES)
        assert response.status_code == 200

        # 응답은 배열 형식이어야 하며, 각 항목은 UniversityResponse 스키마를 따름
        data = response.json()
        assert isinstance(data, list), "대학 목록은 배열 형식이어야 합니다"
        [UniversityResponse(**item) for item in data]
