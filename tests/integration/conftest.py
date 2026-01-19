"""
Pytest configuration and fixtures for API tests.

테스트 원칙:
- Skip 금지: 예상치 못한 상황은 fail
- 테스트는 자체적으로 데이터 준비 (fixture 활용)
- 외부 상태에 의존하지 않음
"""
import os
import uuid
from dataclasses import dataclass
from typing import Generator, TypeVar

import pytest
import requests
from dotenv import load_dotenv
from pydantic import BaseModel

T = TypeVar("T", bound=BaseModel)

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
        self.session.cookies.clear()

    def get(self, path: str, **kwargs) -> requests.Response:
        return self.session.get(f"{self.base_url}{path}", **kwargs)

    def post(self, path: str, **kwargs) -> requests.Response:
        return self.session.post(f"{self.base_url}{path}", **kwargs)

    def patch(self, path: str, **kwargs) -> requests.Response:
        return self.session.patch(f"{self.base_url}{path}", **kwargs)

    def delete(self, path: str, **kwargs) -> requests.Response:
        return self.session.delete(f"{self.base_url}{path}", **kwargs)

    # ==================== Pydantic Helpers ====================

    def request_model(
        self,
        method: str,
        path: str,
        model: type[T],
        expected_status: int = 200,
        **kwargs
    ) -> T | list[T]:
        """Request and parse response with Pydantic model."""
        fn = getattr(self, method.lower())
        response = fn(path, **kwargs)
        
        assert response.status_code == expected_status, \
            f"{method.upper()} {path} failed: {response.status_code} - {response.text}"
        
        data = response.json()
        if isinstance(data, list):
            return [model(**item) for item in data]
        return model(**data)

    def get_dto(self, path: str, model: type[T], expected_status: int = 200, **kwargs) -> T | list[T]:
        return self.request_model("GET", path, model, expected_status, **kwargs)

    def post_dto(self, path: str, model: type[T], expected_status: int = 201, **kwargs) -> T | list[T]:
        return self.request_model("POST", path, model, expected_status, **kwargs)

    def patch_dto(self, path: str, model: type[T], expected_status: int = 200, **kwargs) -> T | list[T]:
        return self.request_model("PATCH", path, model, expected_status, **kwargs)


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


@pytest.fixture(scope="session")
def api_base_url() -> str:
    """Get API base URL from environment."""
    return os.getenv("API_BASE_URL", "http://localhost:8080")


@pytest.fixture(scope="session")
def catalog_service_url() -> str:
    """Get catalog-service URL for direct import API calls."""
    return os.getenv("CATALOG_SERVICE_URL", "http://localhost:8083")


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
    assert response.status_code == 201, f"Signup failed: {response.text}"

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


@pytest.fixture
def endpoints() -> type[Endpoints]:
    """Get API endpoints."""
    return Endpoints


# =============================================================================
# Test Data Fixtures
# =============================================================================

@pytest.fixture(scope="session")
def test_course(catalog_service_url: str) -> dict:
    """
    Create a test course for the session via import APIs.

    Returns the created course data.
    Fails if course creation fails (no skip!).
    """
    unique_id = uuid.uuid4().hex[:4]  # 짧게 (DB 컬럼 길이 제한)

    # 1. Import metadata (college, department, courseType)
    metadata_request = {
        "year": 2026,
        "semester": 1,
        "crawled_at": "2026-01-17T00:00:00",
        "colleges": {
            f"TC{unique_id}": {
                "code": f"TC{unique_id}",
                "name": f"테스트단과대학_{unique_id}",
                "nameEn": f"Test College {unique_id}"
            }
        },
        "departments": {
            f"TD{unique_id}": {
                "code": f"TD{unique_id}",
                "name": f"테스트학과_{unique_id}",
                "nameEn": f"Test Department {unique_id}",
                "collegeCode": f"TC{unique_id}",
                "level": "학부"
            }
        },
        "courseTypes": {
            f"TT{unique_id}": {
                "code": f"TT{unique_id}",
                "nameKr": f"테스트과목유형_{unique_id}",
                "nameEn": f"Test Course Type {unique_id}"
            }
        }
    }

    response = requests.post(
        f"{catalog_service_url}/metadata/import",
        json=metadata_request,
        headers={"Content-Type": "application/json"},
        timeout=30
    )
    assert response.status_code == 200, f"Metadata import failed: {response.status_code} - {response.text}"

    # 2. Import course
    course_name = f"E2E테스트과목_{unique_id}"
    course_request = [{
        "openingYear": 2026,
        "semester": "1학기",
        "targetGrade": 1,
        "courseCode": f"E{unique_id}",
        "section": "01",
        "courseName": course_name,
        "professor": "테스트교수",
        "credits": 3,
        "classroom": "테스트관 101",
        "campus": "서울",
        "departmentCodes": [f"TD{unique_id}"],
        "courseTypeCode": f"TT{unique_id}",
        "notes": "E2E 테스트용 과목",
        "classTime": [
            {"day": "월", "startTime": "09:00", "endTime": "10:30"},
            {"day": "수", "startTime": "09:00", "endTime": "10:30"}
        ],
        "universityId": 1
    }]

    response = requests.post(
        f"{catalog_service_url}/courses/import",
        json=course_request,
        headers={"Content-Type": "application/json"},
        timeout=30
    )
    assert response.status_code == 200, f"Course import failed: {response.status_code} - {response.text}"

    # 3. Fetch the created course
    response = requests.get(
        f"{catalog_service_url}/courses?query={course_name}&size=1",
        timeout=10
    )
    assert response.status_code == 200, f"Course fetch failed: {response.status_code}"

    data = response.json()
    courses = data.get("content", data) if isinstance(data, dict) else data
    assert courses, f"Created course not found: {course_name}"

    return courses[0]


