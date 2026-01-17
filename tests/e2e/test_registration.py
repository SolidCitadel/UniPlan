"""
수강신청 E2E 테스트.

Happy path + Edge cases for registration operations.
"""
from conftest import ApiClient, Endpoints


class TestRegistration:
    """수강신청 테스트"""

    # ==================== Happy Path ====================

    def test_get_registrations(self, auth_client: ApiClient):
        """수강신청 목록 조회"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_start_registration(self, auth_client: ApiClient, test_scenario: dict):
        """수강신청 세션 시작"""
        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={
                "scenarioId": test_scenario["id"],
                "name": "테스트 수강신청"
            }
        )
        assert response.status_code == 201, f"Failed: {response.text}"

        data = response.json()
        assert data["id"] is not None
        assert data["status"] in ("IN_PROGRESS", "PENDING", "inProgress", "pending")

    def test_get_registration_by_id(self, auth_client: ApiClient, test_registration: dict):
        """수강신청 상세 조회"""
        reg_id = test_registration["id"]

        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/{reg_id}")
        assert response.status_code == 200

        data = response.json()
        assert data["id"] == reg_id

    def test_record_step(self, auth_client: ApiClient, test_registration_with_courses: dict):
        """과목별 성공/실패 기록"""
        reg_id = test_registration_with_courses["id"]

        # 수강신청의 시나리오에서 과목 ID 가져오기
        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/{reg_id}")
        assert response.status_code == 200, f"Failed to get registration: {response.text}"

        reg_data = response.json()
        current_scenario = reg_data.get("currentScenario", {})
        timetable = current_scenario.get("timetable", {})
        items = timetable.get("items", [])

        # 과목이 있으면 첫 번째 과목을 성공으로 기록
        if items:
            course_id = items[0]["courseId"]
            response = auth_client.post(
                f"{Endpoints.REGISTRATIONS}/{reg_id}/steps",
                json={
                    "succeededCourses": [course_id],
                    "failedCourses": [],
                    "canceledCourses": []
                }
            )
            assert response.status_code == 201, f"Failed: {response.text}"
        else:
            # 과목이 없어도 빈 step은 기록 가능해야 함
            response = auth_client.post(
                f"{Endpoints.REGISTRATIONS}/{reg_id}/steps",
                json={
                    "succeededCourses": [],
                    "failedCourses": [],
                    "canceledCourses": []
                }
            )
            assert response.status_code == 201, f"Failed: {response.text}"

    def test_complete_registration(self, auth_client: ApiClient, test_registration: dict):
        """수강신청 완료"""
        reg_id = test_registration["id"]

        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/complete")
        assert response.status_code == 200, f"Failed: {response.text}"

        # 상태 확인
        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/{reg_id}")
        assert response.status_code == 200

        data = response.json()
        assert data["status"] in ("COMPLETED", "completed")

    # ==================== Edge Cases ====================

    def test_start_with_nonexistent_scenario(self, auth_client: ApiClient):
        """존재하지 않는 시나리오로 수강신청 시작"""
        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={"scenarioId": 999999999, "name": "Invalid"}
        )
        assert response.status_code == 404, "존재하지 않는 시나리오는 404 Not Found"

    def test_get_nonexistent_registration(self, auth_client: ApiClient):
        """존재하지 않는 수강신청 조회"""
        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/999999999")
        assert response.status_code == 404

    def test_complete_already_completed(self, auth_client: ApiClient, test_scenario: dict):
        """이미 완료된 수강신청 다시 완료 시도"""
        # 새 수강신청 생성
        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={"scenarioId": test_scenario["id"], "name": "완료테스트"}
        )
        assert response.status_code == 201, f"Failed to create: {response.text}"
        reg_id = response.json()["id"]

        # 첫 번째 완료
        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/complete")
        assert response.status_code == 200, f"Failed first complete: {response.text}"

        # 두 번째 완료 시도
        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/complete")
        assert response.status_code == 409, "이미 완료된 수강신청은 409 Conflict"

    def test_add_step_to_completed(self, auth_client: ApiClient, test_scenario: dict):
        """완료된 수강신청에 단계 추가 시도"""
        # 새 수강신청 생성 및 완료
        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={"scenarioId": test_scenario["id"], "name": "단계추가테스트"}
        )
        assert response.status_code == 201, f"Failed to create: {response.text}"
        reg_id = response.json()["id"]

        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/complete")
        assert response.status_code == 200, f"Failed to complete: {response.text}"

        # 완료된 수강신청에 단계 추가 시도
        response = auth_client.post(
            f"{Endpoints.REGISTRATIONS}/{reg_id}/steps",
            json={"succeededCourses": [], "failedCourses": [], "canceledCourses": []}
        )
        assert response.status_code == 409, "완료된 수강신청에 단계 추가는 409 Conflict"

    def test_cancel_already_cancelled(self, auth_client: ApiClient, test_scenario: dict):
        """이미 취소된 수강신청 다시 취소 시도"""
        # 새 수강신청 생성
        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={"scenarioId": test_scenario["id"], "name": "취소테스트"}
        )
        assert response.status_code == 201, f"Failed to create: {response.text}"
        reg_id = response.json()["id"]

        # 첫 번째 취소
        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/cancel")
        assert response.status_code == 200, f"취소 성공은 200 OK: {response.text}"

        # 두 번째 취소 시도
        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/cancel")
        assert response.status_code == 409, "이미 취소된 수강신청은 409 Conflict"
