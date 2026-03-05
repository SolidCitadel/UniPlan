import { test, expect } from '../fixtures/base.fixture';

/**
 * 시간표 CRUD 핵심 흐름 E2E 테스트
 * storageState로 로그인된 상태에서 실행
 */

test.describe('시간표', () => {
  // UI로 생성한 시간표의 이름을 추적하여 afterEach에서 API로 삭제
  let createdTimetableName: string | null = null;

  test.afterEach(async ({ api, timetablePage }) => {
    if (!createdTimetableName) return;
    // 목록 페이지에서 링크 href로 ID를 추출해 API 삭제
    await timetablePage.goto();
    const link = timetablePage.getTimetableCard(createdTimetableName);
    if (await link.isVisible()) {
      const href = await link.getAttribute('href');
      if (href) {
        const match = href.match(/\/timetables\/(\d+)/);
        if (match) await api.deleteTimetable(parseInt(match[1]));
      }
    }
    createdTimetableName = null;
  });

  test('@smoke 시간표 목록 페이지에 진입할 수 있다', async ({ timetablePage }) => {
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

  test('시간표를 삭제할 수 있다', async ({ timetablePage, api }) => {
    const timetable = await api.createTimetable(`E2E 삭제 ${Date.now()}`);

    await timetablePage.goto();
    await expect(timetablePage.getTimetableCard(timetable.name)).toBeVisible({ timeout: 5_000 });

    await timetablePage.deleteTimetableCard(timetable.name);
    await timetablePage.expectTimetableDeleteToast();

    // 삭제 후 카드가 목록에서 사라진다
    await expect(timetablePage.getTimetableCard(timetable.name)).not.toBeVisible({ timeout: 5_000 });
  });
});

test.describe('시간표 상세', () => {
  let timetableId: number | null = null;
  let wishlistItemId: number | null = null;
  let altTimetableId: number | null = null;

  test.afterEach(async ({ api }) => {
    if (altTimetableId) {
      await api.deleteTimetable(altTimetableId);
      altTimetableId = null;
    }
    if (wishlistItemId) {
      await api.clearWishlist();
      wishlistItemId = null;
    }
    if (timetableId) {
      await api.deleteTimetable(timetableId);
      timetableId = null;
    }
  });

  test('위시리스트 강의를 시간표에 추가할 수 있다', async ({ timetablePage, api }) => {
    const course = await api.getFirstCourseWithClassTimes();
    const timetable = await api.createTimetable(`E2E 강의추가 ${Date.now()}`);
    timetableId = timetable.id;
    const wishlistItem = await api.addToWishlist(course.id, 1);
    wishlistItemId = wishlistItem.id;

    await timetablePage.gotoDetail(timetableId);
    await timetablePage.expectDetailHeading(timetable.name);

    // '추가 가능' 탭에 과목이 보이면 클릭하여 추가
    await timetablePage.clickTab('추가 가능');
    await timetablePage.clickAddCourseInList(course.courseName);
    await timetablePage.expectCourseAddedToast();
  });

  test('@smoke 대안 시간표를 생성할 수 있다', async ({ timetablePage, api, page }) => {
    const course = await api.getFirstCourseWithClassTimes();
    const timetable = await api.createTimetable(`E2E 대안 ${Date.now()}`);
    timetableId = timetable.id;
    const item = await api.addCourseToTimetable(timetableId, course.id);

    await timetablePage.gotoDetail(timetableId);
    await timetablePage.expectDetailHeading(timetable.name);

    // 대안 모드 진입
    await timetablePage.clickCreateAlternativeMode();

    // weekly grid에서 과목 선택
    await timetablePage.selectCourseInGrid(item.courseName);

    // 대안 생성 다이얼로그 오픈
    await timetablePage.clickCreateAlt();

    // 이름을 유지한 채로 생성 제출
    await timetablePage.submitAlternativeCreate();
    await timetablePage.expectAltCreatedToast();

    // 새 대안 시간표 URL로 이동했는지 확인
    await page.waitForURL(/\/timetables\/\d+/, { timeout: 10_000 });
    const newUrl = page.url();
    const newIdMatch = newUrl.match(/\/timetables\/(\d+)/);
    if (newIdMatch) {
      altTimetableId = parseInt(newIdMatch[1]);
    }
  });
});
