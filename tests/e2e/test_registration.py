"""
수강신청 E2E 테스트.

Happy path + Edge cases for registration operations.
"""
import pytest
from conftest import ApiClient, Endpoints


class TestRegistration:
    """수강신청 테스트"""

    # ==================== Happy Path ====================

    def test_get_registrations(self, auth_client: ApiClient):
        """수강신청 목록 조회"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_start_registration(self, auth_client: ApiClient):
        """수강신청 세션 시작"""
        response = auth_client.get(Endpoints.SCENARIOS)
        if response.status_code != 200 or not response.json():
            pytest.skip("시나리오가 없습니다")

        scenario = response.json()[0]

        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={
                "scenarioId": scenario["id"],
                "name": "테스트 수강신청"
            }
        )
        assert response.status_code in (200, 201)

        data = response.json()
        assert data["id"] is not None
        assert data["status"] in ("IN_PROGRESS", "PENDING", "inProgress", "pending")

    def test_get_registration_by_id(self, auth_client: ApiClient):
        """수강신청 상세 조회"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        if response.status_code != 200 or not response.json():
            pytest.skip("수강신청이 없습니다")

        reg_id = response.json()[0]["id"]
        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/{reg_id}")
        assert response.status_code == 200

    def test_record_step(self, auth_client: ApiClient):
        """과목별 성공/실패 기록"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        if response.status_code != 200:
            pytest.skip("수강신청 조회 실패")

        registrations = response.json()
        in_progress = [
            r for r in registrations
            if r.get("status") in ("IN_PROGRESS", "inProgress")
        ]

        if not in_progress:
            pytest.skip("진행 중인 수강신청이 없습니다")

        reg = in_progress[0]
        reg_id = reg["id"]

        current_scenario = reg.get("currentScenario", {})
        timetable = current_scenario.get("timetable", {})
        items = timetable.get("items", [])

        if len(items) < 2:
            pytest.skip("과목이 2개 이상이어야 합니다")

        response = auth_client.post(
            f"{Endpoints.REGISTRATIONS}/{reg_id}/steps",
            json={
                "succeededCourses": [items[0]["courseId"]],
                "failedCourses": [items[1]["courseId"]],
                "canceledCourses": []
            }
        )
        assert response.status_code == 200

    def test_complete_registration(self, auth_client: ApiClient):
        """수강신청 완료"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        if response.status_code != 200:
            pytest.skip("수강신청 조회 실패")

        registrations = response.json()
        in_progress = [
            r for r in registrations
            if r.get("status") in ("IN_PROGRESS", "inProgress")
        ]

        if not in_progress:
            pytest.skip("진행 중인 수강신청이 없습니다")

        reg_id = in_progress[0]["id"]

        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/complete")
        assert response.status_code == 200

        # 상태 확인
        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/{reg_id}")
        if response.status_code == 200:
            data = response.json()
            assert data["status"] in ("COMPLETED", "completed")

    # ==================== Edge Cases ====================

    def test_start_with_nonexistent_scenario(self, auth_client: ApiClient):
        """존재하지 않는 시나리오로 수강신청 시작"""
        response = auth_client.post(
            Endpoints.REGISTRATIONS,
            json={"scenarioId": 999999999, "name": "Invalid"}
        )
        assert response.status_code in (400, 404)

    def test_get_nonexistent_registration(self, auth_client: ApiClient):
        """존재하지 않는 수강신청 조회"""
        response = auth_client.get(f"{Endpoints.REGISTRATIONS}/999999999")
        assert response.status_code == 404

    def test_complete_already_completed(self, auth_client: ApiClient):
        """이미 완료된 수강신청 다시 완료 시도"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        if response.status_code != 200:
            pytest.skip("수강신청 조회 실패")

        registrations = response.json()
        completed = [
            r for r in registrations
            if r.get("status") in ("COMPLETED", "completed")
        ]

        if not completed:
            pytest.skip("완료된 수강신청이 없습니다")

        reg_id = completed[0]["id"]

        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/complete")
        # 멱등성 또는 에러
        assert response.status_code in (200, 400, 409)

    def test_add_step_to_completed(self, auth_client: ApiClient):
        """완료된 수강신청에 단계 추가 시도"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        if response.status_code != 200:
            pytest.skip("수강신청 조회 실패")

        registrations = response.json()
        completed = [
            r for r in registrations
            if r.get("status") in ("COMPLETED", "completed")
        ]

        if not completed:
            pytest.skip("완료된 수강신청이 없습니다")

        reg_id = completed[0]["id"]

        response = auth_client.post(
            f"{Endpoints.REGISTRATIONS}/{reg_id}/steps",
            json={"succeededCourses": [], "failedCourses": [], "canceledCourses": []}
        )
        assert response.status_code in (400, 409)

    def test_cancel_already_cancelled(self, auth_client: ApiClient):
        """이미 취소된 수강신청 다시 취소 시도"""
        response = auth_client.get(Endpoints.REGISTRATIONS)
        if response.status_code != 200:
            pytest.skip("수강신청 조회 실패")

        registrations = response.json()
        cancelled = [
            r for r in registrations
            if r.get("status") in ("CANCELLED", "cancelled")
        ]

        if not cancelled:
            pytest.skip("취소된 수강신청이 없습니다")

        reg_id = cancelled[0]["id"]

        response = auth_client.post(f"{Endpoints.REGISTRATIONS}/{reg_id}/cancel")
        # 멱등성 또는 에러
        assert response.status_code in (200, 400, 409)
