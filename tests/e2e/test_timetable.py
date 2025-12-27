"""
시간표 E2E 테스트.

Happy path + Edge cases for timetable operations.
"""
import pytest
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
        assert response.status_code in (200, 201)
        data = response.json()
        assert data["name"] == "테스트 시간표"
        assert data["openingYear"] == 2025

    def test_get_timetables(self, auth_client: ApiClient):
        """시간표 목록 조회"""
        response = auth_client.get(Endpoints.TIMETABLES)
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_get_timetable_by_id(self, auth_client: ApiClient):
        """시간표 상세 조회"""
        response = auth_client.get(Endpoints.TIMETABLES)
        if response.status_code != 200 or not response.json():
            pytest.skip("시간표가 없습니다")

        timetable_id = response.json()[0]["id"]
        response = auth_client.get(f"{Endpoints.TIMETABLES}/{timetable_id}")
        assert response.status_code == 200

    def test_add_course_to_timetable(self, auth_client: ApiClient):
        """시간표에 과목 추가"""
        # 시간표 조회
        response = auth_client.get(Endpoints.TIMETABLES)
        if response.status_code != 200 or not response.json():
            pytest.skip("시간표가 없습니다")

        timetable_id = response.json()[0]["id"]

        # 과목 조회
        response = auth_client.get(f"{Endpoints.COURSES}?size=1")
        if response.status_code != 200:
            pytest.skip("과목 데이터가 없습니다")

        data = response.json()
        courses = data.get("content", data) if isinstance(data, dict) else data
        if not courses:
            pytest.skip("과목이 없습니다")

        course_id = courses[0]["id"]

        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/courses/{course_id}"
        )
        # 이미 추가되었거나 시간 충돌일 수 있음
        assert response.status_code in (200, 201, 400, 409)

    def test_create_alternative_timetable(self, auth_client: ApiClient):
        """대안 시간표 생성 (API 계약 검증)"""
        response = auth_client.get(Endpoints.TIMETABLES)
        if response.status_code != 200 or not response.json():
            pytest.skip("시간표가 없습니다")

        timetable = response.json()[0]
        timetable_id = timetable["id"]
        items = timetable.get("items", [])

        if not items:
            pytest.skip("시간표에 과목이 없습니다")

        excluded_course_id = items[0]["courseId"]

        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/alternatives",
            json={"name": "대안 시간표", "excludedCourseIds": [excluded_course_id]}
        )

        if response.status_code in (200, 201):
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
        if response.status_code not in (200, 201):
            pytest.skip("시간표 생성 실패")

        timetable_id = response.json()["id"]

        response = auth_client.delete(f"{Endpoints.TIMETABLES}/{timetable_id}")
        assert response.status_code in (200, 204)

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

    def test_add_nonexistent_course_to_timetable(self, auth_client: ApiClient):
        """존재하지 않는 과목 추가"""
        response = auth_client.get(Endpoints.TIMETABLES)
        if response.status_code != 200 or not response.json():
            pytest.skip("시간표가 없습니다")

        timetable_id = response.json()[0]["id"]

        response = auth_client.post(
            f"{Endpoints.TIMETABLES}/{timetable_id}/courses/999999999"
        )
        assert response.status_code in (400, 404)

    def test_add_excluded_course_to_timetable(self, auth_client: ApiClient):
        """제외된 과목 재추가 시 거부"""
        response = auth_client.get(Endpoints.TIMETABLES)
        if response.status_code != 200:
            pytest.skip("시간표 조회 실패")

        for tt in response.json():
            excluded = tt.get("excludedCourses", [])
            if excluded:
                timetable_id = tt["id"]
                excluded_course_id = excluded[0]["courseId"]

                response = auth_client.post(
                    f"{Endpoints.TIMETABLES}/{timetable_id}/courses/{excluded_course_id}"
                )
                assert response.status_code in (400, 409), "제외된 과목은 추가 불가"
                return

        pytest.skip("제외된 과목이 있는 시간표가 없습니다")

    def test_delete_nonexistent_timetable(self, auth_client: ApiClient):
        """존재하지 않는 시간표 삭제"""
        response = auth_client.delete(f"{Endpoints.TIMETABLES}/999999999")
        assert response.status_code in (204, 404)
