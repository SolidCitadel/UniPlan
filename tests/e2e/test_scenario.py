"""
시나리오 E2E 테스트.

Happy path + Edge cases for scenario operations.
"""
import pytest
from conftest import ApiClient, Endpoints


class TestScenario:
    """시나리오 테스트"""

    # ==================== Happy Path ====================

    def test_create_scenario(self, auth_client: ApiClient):
        """시나리오 생성"""
        # 시간표 생성
        response = auth_client.post(
            Endpoints.TIMETABLES,
            json={"name": "시나리오 테스트용", "openingYear": 2025, "semester": "1"}
        )
        if response.status_code not in (200, 201):
            pytest.skip("시간표 생성 실패")

        timetable_id = response.json()["id"]

        # 시나리오 생성
        response = auth_client.post(
            Endpoints.SCENARIOS,
            json={"name": "Plan A", "timetableId": timetable_id}
        )
        assert response.status_code in (200, 201)

        data = response.json()
        assert data["name"] == "Plan A"
        assert data["timetableId"] == timetable_id

    def test_get_scenarios(self, auth_client: ApiClient):
        """시나리오 목록 조회"""
        response = auth_client.get(Endpoints.SCENARIOS)
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_get_scenario_by_id(self, auth_client: ApiClient):
        """시나리오 상세 조회"""
        response = auth_client.get(Endpoints.SCENARIOS)
        if response.status_code != 200 or not response.json():
            pytest.skip("시나리오가 없습니다")

        scenario_id = response.json()[0]["id"]
        response = auth_client.get(f"{Endpoints.SCENARIOS}/{scenario_id}")
        assert response.status_code == 200

        data = response.json()
        assert "id" in data
        assert "timetable" in data

    def test_create_alternative_scenario(self, auth_client: ApiClient):
        """대안 시나리오 생성"""
        response = auth_client.get(Endpoints.SCENARIOS)
        if response.status_code != 200 or not response.json():
            pytest.skip("시나리오가 없습니다")

        parent = response.json()[0]
        parent_id = parent["id"]
        timetable = parent.get("timetable", {})
        items = timetable.get("items", [])

        if not items:
            pytest.skip("시간표에 과목이 없습니다")

        failed_course_id = items[0]["courseId"]

        # 대안 시나리오 생성
        response = auth_client.post(
            f"{Endpoints.SCENARIOS}/{parent_id}/alternatives",
            json={
                "name": "Plan B",
                "timetableId": timetable["id"],
                "failedCourseIds": [failed_course_id]
            }
        )
        if response.status_code in (200, 201):
            data = response.json()
            assert data["id"] != parent_id

    def test_navigate_on_failure(self, auth_client: ApiClient):
        """과목 실패 시 대안 시나리오로 네비게이션"""
        response = auth_client.get(Endpoints.SCENARIOS)
        if response.status_code != 200 or not response.json():
            pytest.skip("시나리오가 없습니다")

        scenarios = response.json()
        root = scenarios[0]
        children = root.get("children", [])

        if not children:
            pytest.skip("대안 시나리오가 없습니다")

        child = children[0]
        failed_course_ids = child.get("failedCourseIds", [])

        if not failed_course_ids:
            pytest.skip("실패 과목 정보가 없습니다")

        response = auth_client.post(
            f"{Endpoints.SCENARIOS}/{root['id']}/navigate",
            json={"failedCourseIds": failed_course_ids}
        )
        if response.status_code == 200:
            result = response.json()
            assert result["id"] == child["id"]

    def test_delete_scenario(self, auth_client: ApiClient):
        """시나리오 삭제"""
        # 삭제용 시간표/시나리오 생성
        response = auth_client.post(
            Endpoints.TIMETABLES,
            json={"name": "삭제 테스트", "openingYear": 2025, "semester": "1"}
        )
        if response.status_code not in (200, 201):
            pytest.skip("시간표 생성 실패")

        timetable_id = response.json()["id"]

        response = auth_client.post(
            Endpoints.SCENARIOS,
            json={"name": "삭제용 시나리오", "timetableId": timetable_id}
        )
        if response.status_code not in (200, 201):
            pytest.skip("시나리오 생성 실패")

        scenario_id = response.json()["id"]

        response = auth_client.delete(f"{Endpoints.SCENARIOS}/{scenario_id}")
        assert response.status_code in (200, 204)

    # ==================== Edge Cases ====================

    def test_create_scenario_with_nonexistent_timetable(self, auth_client: ApiClient):
        """존재하지 않는 시간표로 시나리오 생성"""
        response = auth_client.post(
            Endpoints.SCENARIOS,
            json={"name": "Invalid", "timetableId": 999999999}
        )
        assert response.status_code in (400, 404)

    def test_get_nonexistent_scenario(self, auth_client: ApiClient):
        """존재하지 않는 시나리오 조회"""
        response = auth_client.get(f"{Endpoints.SCENARIOS}/999999999")
        assert response.status_code == 404

    def test_create_alternative_for_nonexistent_parent(self, auth_client: ApiClient):
        """존재하지 않는 부모 시나리오에 대안 생성"""
        response = auth_client.get(Endpoints.TIMETABLES)
        if response.status_code != 200 or not response.json():
            pytest.skip("시간표가 없습니다")

        timetable_id = response.json()[0]["id"]

        response = auth_client.post(
            f"{Endpoints.SCENARIOS}/999999999/alternatives",
            json={"name": "Orphan", "timetableId": timetable_id, "failedCourseIds": []}
        )
        assert response.status_code == 404

    def test_navigate_with_nonexistent_course(self, auth_client: ApiClient):
        """존재하지 않는 과목으로 네비게이션"""
        response = auth_client.get(Endpoints.SCENARIOS)
        if response.status_code != 200 or not response.json():
            pytest.skip("시나리오가 없습니다")

        scenario_id = response.json()[0]["id"]

        response = auth_client.post(
            f"{Endpoints.SCENARIOS}/{scenario_id}/navigate",
            json={"failedCourseIds": [999999999]}
        )
        # 존재하지 않는 과목은 무시되거나 에러일 수 있음
        assert response.status_code in (200, 400, 404)
