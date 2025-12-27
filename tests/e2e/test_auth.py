"""
인증 E2E 테스트.

Happy path + Edge cases for authentication.
"""
import uuid

import pytest
from conftest import ApiClient, Endpoints, TestUser


class TestAuth:
    """인증 테스트"""

    # ==================== Happy Path ====================

    def test_signup_and_login(self, api_client: ApiClient):
        """회원가입 및 로그인"""
        unique_id = uuid.uuid4().hex[:8]
        email = f"auth_test_{unique_id}@example.com"
        password = "Test1234!"
        name = f"Auth Test {unique_id}"

        # 회원가입
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={"email": email, "password": password, "name": name},
        )
        assert response.status_code in (200, 201)

        # 로그인
        response = api_client.post(
            Endpoints.AUTH_LOGIN,
            json={"email": email, "password": password},
        )
        assert response.status_code == 200

        data = response.json()
        assert "accessToken" in data
        assert "refreshToken" in data
        assert data["user"]["email"] == email

    def test_get_current_user(self, auth_client: ApiClient, test_user: TestUser):
        """현재 사용자 정보 조회"""
        response = auth_client.get(Endpoints.USER_ME)
        assert response.status_code == 200

        data = response.json()
        assert data["email"] == test_user.email
        assert data["name"] == test_user.name

    # ==================== Edge Cases ====================

    def test_signup_duplicate_email(self, api_client: ApiClient, test_user: TestUser):
        """이미 가입된 이메일로 회원가입 시도"""
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={
                "email": test_user.email,
                "password": "Test1234!",
                "name": "Duplicate User"
            }
        )
        assert response.status_code in (400, 409), "중복 이메일은 거부되어야 합니다"

    def test_login_wrong_password(self, api_client: ApiClient, test_user: TestUser):
        """잘못된 비밀번호로 로그인 시도"""
        response = api_client.post(
            Endpoints.AUTH_LOGIN,
            json={
                "email": test_user.email,
                "password": "WrongPassword123!"
            }
        )
        assert response.status_code in (400, 401)

    def test_login_nonexistent_email(self, api_client: ApiClient):
        """존재하지 않는 이메일로 로그인 시도"""
        response = api_client.post(
            Endpoints.AUTH_LOGIN,
            json={
                "email": "nonexistent@example.com",
                "password": "Test1234!"
            }
        )
        assert response.status_code in (400, 401, 404)

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
            json={"password": "Test1234!", "name": "Test"}
        )
        assert response.status_code == 400

        # 비밀번호 누락
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={"email": "test@test.com", "name": "Test"}
        )
        assert response.status_code == 400

    def test_signup_invalid_email_format(self, api_client: ApiClient):
        """잘못된 이메일 형식으로 회원가입"""
        response = api_client.post(
            Endpoints.AUTH_SIGNUP,
            json={
                "email": "not-an-email",
                "password": "Test1234!",
                "name": "Test"
            }
        )
        assert response.status_code == 400
