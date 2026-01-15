"""
위시리스트 E2E 테스트.

Happy path + Edge cases for wishlist operations.
"""
import pytest
from conftest import ApiClient, Endpoints


class TestWishlist:
    """위시리스트 테스트"""

    # ==================== Happy Path ====================

    def test_add_course_to_wishlist(self, auth_client: ApiClient):
        """과목을 위시리스트에 추가"""
        response = auth_client.get(f"{Endpoints.COURSES}?size=1")
        if response.status_code != 200:
            pytest.skip("과목 데이터가 없습니다")

        data = response.json()
        courses = data.get("content", data) if isinstance(data, dict) else data
        if not courses:
            pytest.skip("과목이 없습니다")

        course_id = courses[0]["id"]

        response = auth_client.post(
            Endpoints.WISHLIST,
            json={"courseId": course_id, "priority": 1}
        )
        assert response.status_code in (200, 201, 409)  # 409 = already exists

    def test_get_wishlist(self, auth_client: ApiClient):
        """위시리스트 조회"""
        response = auth_client.get(Endpoints.WISHLIST)
        assert response.status_code == 200
        assert isinstance(response.json(), list)

    def test_update_wishlist_priority(self, auth_client: ApiClient):
        """위시리스트 우선순위 변경"""
        response = auth_client.get(Endpoints.WISHLIST)
        if response.status_code != 200 or not response.json():
            pytest.skip("위시리스트가 비어있습니다")

        item = response.json()[0]
        course_id = item["courseId"]
        new_priority = 3 if item.get("priority", 1) != 3 else 2

        response = auth_client.patch(
            f"{Endpoints.WISHLIST}/{course_id}",
            json={"priority": new_priority}
        )
        assert response.status_code == 200

    def test_delete_wishlist_item(self, auth_client: ApiClient):
        """위시리스트 항목 삭제"""
        # 먼저 추가
        response = auth_client.get(f"{Endpoints.COURSES}?size=1")
        if response.status_code != 200:
            pytest.skip("과목 데이터가 없습니다")

        data = response.json()
        courses = data.get("content", data) if isinstance(data, dict) else data
        if not courses:
            pytest.skip("과목이 없습니다")

        course_id = courses[0]["id"]
        auth_client.post(Endpoints.WISHLIST, json={"courseId": course_id, "priority": 5})

        # 삭제 (courseId로 삭제)
        response = auth_client.delete(f"{Endpoints.WISHLIST}/{course_id}")
        assert response.status_code in (200, 204)

    # ==================== Edge Cases ====================

    def test_add_duplicate_course(self, auth_client: ApiClient):
        """같은 과목 중복 추가 시 거부"""
        response = auth_client.get(f"{Endpoints.COURSES}?size=1")
        if response.status_code != 200:
            pytest.skip("과목 데이터가 없습니다")

        data = response.json()
        courses = data.get("content", data) if isinstance(data, dict) else data
        if not courses:
            pytest.skip("과목이 없습니다")

        course_id = courses[0]["id"]

        # 첫 번째 추가
        auth_client.post(Endpoints.WISHLIST, json={"courseId": course_id, "priority": 1})

        # 두 번째 추가 (중복)
        response = auth_client.post(
            Endpoints.WISHLIST,
            json={"courseId": course_id, "priority": 2}
        )
        assert response.status_code in (400, 409), "중복 추가는 거부되어야 함"

    def test_add_nonexistent_course(self, auth_client: ApiClient):
        """존재하지 않는 과목 추가 시 거부"""
        response = auth_client.post(
            Endpoints.WISHLIST,
            json={"courseId": 999999999, "priority": 1}
        )
        assert response.status_code in (400, 404), "존재하지 않는 과목은 거부되어야 함"

    def test_delete_nonexistent_item(self, auth_client: ApiClient):
        """존재하지 않는 항목 삭제"""
        response = auth_client.delete(f"{Endpoints.WISHLIST}/999999999")
        assert response.status_code in (204, 404)
