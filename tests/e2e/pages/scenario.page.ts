import { type Page, type Locator, expect } from '@playwright/test';

export class ScenarioPage {
  readonly page: Page;
  readonly heading: Locator;
  readonly createButton: Locator;
  readonly emptyMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.heading = page.getByRole('heading', { name: '시나리오' });
    this.createButton = page.getByRole('button', { name: '시나리오 추가' });
    this.emptyMessage = page.getByText('시나리오가 없습니다. 새 시나리오를 만들어보세요.');
  }

  async goto() {
    await this.page.goto('/scenarios');
  }

  async expectVisible() {
    await expect(this.heading).toBeVisible();
    await expect(this.createButton).toBeVisible();
  }

  async expectEmpty() {
    await expect(this.emptyMessage).toBeVisible({ timeout: 5_000 });
  }

  async clickCreateButton() {
    await this.createButton.click();
    await expect(
      this.page.getByRole('heading', { name: '시나리오 생성' })
    ).toBeVisible({ timeout: 5_000 });
  }

  async fillName(name: string) {
    await this.page.getByPlaceholder('예: 1학기 수강신청 전략').fill(name);
  }

  /**
   * Radix Select에서 시간표를 선택합니다.
   * dialog 내 Select trigger를 클릭하고 timetableName이 포함된 항목을 선택합니다.
   */
  async selectTimetable(timetableName: string) {
    await this.page.getByRole('combobox').click();
    await this.page.getByRole('option', { name: timetableName }).click();
  }

  async submitCreate() {
    await this.page.getByRole('button', { name: '생성' }).click();
  }

  async expectCreateToast() {
    await expect(
      this.page.getByText('시나리오가 생성되었습니다.')
    ).toBeVisible({ timeout: 5_000 });
  }

  /** 시나리오 목록에서 해당 이름의 링크 Locator를 반환합니다 */
  getScenarioLink(name: string): Locator {
    return this.page.getByRole('link', { name });
  }

  async gotoDetail(id: number) {
    await this.page.goto(`/scenarios/${id}`);
  }

  async expectDetailHeading(name: string) {
    await expect(
      this.page.getByRole('heading', { name, level: 1 })
    ).toBeVisible({ timeout: 5_000 });
  }

  /** 삭제 버튼을 클릭합니다. confirm 다이얼로그는 spec에서 직접 처리하세요. */
  async clickDelete() {
    await this.page.getByRole('button', { name: '삭제' }).click();
  }

  async expectDeleteToast() {
    await expect(
      this.page.getByText('시나리오가 삭제되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }

  // ─── 시나리오 상세 (`/scenarios/[id]`) ──────────────────────────────────────

  /**
   * "제외할 과목 선택" 패널에서 과목 체크박스를 토글합니다.
   * 과목명 텍스트를 포함하는 <label> 요소를 클릭합니다.
   */
  async checkExcludeCourse(courseName: string) {
    // <p>courseName</p> → parent <div> → parent <label>
    await this.page.getByText(courseName, { exact: true }).locator('../..').first().click();
  }

  /**
   * "호환 시간표" 목록에서 특정 시간표의 "대안 생성" 버튼을 클릭합니다.
   * 제외 과목을 먼저 선택해야 호환 시간표가 표시됩니다.
   */
  async clickCreateAltForTimetable(timetableName: string) {
    // <p>timetableName</p> → parent <div> → parent row div → "대안 생성" button
    const row = this.page.getByText(timetableName, { exact: true }).locator('../..');
    await row.getByRole('button', { name: '대안 생성' }).click();
    await expect(
      this.page.getByRole('heading', { name: '대안 시나리오 생성' })
    ).toBeVisible({ timeout: 5_000 });
  }

  /**
   * 대안 시나리오 생성 다이얼로그에서 이름을 입력(또는 유지)하고 제출합니다.
   */
  async submitAltScenarioCreate(name?: string) {
    if (name) {
      await this.page.getByPlaceholder('시나리오 이름').fill(name);
    }
    await this.page.getByRole('button', { name: '생성' }).click();
  }

  async expectAltScenarioCreatedToast() {
    await expect(
      this.page.getByText('대안 시나리오가 생성되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }
}
