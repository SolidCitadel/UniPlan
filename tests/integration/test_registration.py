"""
수강신청 E2E 테스트.

Happy path + Edge cases for registration operations.
"""
from conftest import ApiClient, Endpoints
from models.generated.planner_models import RegistrationResponse


class TestRegistration:
    """수강신청 테스트"""

    # ==================== Happy Path ====================

    def test_get_registrations(self, auth_client: ApiClient):
        """수강신청 목록 조회"""
        registrations = auth_client.get_dto(
            Endpoints.REGISTRATIONS,
            model=RegistrationResponse
        )
        assert isinstance(registrations, list)

    def test_start_registration(self, auth_client: ApiClient, test_scenario: dict):
        """수강신청 세션 시작"""
        reg = auth_client.post_dto(
            Endpoints.REGISTRATIONS,
            model=RegistrationResponse,
            json={
                "scenarioId": test_scenario["id"],
                "name": "테스트 수강신청"
            }
        )
        assert reg.id is not None
        # Enum string comparison or Member comparison
        assert str(reg.status) in ("IN_PROGRESS", "PENDING", "inProgress", "pending")

    def test_get_registration_by_id(self, auth_client: ApiClient, test_registration: dict):
        """수강신청 상세 조회"""
        reg_id = test_registration["id"]
        reg = auth_client.get_dto(
            f"{Endpoints.REGISTRATIONS}/{reg_id}",
            model=RegistrationResponse
        )
        assert reg.id == reg_id

    def test_record_step(self, auth_client: ApiClient, test_registration_with_courses: dict):
        """과목별 성공/실패 기록"""
        reg_id = test_registration_with_courses["id"]

        # 수강신청의 시나리오에서 과목 ID 가져오기
        reg_data = auth_client.get_dto(
            f"{Endpoints.REGISTRATIONS}/{reg_id}",
            model=RegistrationResponse
        )
        current_scenario = reg_data.currentScenario
        timetable = current_scenario.timetable
        items = timetable.items

        # 과목이 반드시 있어야 함 (Fixture 보장)
        assert items, "Registration should have items"
        
        course_id = items[0].courseId
        # step 기록은 반환값이 명확하지 않거나 void일 수 있으므로 post 유지하거나 확인 필요. 
        # 보통 201 Created면 생성된 리소스를 반환할 가능성 높음. 
        # 하지만 여기서는 model 없이 status check만 하므로 기본 post 사용 (엄격성 유지)
        # 만약 응답이 없다면 model 파싱 에러 날 수 있음.
        
        response = auth_client.post(
            f"{Endpoints.REGISTRATIONS}/{reg_id}/steps",
            json={
                "succeededCourses": [course_id],
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
        reg = auth_client.get_dto(
            f"{Endpoints.REGISTRATIONS}/{reg_id}",
            model=RegistrationResponse
        )
        assert str(reg.status) in ("COMPLETED", "completed")

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
