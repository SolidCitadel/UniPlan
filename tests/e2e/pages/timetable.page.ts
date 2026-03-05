import { type Page, type Locator, expect } from '@playwright/test';

export class TimetablePage {
  readonly page: Page;
  readonly heading: Locator;
  readonly createButton: Locator;
  readonly nameInput: Locator;
  readonly confirmCreateButton: Locator;
  readonly emptyMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.heading = page.getByRole('heading', { name: '시간표' });
    this.createButton = page.getByRole('button', { name: '+ 새 시간표' });
    this.nameInput = page.getByPlaceholder('시간표 이름');
    this.confirmCreateButton = page.getByRole('button', { name: '생성' });
    this.emptyMessage = page.getByText('시간표가 없습니다');
  }

  async goto() {
    await this.page.goto('/timetables');
  }

  async expectVisible() {
    await expect(this.heading).toBeVisible();
  }

  async openCreateDialog() {
    await this.createButton.click();
    await expect(
      this.page.getByRole('heading', { name: '새 시간표 만들기' })
    ).toBeVisible();
  }

  async createTimetable(name: string) {
    await this.openCreateDialog();
    await this.nameInput.fill(name);
    await this.confirmCreateButton.click();
  }

  getTimetableCard(name: string): Locator {
    return this.page.getByRole('link', { name });
  }

  // ─── 상세 페이지 (`/timetables/[id]`) ───────────────────────────────────────

  async gotoDetail(id: number) {
    await this.page.goto(`/timetables/${id}`);
  }

  async expectDetailHeading(name: string) {
    await expect(this.page.getByRole('heading', { name, level: 1 })).toBeVisible({ timeout: 5_000 });
  }

  /** 탭을 전환합니다. '추가 가능' | '시간 겹침' | '제외됨' */
  async clickTab(tab: '추가 가능' | '시간 겹침' | '제외됨') {
    await this.page.getByRole('tab', { name: tab }).click();
  }

  /**
   * '추가 가능' 탭의 과목을 클릭하여 시간표에 추가합니다.
   * 해당 과목은 위시리스트에 있고 시간표에 없는 상태여야 합니다.
   */
  async clickAddCourseInList(courseName: string) {
    await this.page.getByText(courseName, { exact: true }).first().click();
  }

  /** '대안 시간표 생성' 버튼을 클릭하여 alt 모드를 활성화합니다 */
  async clickCreateAlternativeMode() {
    await this.page.getByRole('button', { name: '대안 시간표 생성' }).click();
    await expect(this.page.getByText('제외할 과목을 선택하세요')).toBeVisible({ timeout: 5_000 });
  }

  /**
   * alt 모드에서 weekly grid의 과목 블록을 클릭합니다.
   * 해당 과목은 이미 시간표에 있는 과목이어야 합니다.
   */
  async selectCourseInGrid(courseName: string) {
    await this.page.getByText(courseName, { exact: true }).first().click();
  }

  /** '대안 생성' 버튼을 클릭하여 대안 시간표 이름 다이얼로그를 엽니다 */
  async clickCreateAlt() {
    await this.page.getByRole('button', { name: '대안 생성' }).click();
    await expect(
      this.page.getByRole('heading', { name: '대안 시간표 생성' })
    ).toBeVisible({ timeout: 5_000 });
  }

  /**
   * 대안 시간표 생성 다이얼로그에서 이름을 입력(또는 유지)하고 제출합니다.
   * name을 전달하면 기존 값을 덮어씁니다.
   */
  async submitAlternativeCreate(name?: string) {
    const input = this.page.getByPlaceholder('대안 시간표 이름');
    if (name) {
      await input.fill(name);
    }
    await this.page.getByRole('button', { name: '생성' }).click();
  }

  async expectCourseAddedToast() {
    await expect(this.page.getByText('과목이 추가되었습니다')).toBeVisible({ timeout: 5_000 });
  }

  async expectAltCreatedToast() {
    await expect(this.page.getByText('대안 시간표가 생성되었습니다')).toBeVisible({ timeout: 5_000 });
  }

  /**
   * 시간표 목록에서 카드의 삭제 버튼을 클릭합니다. confirm 없이 바로 삭제됩니다.
   * getTimetableCard 링크 기준으로 부모 flex 컨테이너의 삭제 버튼을 찾습니다.
   */
  async deleteTimetableCard(name: string) {
    const link = this.getTimetableCard(name);
    await link.locator('../..').getByRole('button', { name: '삭제' }).click();
  }

  async expectTimetableDeleteToast() {
    await expect(this.page.getByText('시간표가 삭제되었습니다')).toBeVisible({ timeout: 5_000 });
  }
}
