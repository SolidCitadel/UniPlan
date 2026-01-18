"""
위시리스트 E2E 테스트.

Happy path + Edge cases for wishlist operations.
"""
import pytest
from conftest import ApiClient, Endpoints


class TestWishlist:
    """위시리스트 테스트"""

    # ==================== Happy Path ====================

    def test_add_course_to_wishlist(self, auth_client: ApiClient, test_course: dict | None):
        """과목을 위시리스트에 추가"""
        if not test_course:
            pytest.skip("테스트 과목이 생성되지 않았습니다")

        course_id = test_course["id"]

        response = auth_client.post(
            Endpoints.WISHLIST,
            json={"courseId": course_id, "priority": 1}
        )
        assert response.status_code == 201, "새 위시리스트 추가는 201 Created"

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
        item_id = item["id"]
        new_priority = 3 if item.get("priority", 1) != 3 else 2

        response = auth_client.patch(
            f"{Endpoints.WISHLIST}/{item_id}",
            json={"priority": new_priority}
        )
        assert response.status_code == 200

    def test_delete_wishlist_item(self, auth_client: ApiClient, test_course: dict | None):
        """위시리스트 항목 삭제"""
        if not test_course:
            pytest.skip("테스트 과목이 생성되지 않았습니다")

        course_id = test_course["id"]
        auth_client.post(Endpoints.WISHLIST, json={"courseId": course_id, "priority": 5})

        # 추가된 아이템의 id 확인
        wishlist_response = auth_client.get(Endpoints.WISHLIST)
        items = wishlist_response.json()
        item = next((i for i in items if i["courseId"] == course_id), None)
        if not item:
            pytest.skip("위시리스트 아이템을 찾을 수 없습니다")

        # 삭제 (item id로 삭제)
        response = auth_client.delete(f"{Endpoints.WISHLIST}/{item['id']}")
        assert response.status_code == 204, "삭제 성공은 204 No Content"

    # ==================== Edge Cases ====================

    def test_add_duplicate_course(self, auth_client: ApiClient, test_course: dict | None):
        """같은 과목 중복 추가 시 거부"""
        if not test_course:
            pytest.skip("테스트 과목이 생성되지 않았습니다")

        course_id = test_course["id"]

        # 첫 번째 추가
        auth_client.post(Endpoints.WISHLIST, json={"courseId": course_id, "priority": 1})

        # 두 번째 추가 (중복)
        response = auth_client.post(
            Endpoints.WISHLIST,
            json={"courseId": course_id, "priority": 2}
        )
        assert response.status_code == 409, "중복 추가는 409 Conflict"

    def test_add_nonexistent_course(self, auth_client: ApiClient):
        """존재하지 않는 과목 추가 시 거부"""
        response = auth_client.post(
            Endpoints.WISHLIST,
            json={"courseId": 999999999, "priority": 1}
        )
        assert response.status_code == 404, "존재하지 않는 과목은 404 Not Found"

    def test_delete_nonexistent_item(self, auth_client: ApiClient):
        """존재하지 않는 항목 삭제"""
        response = auth_client.delete(f"{Endpoints.WISHLIST}/999999999")
        assert response.status_code == 404, "존재하지 않는 항목 삭제는 404 Not Found"