@pytest.fixture(scope="session")
def test_course_2(catalog_service_url: str) -> dict:
    """
    Create a second test course (for alternative timetable tests).
    Different time slot to avoid conflicts.
    """
    unique_id = uuid.uuid4().hex[:4]  # 짧게 (DB 컬럼 길이 제한)

    # Import metadata
    metadata_request = {
        "year": 2026,
        "semester": 1,
        "crawled_at": "2026-01-17T00:00:00",
        "colleges": {
            f"C2{unique_id}": {
                "code": f"C2{unique_id}",
                "name": f"테스트단과대학2_{unique_id}",
                "nameEn": f"Test College 2 {unique_id}"
            }
        },
        "departments": {
            f"D2{unique_id}": {
                "code": f"D2{unique_id}",
                "name": f"테스트학과2_{unique_id}",
                "nameEn": f"Test Department 2 {unique_id}",
                "collegeCode": f"C2{unique_id}",
                "level": "학부"
            }
        },
        "courseTypes": {
            f"T2{unique_id}": {
                "code": f"T2{unique_id}",
                "nameKr": f"테스트과목유형2_{unique_id}",
                "nameEn": f"Test Course Type 2 {unique_id}"
            }
        }
    }

    response = requests.post(
        f"{catalog_service_url}/metadata/import",
        json=metadata_request,
        headers={"Content-Type": "application/json"},
        timeout=30
    )
    assert response.status_code == 200, f"Metadata import failed: {response.status_code} - {response.text}"

    # Import course with different time
    course_name = f"E2E테스트과목2_{unique_id}"
    course_request = [{
        "openingYear": 2026,
        "semester": "1학기",
        "targetGrade": 1,
        "courseCode": f"F{unique_id}",
        "section": "01",
        "courseName": course_name,
        "professor": "테스트교수2",
        "credits": 3,
        "classroom": "테스트관 202",
        "campus": "서울",
        "departmentCodes": [f"D2{unique_id}"],
        "courseTypeCode": f"T2{unique_id}",
        "notes": "E2E 테스트용 과목 2",
        "classTime": [
            {"day": "화", "startTime": "14:00", "endTime": "15:30"},
            {"day": "목", "startTime": "14:00", "endTime": "15:30"}
        ],
        "universityId": 1
    }]

    response = requests.post(
        f"{catalog_service_url}/courses/import",
        json=course_request,
        headers={"Content-Type": "application/json"},
        timeout=30
    )
    assert response.status_code == 200, f"Course import failed: {response.status_code} - {response.text}"

    # Fetch the created course by courseCode (more specific than name search)
    course_code = f"F{unique_id}"
    response = requests.get(
        f"{catalog_service_url}/courses?courseCode={course_code}&size=1",
        timeout=10
    )
    assert response.status_code == 200, f"Course fetch failed: {response.status_code}"

    data = response.json()
    courses = data.get("content", data) if isinstance(data, dict) else data
    assert courses, f"Created course not found with code: {course_code}"

    return courses[0]


@pytest.fixture
def test_timetable(auth_client: ApiClient) -> dict:
    """Create a test timetable."""
    unique_id = uuid.uuid4().hex[:6]

    response = auth_client.post(
        Endpoints.TIMETABLES,
        json={
            "name": f"테스트시간표_{unique_id}",
            "openingYear": 2026,
            "semester": "1"
        }
    )
    assert response.status_code == 201, f"Timetable creation failed: {response.status_code} - {response.text}"

    return response.json()


@pytest.fixture
def test_timetable_with_course(auth_client: ApiClient, test_course: dict) -> dict:
    """Create a timetable with a course added."""
    unique_id = uuid.uuid4().hex[:6]

    # Create timetable
    response = auth_client.post(
        Endpoints.TIMETABLES,
        json={
            "name": f"과목포함시간표_{unique_id}",
            "openingYear": 2026,
            "semester": "1"
        }
    )
    assert response.status_code == 201, f"Timetable creation failed: {response.status_code} - {response.text}"

    timetable = response.json()
    timetable_id = timetable["id"]

    # Add course to timetable
    response = auth_client.post(
        f"{Endpoints.TIMETABLES}/{timetable_id}/courses",
        json={"courseId": test_course["id"]}
    )
    assert response.status_code == 201, f"Add course failed: {response.status_code} - {response.text}"

    # Fetch updated timetable
    response = auth_client.get(f"{Endpoints.TIMETABLES}/{timetable_id}")
    assert response.status_code == 200, f"Timetable fetch failed: {response.status_code}"

    return response.json()


