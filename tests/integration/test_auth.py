"""
인증 E2E 테스트.

Happy path + Edge cases for authentication.
"""
import uuid

import pytest
from conftest import ApiClient, Endpoints, TestUser
from models.generated.user_models import UserResponse, AuthResponse


class TestAuth:
    """인증 테스트"""

    # ==================== Happy Path ====================

    def test_signup_and_login(self, api_client: ApiClient):
        """회원가입 및 로그인"""
        api_client.clear_token()  # 다른 테스트로부터의 오염 방지
        unique_id = uuid.uuid4().hex[:8]
        email = f"auth_test_{unique_id}@example.com"
        password = "Test1234!"
        name = f"Auth Test {unique_id}"

        # 대학 목록 조회 (검증 생략 - Fixture에서 보장한다고 가정하거나 간단 체크)
        response = api_client.get(Endpoints.UNIVERSITIES)
        universities = response.json()
        university_id = universities[0]["id"]

        # 회원가입 (universityId 포함)
        auth_data = api_client.post_dto(
            Endpoints.AUTH_SIGNUP,
            model=AuthResponse,
            json={
                "email": email,
                "password": password,
                "name": name,
                "universityId": university_id,
            },
            # Default is 201
        )
        
        # 회원가입 응답에 대학 정보 포함 확인
        assert auth_data.user.universityId == university_id
        assert auth_data.user.universityName is not None

        # 로그인
        login_data = api_client.post_dto(
            Endpoints.AUTH_LOGIN,
            model=AuthResponse,
            json={"email": email, "password": password},
            expected_status=200
        )
        
        assert login_data.accessToken is not None
        assert login_data.refreshToken is not None
        assert login_data.user.email == email
        assert login_data.user.universityId == university_id

    def test_get_current_user(self, auth_client: ApiClient, test_user: TestUser):
        """현재 사용자 정보 조회 - Pydantic 모델로 응답 스키마 검증"""
        # Pydantic 모델로 파싱 - 필드 누락 시 ValidationError 발생
        user = auth_client.get_dto(
            Endpoints.USER_ME,
            model=UserResponse
        )

        # 값 검증
        assert user.email == test_user.email
        assert user.name == test_user.name
        assert user.universityId == test_user.university_id

    # ==================== Edge Cases ====================

    def test_signup_duplicate_email(self, api_client: ApiClient, test_user: TestUser):
        """이미 가입된 이메일로 회원가입 시도"""
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={
                "email": test_user.email,
                "password": "Test1234!",
                "name": "Duplicate User",
                "universityId": test_user.university_id,
            }
        )
        assert response.status_code == 409, "중복 이메일은 409 Conflict"

    def test_login_wrong_password(self, api_client: ApiClient, test_user: TestUser):
        """잘못된 비밀번호로 로그인 시도"""
        response = api_client.post(
            Endpoints.AUTH_LOGIN,
            json={
                "email": test_user.email,
                "password": "WrongPassword123!"
            }
        )
        assert response.status_code == 401, "잘못된 비밀번호는 401 Unauthorized"

    def test_login_nonexistent_email(self, api_client: ApiClient):
        """존재하지 않는 이메일로 로그인 시도"""
        response = api_client.post(
            Endpoints.AUTH_LOGIN,
            json={
                "email": "nonexistent@example.com",
                "password": "Test1234!"
            }
        )
        assert response.status_code == 401, "존재하지 않는 이메일은 401 Unauthorized"

    def test_access_without_token(self, api_client: ApiClient):
        """토큰 없이 인증 필수 엔드포인트 접근"""
        api_client.clear_token()
        response = api_client.get(Endpoints.USER_ME)
        assert response.status_code == 401

    def test_access_with_invalid_token(self, api_client: ApiClient):
        """잘못된 토큰으로 접근"""
        api_client.set_token("invalid.jwt.token")
        response = api_client.get(Endpoints.USER_ME)
        assert response.status_code == 401
        api_client.clear_token()

    def test_signup_missing_fields(self, api_client: ApiClient):
        """필수 필드 누락 회원가입"""
        # 이메일 누락
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={"password": "Test1234!", "name": "Test", "universityId": 1}
        )
        assert response.status_code == 400

        # 비밀번호 누락
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={"email": "test@test.com", "name": "Test", "universityId": 1}
        )
        assert response.status_code == 400

        # universityId 누락
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={"email": "test@test.com", "password": "Test1234!", "name": "Test"}
        )
        assert response.status_code == 400

    def test_signup_invalid_email_format(self, api_client: ApiClient):
        """잘못된 이메일 형식으로 회원가입"""
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={
                "email": "not-an-email",
                "password": "Test1234!",
                "name": "Test",
                "universityId": 1,
            }
        )
        assert response.status_code == 400
