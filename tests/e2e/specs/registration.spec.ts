import { test, expect } from '../fixtures/base.fixture';

/**
 * 수강신청 E2E 테스트
 * - 목록 렌더링
 * - 수강신청 시작
 * - 완료 처리
 * - 취소 처리
 */

test.describe('수강신청', () => {
  let timetableId: number | null = null;
  let scenarioId: number | null = null;
  let registrationId: number | null = null;

  test.afterEach(async ({ api }) => {
    if (registrationId) {
      await api.deleteRegistration(registrationId);
      registrationId = null;
    }
    if (scenarioId) {
      await api.deleteScenario(scenarioId);
      scenarioId = null;
    }
    if (timetableId) {
      await api.deleteTimetable(timetableId);
      timetableId = null;
    }
  });

  test('@smoke 수강신청 목록 페이지가 렌더링된다', async ({ registrationPage }) => {
    await registrationPage.goto();
    await registrationPage.expectVisible();
  });

  test('수강신청 시작 다이얼로그로 수강신청 세션을 만들 수 있다', async ({
    registrationPage,
    api,
    page,
  }) => {
    const timetable = await api.createTimetable(`E2E 수강신청용 TT ${Date.now()}`);
    timetableId = timetable.id;
    const scenarioName = `E2E 수강신청용 시나리오 ${Date.now()}`;
    const scenario = await api.createScenario(scenarioName, timetableId);
    scenarioId = scenario.id;

    const sessionName = `E2E 세션 ${Date.now()}`;

    await registrationPage.goto();
    await registrationPage.clickStartButton();
    await registrationPage.fillSessionName(sessionName);
    await registrationPage.selectScenario(scenarioName);
    await registrationPage.submitStart();
    await registrationPage.expectStartToast();

    // 목록에 새 항목이 표시됨
    await expect(registrationPage.getRegistrationLink(sessionName)).toBeVisible({ timeout: 5_000 });

    // cleanup을 위해 ID 저장
    const link = registrationPage.getRegistrationLink(sessionName);
    const href = await link.getAttribute('href');
    if (href) {
      const match = href.match(/\/registrations\/(\d+)/);
      if (match) registrationId = parseInt(match[1]);
    }
  });

  test('수강신청을 완료 처리하면 완료 Badge가 표시된다', async ({
    registrationPage,
    api,
    page,
  }) => {
    const timetable = await api.createTimetable(`E2E 완료 TT ${Date.now()}`);
    timetableId = timetable.id;
    const scenario = await api.createScenario(`E2E 완료 시나리오 ${Date.now()}`, timetableId);
    scenarioId = scenario.id;
    const sessionName = `E2E 완료 세션 ${Date.now()}`;
    const registration = await api.createRegistration(scenarioId, sessionName);
    // 완료 후에는 삭제 가능하므로 ID 저장
    registrationId = registration.id;

    await registrationPage.gotoDetail(registrationId);

    // 완료 처리 (confirm 없음)
    await registrationPage.clickComplete();
    await registrationPage.expectCompleteToast();

    // /registrations 목록으로 이동
    await page.waitForURL('/registrations', { timeout: 10_000 });

    // 목록에서 '완료' Badge 확인
    await expect(page.getByText('완료', { exact: true })).toBeVisible({ timeout: 5_000 });
  });

  test('수강신청을 취소하면 취소됨 Badge가 표시된다', async ({
    registrationPage,
    api,
    page,
  }) => {
    const timetable = await api.createTimetable(`E2E 취소 TT ${Date.now()}`);
    timetableId = timetable.id;
    const scenario = await api.createScenario(`E2E 취소 시나리오 ${Date.now()}`, timetableId);
    scenarioId = scenario.id;
    const sessionName = `E2E 취소 세션 ${Date.now()}`;
    const registration = await api.createRegistration(scenarioId, sessionName);
    registrationId = registration.id;

    await registrationPage.gotoDetail(registrationId);

    // confirm 다이얼로그 자동 수락 후 취소 클릭
    page.once('dialog', (dialog) => dialog.accept());
    await registrationPage.clickCancel();
    await registrationPage.expectCancelToast();

    // /registrations 목록으로 이동
    await page.waitForURL('/registrations', { timeout: 10_000 });

    // 목록에서 '취소됨' Badge 확인
    await expect(page.getByText('취소됨')).toBeVisible({ timeout: 5_000 });
  });

  test('수강신청을 삭제하면 목록으로 이동한다', async ({ registrationPage, api, page }) => {
    const timetable = await api.createTimetable(`E2E 수강신청삭제 TT ${Date.now()}`);
    timetableId = timetable.id;
    const scenario = await api.createScenario(`E2E 수강신청삭제 시나리오 ${Date.now()}`, timetableId);
    scenarioId = scenario.id;
    const registration = await api.createRegistration(scenarioId, `E2E 삭제 세션 ${Date.now()}`);
    // afterEach에서 deleteRegistration 호출 불필요 (이미 삭제됨)
    registrationId = null;

    await registrationPage.gotoDetail(registration.id);

    // confirm 다이얼로그 자동 수락 후 삭제 클릭
    page.once('dialog', (dialog) => dialog.accept());
    await registrationPage.clickDelete();
    await registrationPage.expectDeleteToast();

    // /registrations 목록으로 이동
    await page.waitForURL('/registrations', { timeout: 10_000 });
  });

  test('수강신청 단계를 저장할 수 있다', async ({ registrationPage, api }) => {
    const course = await api.getFirstCourseWithClassTimes();
    const timetable = await api.createTimetable(`E2E 단계저장 TT ${Date.now()}`);
    timetableId = timetable.id;
    await api.addCourseToTimetable(timetableId, course.id);
    const scenario = await api.createScenario(`E2E 단계저장 시나리오 ${Date.now()}`, timetableId);
    scenarioId = scenario.id;
    const registration = await api.createRegistration(scenarioId, `E2E 단계저장 세션 ${Date.now()}`);
    registrationId = registration.id;

    await registrationPage.gotoDetail(registrationId);

    // "신청 대기" 목록에서 첫 번째 과목을 성공으로 표시
    await registrationPage.markFirstPendingAsSucceeded();

    // 다음 단계 저장
    await registrationPage.clickSaveStep();
    await registrationPage.expectSaveStepToast();
  });
});
