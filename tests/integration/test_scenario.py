"""
시나리오 E2E 테스트.

Happy path + Edge cases for scenario operations.
"""
from conftest import ApiClient, Endpoints
from models.generated.planner_models import ScenarioResponse


class TestScenario:
    """시나리오 테스트"""

    # ==================== Happy Path ====================

    def test_create_scenario(self, auth_client: ApiClient, test_timetable: dict):
        """시나리오 생성"""
        timetable_id = test_timetable["id"]

        scenario = auth_client.post_dto(
            Endpoints.SCENARIOS,
            model=ScenarioResponse,
            json={"name": "Plan A", "existingTimetableId": timetable_id}
        )
        assert scenario.name == "Plan A"
        assert scenario.timetable.id == timetable_id

    def test_get_scenarios(self, auth_client: ApiClient):
        """시나리오 목록 조회"""
        scenarios = auth_client.get_dto(
            Endpoints.SCENARIOS,
            model=ScenarioResponse
        )
        assert isinstance(scenarios, list)

    def test_get_scenario_by_id(self, auth_client: ApiClient, test_scenario: dict):
        """시나리오 상세 조회"""
        scenario_id = test_scenario["id"]

        scenario = auth_client.get_dto(
            f"{Endpoints.SCENARIOS}/{scenario_id}",
            model=ScenarioResponse
        )
        assert scenario.id == scenario_id
        assert scenario.timetable is not None

    def test_create_alternative_scenario(self, auth_client: ApiClient, test_scenario_with_course: dict):
        """대안 시나리오 생성"""
        parent_id = test_scenario_with_course["id"]
        timetable = test_scenario_with_course.get("timetable", {})
        items = timetable.get("items", [])
        assert items, "Scenario timetable should have items"

        failed_course_id = items[0]["courseId"]

        # 대안 시나리오 생성
        scenario = auth_client.post_dto(
            f"{Endpoints.SCENARIOS}/{parent_id}/alternatives",
            model=ScenarioResponse,
            json={
                "name": "Plan B",
                "existingTimetableId": timetable["id"],
                "failedCourseIds": [failed_course_id]
            }
        )
        assert scenario.id != parent_id

    def test_navigate_on_failure(self, auth_client: ApiClient, test_scenario_with_course: dict):
        """과목 실패 시 대안 시나리오로 네비게이션"""
        parent_id = test_scenario_with_course["id"]
        timetable = test_scenario_with_course.get("timetable", {})
        items = timetable.get("items", [])
        assert items, "Scenario timetable should have items"

        failed_course_id = items[0]["courseId"]

        # 먼저 대안 시나리오 생성
        scenario = auth_client.post_dto(
            f"{Endpoints.SCENARIOS}/{parent_id}/alternatives",
            model=ScenarioResponse,
            json={
                "name": "Navigate Test",
                "existingTimetableId": timetable["id"],
                "failedCourseIds": [failed_course_id]
            }
        )
        alternative_id = scenario.id

        # 네비게이션 테스트
        result = auth_client.post_dto(
            f"{Endpoints.SCENARIOS}/{parent_id}/navigate",
            model=ScenarioResponse,
            json={"failedCourseIds": [failed_course_id]},
            expected_status=200
        )
        assert result.id == alternative_id

    def test_delete_scenario(self, auth_client: ApiClient, test_timetable: dict):
        """시나리오 삭제"""
        # 삭제용 시나리오 생성
        timetable_id = test_timetable["id"]

        response = auth_client.post(
            Endpoints.SCENARIOS,
            json={"name": "삭제용 시나리오", "existingTimetableId": timetable_id}
        )
        assert response.status_code == 201, f"Failed to create: {response.text}"

        scenario_id = response.json()["id"]

        response = auth_client.delete(f"{Endpoints.SCENARIOS}/{scenario_id}")
        assert response.status_code == 204, "삭제 성공은 204 No Content"

    # ==================== Edge Cases ====================

    def test_create_scenario_with_nonexistent_timetable(self, auth_client: ApiClient):
        """존재하지 않는 시간표로 시나리오 생성"""
        response = auth_client.post(
            Endpoints.SCENARIOS,
            json={"name": "Invalid", "existingTimetableId": 999999999}
        )
        assert response.status_code == 404, "존재하지 않는 시간표는 404 Not Found"

    def test_get_nonexistent_scenario(self, auth_client: ApiClient):
        """존재하지 않는 시나리오 조회"""
        response = auth_client.get(f"{Endpoints.SCENARIOS}/999999999")
        assert response.status_code == 404

    def test_create_alternative_for_nonexistent_parent(self, auth_client: ApiClient, test_timetable: dict):
        """존재하지 않는 부모 시나리오에 대안 생성"""
        timetable_id = test_timetable["id"]

        response = auth_client.post(
            f"{Endpoints.SCENARIOS}/999999999/alternatives",
            json={"name": "Orphan", "existingTimetableId": timetable_id, "failedCourseIds": [1]}
        )
        assert response.status_code == 404

    def test_navigate_with_nonexistent_course(self, auth_client: ApiClient, test_scenario: dict):
        """존재하지 않는 과목으로 네비게이션"""
        scenario_id = test_scenario["id"]

        response = auth_client.post(
            f"{Endpoints.SCENARIOS}/{scenario_id}/navigate",
            json={"failedCourseIds": [999999999]}
        )
        # 존재하지 않는 과목 ID로 navigate 시 404 (대안 없음)
        assert response.status_code == 404, "매칭되는 대안이 없으면 404 Not Found"
