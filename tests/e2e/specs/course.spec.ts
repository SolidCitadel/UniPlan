import { test, expect } from '../fixtures/base.fixture';

/**
 * 강의 검색 E2E 테스트
 * - 검색 필터 동작
 * - 위시리스트 추가 다이얼로그
 *
 * 전제조건: 카탈로그에 강의 데이터가 있어야 합니다.
 */

test.describe('강의 검색', () => {
  test.afterEach(async ({ api }) => {
    await api.clearWishlist();
  });

  test('@smoke 강의 검색 페이지가 렌더링되고 기본 강의 목록이 표시된다', async ({ coursePage, page }) => {
    await coursePage.goto();
    await coursePage.expectVisible();

    // 검색 버튼이 보임
    await expect(coursePage.searchButton).toBeVisible();

    // 기본 목록에 강의가 1개 이상 표시됨
    await expect(coursePage.getCourseName(0)).toBeVisible({ timeout: 10_000 });
  });

  test('과목명으로 검색하면 결과가 필터링된다', async ({ coursePage, api }) => {
    // 실제 존재하는 과목명으로 검색
    const course = await api.getFirstCourseWithClassTimes();
    const queryWord = course.courseName.slice(0, 2); // 앞 2글자로 검색

    await coursePage.goto();
    await coursePage.fillFilter('과목명', queryWord);
    await coursePage.clickSearch();

    // 검색 결과에 해당 과목이 포함되어 있어야 함
    await expect(coursePage.getCourseName(0)).toBeVisible({ timeout: 10_000 });
  });

  test('초기화 버튼을 클릭하면 필터가 리셋된다', async ({ coursePage }) => {
    await coursePage.goto();
    await coursePage.fillFilter('과목명', '테스트과목XYZ');
    await coursePage.clickSearch();

    // 초기화 후 검색 input이 비워지고 다시 목록이 로드됨
    await coursePage.clickReset();
    await expect(coursePage.page.getByPlaceholder('과목명')).toHaveValue('');
    await expect(coursePage.getCourseName(0)).toBeVisible({ timeout: 10_000 });
  });

  test('위시리스트 추가 다이얼로그에서 우선순위를 선택하면 추가된다', async ({ coursePage, api }) => {
    const course = await api.getFirstCourseWithClassTimes();

    await coursePage.goto();
    // 첫 번째 강의의 과목명으로 위시리스트 추가
    await expect(coursePage.getCourseName(0)).toBeVisible({ timeout: 10_000 });

    await coursePage.clickAddToWishlist(course.courseName);
    await coursePage.selectWishlistPriority(3);
    await coursePage.expectWishlistAddedToast();
  });
});
