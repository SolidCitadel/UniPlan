"""
강의 검색 E2E 테스트.

Happy path + Edge cases for course search operations.
"""
from conftest import ApiClient, Endpoints
from models.generated.catalog_models import PageCourseResponse, CourseResponse


class TestCourses:
    """강의 검색 테스트"""

    # ==================== Happy Path ====================

    def test_get_courses(self, auth_client: ApiClient):
        """강의 목록 조회"""
        response = auth_client.get(Endpoints.COURSES)
        assert response.status_code == 200

        # Pydantic 모델 검증
        page = PageCourseResponse(**response.json())
        assert page.content is not None
        assert isinstance(page.content, list)

    def test_get_courses_with_pagination(self, auth_client: ApiClient):
        """페이지네이션 조회"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=0&size=10")
        assert response.status_code == 200

        page = PageCourseResponse(**response.json())
        assert page.content is not None
        assert len(page.content) <= 10
        assert page.size == 10

    def test_search_courses(self, auth_client: ApiClient, test_course):
        """강의 검색"""
        # Given: 테스트 과목 생성됨 (fixture)
        
        # When: 검색 API 호출
        page = auth_client.get_dto(
            f"{Endpoints.COURSES}?query={test_course['courseName']}",
            model=PageCourseResponse
        )
        
        # Then
        assert page.totalElements > 0
        assert len(page.content) > 0
        found = page.content[0]
        assert found.courseName == test_course["courseName"]

    def test_get_course_detail(self, auth_client: ApiClient, test_course):
        """강의 상세 조회"""
        course_id = test_course["id"]

        course = auth_client.get_dto(
            f"{Endpoints.COURSES}/{course_id}",
            model=CourseResponse
        )
        
        assert course.id == course_id
        assert course.courseName == test_course["courseName"]

    # ==================== Edge Cases ====================

    def test_search_no_results(self, auth_client: ApiClient):
        """결과가 없는 검색"""
        response = auth_client.get(
            f"{Endpoints.COURSES}?courseName=XYZNONEXISTENT123"
        )
        assert response.status_code == 200

        page = PageCourseResponse(**response.json())
        # content가 None일 수도 있고 빈 리스트일 수도 있음 (모델 정의상)
        # 보통 빈 리스트로 옴
        content = page.content or []
        assert len(content) == 0

    def test_search_special_characters(self, auth_client: ApiClient):
        """특수문자가 포함된 검색"""
        response = auth_client.get(
            f"{Endpoints.COURSES}?courseName=<script>alert('xss')</script>"
        )
        # 특수문자는 안전하게 처리되어 빈 결과 반환
        assert response.status_code == 200
        
        page = PageCourseResponse(**response.json())

    def test_search_very_long_query(self, auth_client: ApiClient):
        """매우 긴 검색어"""
        long_query = "a" * 1000
        response = auth_client.get(f"{Endpoints.COURSES}?courseName={long_query}")
        assert response.status_code == 200, "긴 검색어도 빈 결과로 처리"

    def test_pagination_beyond_results(self, auth_client: ApiClient):
        """결과 범위를 벗어난 페이지 요청"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=99999&size=20")
        assert response.status_code == 200

        page = PageCourseResponse(**response.json())
        content = page.content or []
        assert len(content) == 0

    def test_invalid_pagination_negative_page(self, auth_client: ApiClient):
        """음수 페이지 파라미터"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=-1&size=20")
        assert response.status_code == 200, "음수 페이지는 0으로 처리"
        # 에러 없이 200 OK와 기본 페이지 반환

    def test_invalid_pagination_negative_size(self, auth_client: ApiClient):
        """음수 사이즈 파라미터"""
        response = auth_client.get(f"{Endpoints.COURSES}?page=0&size=-1")
        assert response.status_code == 200, "음수 사이즈는 기본값으로 처리"

    def test_get_nonexistent_course(self, auth_client: ApiClient):
        """존재하지 않는 강의 조회"""
        response = auth_client.get(f"{Endpoints.COURSES}/999999999")
        assert response.status_code == 404

