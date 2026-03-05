import { test, expect } from '../fixtures/base.fixture';

/**
 * 위시리스트 E2E 테스트
 * - 목록 렌더링
 * - 우선순위 변경
 * - 항목 삭제
 *
 * 전제조건: 카탈로그에 classTimes가 있는 강의 데이터가 있어야 합니다.
 */

test.describe('위시리스트', () => {
  let courseId: number;
  let courseName: string;

  test.beforeEach(async ({ api }) => {
    const course = await api.getFirstCourseWithClassTimes();
    courseId = course.id;
    courseName = course.courseName;
    await api.addToWishlist(courseId, 1);
  });

  test.afterEach(async ({ api }) => {
    await api.clearWishlist();
  });

  test('@smoke 위시리스트 페이지가 렌더링되고 항목이 표시된다', async ({ wishlistPage }) => {
    await wishlistPage.goto();
    await wishlistPage.expectVisible();
    await wishlistPage.expectCourseVisible(courseName);
  });

  test('우선순위를 변경하면 토스트가 표시된다', async ({ wishlistPage }) => {
    await wishlistPage.goto();
    await wishlistPage.expectCourseVisible(courseName);

    await wishlistPage.changePriority(courseName, 3);
    await wishlistPage.expectPriorityChangeToast();
  });

  test('삭제 버튼을 클릭하면 항목이 목록에서 사라진다', async ({ wishlistPage }) => {
    await wishlistPage.goto();
    await wishlistPage.expectCourseVisible(courseName);

    await wishlistPage.deleteCourse(courseName);
    await wishlistPage.expectDeleteToast();

    // 항목이 사라지고 빈 상태 메시지가 표시됨
    await wishlistPage.expectEmpty();
  });
});
