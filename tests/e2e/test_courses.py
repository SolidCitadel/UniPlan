"""
강의 검색 E2E 테스트.

Happy path + Edge cases for course search operations.
"""
from conftest import ApiClient, Endpoints


class TestCourses:
    """강의 검색 테스트"""

    # ==================== Happy Path ====================

    def test_get_courses(self, auth_client: ApiClient):
        """강의 목록 조회"""
        response = auth_client.get(Endpoints.COURSES)
        assert response.status_code == 200

        data = response.json()
        content = data.get("content", data) if isinstance(data, dict) else data
        assert isinstance(content, list)

    def test_get_courses_with_pagination(self, auth_client: ApiClient):
        """페이지네이션 조회"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=0&size=10")
        assert response.status_code == 200

        data = response.json()
        content = data.get("content", data) if isinstance(data, dict) else data
        assert len(content) <= 10

    def test_search_by_course_name(self, auth_client: ApiClient, test_course: dict):
        """과목명으로 검색"""
        course_name = test_course["courseName"][:5]  # 앞 5글자로 검색

        response = auth_client.get(f"{Endpoints.COURSES}?courseName={course_name}")
        assert response.status_code == 200

        data = response.json()
        courses = data.get("content", data) if isinstance(data, dict) else data
        assert len(courses) > 0, f"No courses found with name containing '{course_name}'"

    def test_get_course_by_id(self, auth_client: ApiClient, test_course: dict):
        """강의 상세 조회"""
        course_id = test_course["id"]

        response = auth_client.get(f"{Endpoints.COURSES}/{course_id}")
        assert response.status_code == 200

        data = response.json()
        assert data["id"] == course_id

    # ==================== Edge Cases ====================

    def test_search_no_results(self, auth_client: ApiClient):
        """결과가 없는 검색"""
        response = auth_client.get(
            f"{Endpoints.COURSES}?courseName=XYZNONEXISTENT123"
        )
        assert response.status_code == 200

        data = response.json()
        content = data.get("content", data) if isinstance(data, dict) else data
        assert len(content) == 0

    def test_search_special_characters(self, auth_client: ApiClient):
        """특수문자가 포함된 검색"""
        response = auth_client.get(
            f"{Endpoints.COURSES}?courseName=<script>alert('xss')</script>"
        )
        # 특수문자는 안전하게 처리되어 빈 결과 반환
        assert response.status_code == 200

    def test_search_very_long_query(self, auth_client: ApiClient):
        """매우 긴 검색어"""
        long_query = "a" * 1000
        response = auth_client.get(f"{Endpoints.COURSES}?courseName={long_query}")
        assert response.status_code == 200, "긴 검색어도 빈 결과로 처리"

    def test_pagination_beyond_results(self, auth_client: ApiClient):
        """결과 범위를 벗어난 페이지 요청"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=99999&size=20")
        assert response.status_code == 200

        data = response.json()
        content = data.get("content", data) if isinstance(data, dict) else data
        assert len(content) == 0

    def test_invalid_pagination_negative_page(self, auth_client: ApiClient):
        """음수 페이지 파라미터"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=-1&size=20")
        assert response.status_code == 200, "음수 페이지는 0으로 처리"

    def test_invalid_pagination_negative_size(self, auth_client: ApiClient):
        """음수 사이즈 파라미터"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=0&size=-1")
        assert response.status_code == 200, "음수 사이즈는 기본값으로 처리"

    def test_get_nonexistent_course(self, auth_client: ApiClient):
        """존재하지 않는 강의 조회"""
        response = auth_client.get(f"{Endpoints.COURSES}/999999999")
        assert response.status_code == 404
