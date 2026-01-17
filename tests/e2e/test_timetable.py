"""
시간표 E2E 테스트.

Happy path + Edge cases for timetable operations.
"""
from conftest import ApiClient, Endpoints


class TestTimetable:
    """시간표 테스트"""

    # ==================== Happy Path ====================

    def test_create_timetable(self, auth_client: ApiClient):
        """시간표 생성"""
        response = auth_client.post(
            Endpoints.TIMETABLES,
            json={"name": "테스트 시간표", "openingYear": 2025, "semester": "1"}
        )
        assert response.status_code == 201, f"Failed: {response.text}"
        data = response.json()
        assert data["name"] == "테스트 시간표"
        assert data["openingYear"] == 2025

    def test_get_timetables(self, auth_client: ApiClient):
        """시간표 목록 조회"""
        response = auth_client.get(Endpoints.TIMETABLES)
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_get_timetable_by_id(self, auth_client: ApiClient, test_timetable: dict):
        """시간표 상세 조회"""
        timetable_id = test_timetable["id"]

        response = auth_client.get(f"{Endpoints.TIMETABLES}/{timetable_id}")
        assert response.status_code == 200

        data = response.json()
        assert data["id"] == timetable_id

    def test_add_course_to_timetable(self, auth_client: ApiClient, test_timetable: dict, test_course: dict):
        """시간표에 과목 추가"""
        timetable_id = test_timetable["id"]
        course_id = test_course["id"]

        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/courses",
            json={"courseId": course_id}
        )
        assert response.status_code == 201, f"Failed: {response.text}"

    def test_create_alternative_timetable(self, auth_client: ApiClient, test_timetable_with_course: dict):
        """대안 시간표 생성 (API 계약 검증)"""
        timetable_id = test_timetable_with_course["id"]
        items = test_timetable_with_course.get("items", [])
        assert items, "Timetable should have items"

        excluded_course_id = items[0]["courseId"]

        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/alternatives",
            json={"name": "대안 시간표", "excludedCourseIds": [excluded_course_id]}
        )
        assert response.status_code == 201, f"Failed: {response.text}"

        data = response.json()
        # API 계약 검증: excludedCourses에 courseId 포함
        assert "excludedCourses" in data, "excludedCourses 필드 필요"
        excluded_ids = [c["courseId"] for c in data["excludedCourses"]]
        assert excluded_course_id in excluded_ids

    def test_delete_timetable(self, auth_client: ApiClient):
        """시간표 삭제"""
        # 삭제용 시간표 생성
        response = auth_client.post(
            Endpoints.TIMETABLES,
            json={"name": "삭제 테스트", "openingYear": 2025, "semester": "1"}
        )
        assert response.status_code == 201, f"Failed to create: {response.text}"

        timetable_id = response.json()["id"]

        response = auth_client.delete(f"{Endpoints.TIMETABLES}/{timetable_id}")
        assert response.status_code == 204, "삭제 성공은 204 No Content"

    # ==================== Edge Cases ====================

    def test_create_timetable_missing_fields(self, auth_client: ApiClient):
        """필수 필드 누락 시 거부"""
        response = auth_client.post(
            Endpoints.TIMETABLES,
            json={"name": "Test"}  # openingYear, semester 누락
        )
        assert response.status_code == 400

    def test_get_nonexistent_timetable(self, auth_client: ApiClient):
        """존재하지 않는 시간표 조회"""
        response = auth_client.get(f"{Endpoints.TIMETABLES}/999999999")
        assert response.status_code == 404

    def test_add_nonexistent_course_to_timetable(self, auth_client: ApiClient, test_timetable: dict):
        """존재하지 않는 과목 추가"""
        timetable_id = test_timetable["id"]

        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/courses",
            json={"courseId": 999999999}
        )
        assert response.status_code == 404, "존재하지 않는 과목은 404 Not Found"

    def test_add_excluded_course_to_timetable(self, auth_client: ApiClient, test_timetable_with_course: dict, test_course: dict):
        """제외된 과목 재추가 시 거부"""
        timetable_id = test_timetable_with_course["id"]
        items = test_timetable_with_course.get("items", [])
        assert items, "Timetable should have items"

        excluded_course_id = items[0]["courseId"]

        # 대안 시간표 생성 (과목 제외)
        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/alternatives",
            json={"name": "제외테스트", "excludedCourseIds": [excluded_course_id]}
        )
        assert response.status_code == 201, f"Failed to create alternative: {response.text}"

        alternative_id = response.json()["id"]

        # 제외된 과목 재추가 시도
        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{alternative_id}/courses",
            json={"courseId": excluded_course_id}
        )
        assert response.status_code == 409, "제외된 과목은 409 Conflict"

    def test_delete_nonexistent_timetable(self, auth_client: ApiClient):
        """존재하지 않는 시간표 삭제"""
        response = auth_client.delete(f"{Endpoints.TIMETABLES}/999999999")
        assert response.status_code == 404, "존재하지 않는 시간표 삭제는 404 Not Found"