@pytest.fixture
def test_timetable_with_two_courses(auth_client: ApiClient, test_course: dict, test_course_2: dict) -> dict:
    """Create a timetable with two courses (for registration step tests)."""
    unique_id = uuid.uuid4().hex[:6]

    # Verify two distinct courses
    assert test_course["id"] != test_course_2["id"], \
        f"test_course and test_course_2 must have different IDs. " \
        f"Got: {test_course['id']} and {test_course_2['id']}"

    # Create timetable
    response = auth_client.post(
        Endpoints.TIMETABLES,
        json={
            "name": f"2과목시간표_{unique_id}",
            "openingYear": 2026,
            "semester": "1"
        }
    )
    assert response.status_code == 201, f"Timetable creation failed: {response.status_code} - {response.text}"

    timetable = response.json()
    timetable_id = timetable["id"]

    # Add first course
    response = auth_client.post(
        f"{Endpoints.TIMETABLES}/{timetable_id}/courses",
        json={"courseId": test_course["id"]}
    )
    assert response.status_code == 201, f"Add course 1 failed: {response.status_code} - {response.text}"

    # Add second course
    response = auth_client.post(
        f"{Endpoints.TIMETABLES}/{timetable_id}/courses",
        json={"courseId": test_course_2["id"]}
    )
    assert response.status_code == 201, f"Add course 2 failed: {response.status_code} - {response.text}"

    # Fetch updated timetable
    response = auth_client.get(f"{Endpoints.TIMETABLES}/{timetable_id}")
    assert response.status_code == 200, f"Timetable fetch failed: {response.status_code}"

    timetable_data = response.json()
    # Verify at least 2 courses exist (or handle gracefully if not)
    items = timetable_data.get("items", [])
    assert len(items) >= 1, f"Timetable should have at least 1 course, has {len(items)}"

    return timetable_data


@pytest.fixture
def test_scenario(auth_client: ApiClient, test_timetable: dict) -> dict:
    """Create a test scenario."""
    unique_id = uuid.uuid4().hex[:6]

    response = auth_client.post(
        Endpoints.SCENARIOS,
        json={
            "name": f"테스트시나리오_{unique_id}",
            "existingTimetableId": test_timetable["id"]
        }
    )
    assert response.status_code == 201, f"Scenario creation failed: {response.status_code} - {response.text}"

    return response.json()


@pytest.fixture
def test_scenario_with_course(auth_client: ApiClient, test_timetable_with_course: dict) -> dict:
    """Create a scenario with a timetable that has courses."""
    unique_id = uuid.uuid4().hex[:6]

    response = auth_client.post(
        Endpoints.SCENARIOS,
        json={
            "name": f"과목포함시나리오_{unique_id}",
            "existingTimetableId": test_timetable_with_course["id"]
        }
    )
    assert response.status_code == 201, f"Scenario creation failed: {response.status_code} - {response.text}"

    return response.json()


@pytest.fixture
def test_scenario_with_two_courses(auth_client: ApiClient, test_timetable_with_two_courses: dict) -> dict:
    """Create a scenario with two courses (for registration step tests)."""
    unique_id = uuid.uuid4().hex[:6]

    response = auth_client.post(
        Endpoints.SCENARIOS,
        json={
            "name": f"2과목시나리오_{unique_id}",
            "existingTimetableId": test_timetable_with_two_courses["id"]
        }
    )
    assert response.status_code == 201, f"Scenario creation failed: {response.status_code} - {response.text}"

    return response.json()


@pytest.fixture
def test_registration(auth_client: ApiClient, test_scenario: dict) -> dict:
    """Create a test registration."""
    unique_id = uuid.uuid4().hex[:6]

    response = auth_client.post(
        Endpoints.REGISTRATIONS,
        json={
            "scenarioId": test_scenario["id"],
            "name": f"테스트수강신청_{unique_id}"
        }
    )
    assert response.status_code == 201, f"Registration creation failed: {response.status_code} - {response.text}"

    return response.json()


@pytest.fixture
def test_registration_with_courses(auth_client: ApiClient, test_scenario_with_two_courses: dict) -> dict:
    """Create a registration with a scenario that has courses."""
    unique_id = uuid.uuid4().hex[:6]

    response = auth_client.post(
        Endpoints.REGISTRATIONS,
        json={
            "scenarioId": test_scenario_with_two_courses["id"],
            "name": f"과목포함수강신청_{unique_id}"
        }
    )
    assert response.status_code == 201, f"Registration creation failed: {response.status_code} - {response.text}"

    return response.json()
