"""
Pytest configuration and fixtures for API tests.
"""
import os
import uuid
from dataclasses import dataclass
from typing import Generator

import pytest
import requests
from dotenv import load_dotenv

load_dotenv()


@dataclass
class TestUser:
    """Test user credentials and tokens."""
    email: str
    password: str
    name: str
    university_id: int = 1  # 기본 대학 (경희대)
    access_token: str | None = None
    refresh_token: str | None = None
    user_id: int | None = None


class ApiClient:
    """HTTP client for API testing."""

    def __init__(self, base_url: str):
        self.base_url = base_url.rstrip("/")
        self.session = requests.Session()
        self.token: str | None = None

    def set_token(self, token: str) -> None:
        """Set the authorization token."""
        self.token = token
        self.session.headers["Authorization"] = f"Bearer {token}"

    def clear_token(self) -> None:
        """Clear the authorization token."""
        self.token = None
        self.session.headers.pop("Authorization", None)

    def get(self, path: str, **kwargs) -> requests.Response:
        return self.session.get(f"{self.base_url}{path}", **kwargs)

    def post(self, path: str, **kwargs) -> requests.Response:
        return self.session.post(f"{self.base_url}{path}", **kwargs)

    def patch(self, path: str, **kwargs) -> requests.Response:
        return self.session.patch(f"{self.base_url}{path}", **kwargs)

    def delete(self, path: str, **kwargs) -> requests.Response:
        return self.session.delete(f"{self.base_url}{path}", **kwargs)


@pytest.fixture(scope="session")
def api_base_url() -> str:
    """Get API base URL from environment."""
    return os.getenv("API_BASE_URL", "http://localhost:8080")


@pytest.fixture(scope="session")
def api_client(api_base_url: str) -> ApiClient:
    """Create an API client instance."""
    return ApiClient(api_base_url)


@pytest.fixture(scope="session")
def test_user(api_client: ApiClient) -> Generator[TestUser, None, None]:
    """Create a test user for the session and clean up after."""
    unique_id = uuid.uuid4().hex[:8]

    # Get available university (default to 1 if API fails)
    university_id = 1
    try:
        response = api_client.get("/api/v1/universities")
        if response.status_code == 200:
            universities = response.json()
            if universities:
                university_id = universities[0]["id"]
    except Exception:
        pass  # Use default university_id = 1

    user = TestUser(
        email=f"test_{unique_id}@example.com",
        password="Test1234!",
        name=f"Test User {unique_id}",
        university_id=university_id,
    )

    # Signup (with universityId)
    response = api_client.post(
        "/api/v1/auth/signup",
        json={
            "email": user.email,
            "password": user.password,
            "name": user.name,
            "universityId": user.university_id,
        },
    )
    assert response.status_code in (200, 201), f"Signup failed: {response.text}"

    # Login
    response = api_client.post(
        "/api/v1/auth/login",
        json={"email": user.email, "password": user.password},
    )
    assert response.status_code == 200, f"Login failed: {response.text}"

    data = response.json()
    user.access_token = data["accessToken"]
    user.refresh_token = data["refreshToken"]
    user.user_id = data["user"]["id"]

    yield user

    # Cleanup: could delete user here if API supports it


@pytest.fixture
def auth_client(api_client: ApiClient, test_user: TestUser) -> ApiClient:
    """Get an authenticated API client."""
    api_client.set_token(test_user.access_token)
    return api_client


# API Endpoints
class Endpoints:
    AUTH_LOGIN = "/api/v1/auth/login"
    AUTH_SIGNUP = "/api/v1/auth/signup"
    USER_ME = "/api/v1/users/me"
    UNIVERSITIES = "/api/v1/universities"
    COURSES = "/api/v1/courses"
    WISHLIST = "/api/v1/wishlist"
    TIMETABLES = "/api/v1/timetables"
    SCENARIOS = "/api/v1/scenarios"
    REGISTRATIONS = "/api/v1/registrations"


@pytest.fixture
def endpoints() -> type[Endpoints]:
    """Get API endpoints."""
    return Endpoints


@pytest.fixture(scope="session")
def catalog_service_url() -> str:
    """Get catalog-service URL for direct import API calls."""
    return os.getenv("CATALOG_SERVICE_URL", "http://localhost:8083")


@pytest.fixture(scope="session")
def test_course(api_client: ApiClient, catalog_service_url: str) -> dict | None:
    """Create a test course for the session via import APIs.
    
    Calls catalog-service directly for import, then uses API gateway to fetch.
    Returns the created course data or None if creation fails.
    """
    import requests
    
    # 1. Import metadata (college, department, courseType) - direct to catalog-service
    metadata_request = {
        "year": 2026,
        "semester": 1,
        "crawled_at": "2026-01-17T00:00:00",
        "colleges": {
            "TEST_COL": {
                "code": "TEST_COL",
                "name": "테스트단과대학",
                "nameEn": "Test College"
            }
        },
        "departments": {
            "TEST_DEPT": {
                "code": "TEST_DEPT",
                "name": "테스트학과",
                "nameEn": "Test Department",
                "collegeCode": "TEST_COL",
                "level": "학부"
            }
        },
        "courseTypes": {
            "TEST_TYPE": {
                "code": "TEST_TYPE",
                "nameKr": "테스트과목유형",
                "nameEn": "Test Course Type"
            }
        }
    }
    
    try:
        response = requests.post(
            f"{catalog_service_url}/metadata/import",
            json=metadata_request,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        if response.status_code != 200:
            print(f"Metadata import failed: {response.status_code} - {response.text[:200]}")
            return None
    except Exception as e:
        print(f"Metadata import error: {e}")
        return None
    
    # 2. Import course - direct to catalog-service
    course_request = [{
        "openingYear": 2026,
        "semester": "1학기",
        "targetGrade": 1,
        "courseCode": "TEST001",
        "section": "01",
        "courseName": "테스트과목",
        "professor": "테스트교수",
        "credits": 3,
        "classroom": "테스트관 101",
        "campus": "서울",
        "departmentCodes": ["TEST_DEPT"],
        "courseTypeCode": "TEST_TYPE",
        "notes": "E2E 테스트용 과목",
        "classTime": [
            {"day": "월", "startTime": "09:00", "endTime": "10:30"},
            {"day": "수", "startTime": "09:00", "endTime": "10:30"}
        ],
        "universityId": 1
    }]
    
    try:
        response = requests.post(
            f"{catalog_service_url}/courses/import",
            json=course_request,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        if response.status_code != 200:
            print(f"Course import failed: {response.status_code} - {response.text[:200]}")
            return None
    except Exception as e:
        print(f"Course import error: {e}")
        return None
    
    # 3. Fetch the created course directly from catalog-service (no auth needed)
    try:
        response = requests.get(
            f"{catalog_service_url}/courses?query=테스트과목&size=1",
            timeout=10
        )
        if response.status_code == 200:
            data = response.json()
            courses = data.get("content", data) if isinstance(data, dict) else data
            if courses:
                return courses[0]
    except Exception as e:
        print(f"Course fetch error: {e}")
    
    return None
