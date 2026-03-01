import { test, expect } from '../fixtures/base.fixture';

/**
 * 시간표 CRUD 핵심 흐름 E2E 테스트
 * storageState로 로그인된 상태에서 실행
 */

test.describe('시간표', () => {
  // 각 테스트에서 생성한 시간표 이름을 추적하여 teardown에서 삭제
  let createdTimetableName: string | null = null;

  test.afterEach(async ({ timetablePage, page }) => {
    if (!createdTimetableName) return;
    await timetablePage.goto();
    const deleteButton = page
      .locator('text=' + createdTimetableName)
      .locator('../..')
      .getByRole('button', { name: '삭제' });
    if (await deleteButton.isVisible()) {
      await deleteButton.click();
    }
    createdTimetableName = null;
  });

  test('시간표 목록 페이지에 진입할 수 있다', async ({ timetablePage }) => {
    await timetablePage.goto();
    await timetablePage.expectVisible();
    // 페이지가 정상적으로 렌더링되면 새 시간표 버튼이 보임
    await expect(timetablePage.createButton).toBeVisible();
  });

  test('새 시간표를 생성할 수 있다', async ({ timetablePage, page }) => {
    createdTimetableName = `E2E 시간표 ${Date.now()}`;

    await timetablePage.goto();
    await timetablePage.createTimetable(createdTimetableName);

    // 생성 성공 토스트 확인
    await expect(page.getByText('시간표가 생성되었습니다')).toBeVisible({ timeout: 5_000 });

    // 생성된 시간표 카드가 목록에 표시된다
    await expect(timetablePage.getTimetableCard(createdTimetableName)).toBeVisible({ timeout: 5_000 });
  });

  test('시간표 상세 페이지에 진입할 수 있다', async ({ timetablePage, page }) => {
    createdTimetableName = `E2E 상세 ${Date.now()}`;

    await timetablePage.goto();
    await timetablePage.createTimetable(createdTimetableName);

    // 생성된 시간표 링크 클릭
    await expect(timetablePage.getTimetableCard(createdTimetableName)).toBeVisible({ timeout: 5_000 });
    await timetablePage.getTimetableCard(createdTimetableName).click();

    // /timetables/{id} 형태의 URL로 이동
    await page.waitForURL(/\/timetables\/\d+/, { timeout: 10_000 });
  });
});
