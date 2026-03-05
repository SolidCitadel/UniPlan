import { test, expect } from '../fixtures/base.fixture';

/**
 * 시나리오 E2E 테스트
 * - 목록 렌더링
 * - 시나리오 생성
 * - 상세 페이지 진입
 * - 시나리오 삭제
 */

test.describe('시나리오', () => {
  let timetableId: number | null = null;
  let compatTimetableId: number | null = null;
  let scenarioId: number | null = null;
  let altScenarioId: number | null = null;

  test.afterEach(async ({ api }) => {
    if (altScenarioId) {
      await api.deleteScenario(altScenarioId);
      altScenarioId = null;
    }
    if (scenarioId) {
      await api.deleteScenario(scenarioId);
      scenarioId = null;
    }
    if (compatTimetableId) {
      await api.deleteTimetable(compatTimetableId);
      compatTimetableId = null;
    }
    if (timetableId) {
      await api.deleteTimetable(timetableId);
      timetableId = null;
    }
  });

  test('@smoke 시나리오 목록 페이지가 렌더링된다', async ({ scenarioPage }) => {
    await scenarioPage.goto();
    await scenarioPage.expectVisible();
  });

  test('시나리오를 생성하면 목록에 표시된다', async ({ scenarioPage, api }) => {
    const timetable = await api.createTimetable(`E2E 시나리오용 TT ${Date.now()}`);
    timetableId = timetable.id;

    const scenarioName = `E2E 시나리오 ${Date.now()}`;

    await scenarioPage.goto();
    await scenarioPage.clickCreateButton();
    await scenarioPage.fillName(scenarioName);
    await scenarioPage.selectTimetable(timetable.name);
    await scenarioPage.submitCreate();
    await scenarioPage.expectCreateToast();

    // 생성된 시나리오 링크가 목록에 표시됨
    await expect(scenarioPage.getScenarioLink(scenarioName)).toBeVisible({ timeout: 5_000 });

    // 이후 cleanup을 위해 ID 저장
    const link = scenarioPage.getScenarioLink(scenarioName);
    const href = await link.getAttribute('href');
    if (href) {
      const match = href.match(/\/scenarios\/(\d+)/);
      if (match) scenarioId = parseInt(match[1]);
    }
  });

  test('시나리오 상세 페이지에 진입할 수 있다', async ({ scenarioPage, api, page }) => {
    const timetable = await api.createTimetable(`E2E 시나리오 상세용 TT ${Date.now()}`);
    timetableId = timetable.id;
    const scenarioName = `E2E 시나리오 상세 ${Date.now()}`;
    const scenario = await api.createScenario(scenarioName, timetableId);
    scenarioId = scenario.id;

    await scenarioPage.goto();
    await scenarioPage.getScenarioLink(scenarioName).click();

    // /scenarios/{id} URL로 이동
    await page.waitForURL(/\/scenarios\/\d+/, { timeout: 10_000 });

    // 핵심 섹션이 표시됨
    await expect(page.getByText('기준 시간표')).toBeVisible({ timeout: 5_000 });
    await expect(page.getByText('제외할 과목 선택')).toBeVisible({ timeout: 5_000 });
    await expect(page.getByText('시나리오 트리')).toBeVisible({ timeout: 5_000 });
  });

  test('시나리오를 삭제하면 목록으로 이동한다', async ({ scenarioPage, api, page }) => {
    const timetable = await api.createTimetable(`E2E 시나리오 삭제용 TT ${Date.now()}`);
    timetableId = timetable.id;
    const scenarioName = `E2E 시나리오 삭제 ${Date.now()}`;
    const scenario = await api.createScenario(scenarioName, timetableId);
    // afterEach에서 deleteScenario를 호출하지 않도록 null로 초기화 (이미 삭제되므로)
    scenarioId = null;

    await scenarioPage.gotoDetail(scenario.id);

    // confirm 다이얼로그 자동 수락 후 삭제 버튼 클릭
    page.once('dialog', (dialog) => dialog.accept());
    await scenarioPage.clickDelete();

    await scenarioPage.expectDeleteToast();

    // /scenarios 목록으로 이동
    await page.waitForURL('/scenarios', { timeout: 10_000 });
  });

  test('대안 시나리오를 생성할 수 있다', async ({ scenarioPage, api, page }) => {
    const course = await api.getFirstCourseWithClassTimes();

    // 기준 시간표: 과목 포함
    const baseTimetable = await api.createTimetable(`E2E 대안 기준 TT ${Date.now()}`);
    timetableId = baseTimetable.id;
    await api.addCourseToTimetable(baseTimetable.id, course.id);

    // 호환 시간표: 같은 학기, 해당 과목 미포함
    const compatTimetable = await api.createTimetable(`E2E 대안 호환 TT ${Date.now()}`);
    compatTimetableId = compatTimetable.id;

    const scenario = await api.createScenario(`E2E 대안 시나리오 ${Date.now()}`, baseTimetable.id);
    scenarioId = scenario.id;

    await scenarioPage.gotoDetail(scenario.id);

    // 기준 시간표의 과목을 제외 과목으로 선택
    await scenarioPage.checkExcludeCourse(course.courseName);

    // 호환 시간표 목록에서 대안 생성 다이얼로그 열기
    await scenarioPage.clickCreateAltForTimetable(compatTimetable.name);

    // 이름을 유지한 채 생성 제출
    await scenarioPage.submitAltScenarioCreate();
    await scenarioPage.expectAltScenarioCreatedToast();

    // 새 대안 시나리오 URL로 이동했는지 확인
    await page.waitForURL(/\/scenarios\/\d+/, { timeout: 10_000 });
    const newUrl = page.url();
    const newIdMatch = newUrl.match(/\/scenarios\/(\d+)/);
    if (newIdMatch && parseInt(newIdMatch[1]) !== scenario.id) {
      altScenarioId = parseInt(newIdMatch[1]);
    }
  });
});
