import { type Page, type Locator, expect } from '@playwright/test';

export class RegistrationPage {
  readonly page: Page;
  readonly heading: Locator;
  readonly startButton: Locator;
  readonly emptyMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.heading = page.getByRole('heading', { name: '수강신청' });
    this.startButton = page.getByRole('button', { name: '수강신청 시작' });
    this.emptyMessage = page.getByText('수강신청 세션이 없습니다. 새 수강신청을 시작해보세요.');
  }

  async goto() {
    await this.page.goto('/registrations');
  }

  async expectVisible() {
    await expect(this.heading).toBeVisible();
    await expect(this.startButton).toBeVisible();
  }

  async expectEmpty() {
    await expect(this.emptyMessage).toBeVisible({ timeout: 5_000 });
  }

  async clickStartButton() {
    await this.startButton.click();
    await expect(
      this.page.getByRole('heading', { name: '수강신청 시작' })
    ).toBeVisible({ timeout: 5_000 });
  }

  async fillSessionName(name: string) {
    await this.page.getByPlaceholder('예: 2025-1 실전 연습').fill(name);
  }

  /**
   * Radix Select에서 시나리오를 선택합니다.
   */
  async selectScenario(scenarioName: string) {
    await this.page.getByRole('combobox').click();
    await this.page.getByRole('option', { name: scenarioName }).click();
  }

  async submitStart() {
    await this.page.getByRole('button', { name: '시작' }).click();
  }

  async expectStartToast() {
    await expect(
      this.page.getByText('수강신청 세션이 시작되었습니다.')
    ).toBeVisible({ timeout: 5_000 });
  }

  /** 수강신청 목록에서 해당 이름(또는 ID 기반 이름)의 링크를 반환합니다 */
  getRegistrationLink(name: string): Locator {
    return this.page.getByRole('link', { name });
  }

  async gotoDetail(id: number) {
    await this.page.goto(`/registrations/${id}`);
  }

  /** 완료 처리 버튼 클릭 (confirm 없음) */
  async clickComplete() {
    await this.page.getByRole('button', { name: '완료 처리' }).click();
  }

  /**
   * 취소 버튼 클릭. confirm 다이얼로그는 spec에서 직접 처리하세요.
   * ('수강신청을 취소하시겠습니까?')
   */
  async clickCancel() {
    await this.page.getByRole('button', { name: '취소' }).click();
  }

  /**
   * 삭제 버튼 클릭. confirm 다이얼로그는 spec에서 직접 처리하세요.
   * ('수강신청을 완전히 삭제하시겠습니까?')
   */
  async clickDelete() {
    await this.page.getByRole('button', { name: '삭제' }).click();
  }

  async expectCompleteToast() {
    await expect(
      this.page.getByText('수강신청이 완료되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }

  async expectCancelToast() {
    await expect(
      this.page.getByText('수강신청이 취소되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }

  async expectDeleteToast() {
    await expect(
      this.page.getByText('수강신청이 삭제되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }

  /**
   * 수강신청 상세에서 "신청 대기" 목록의 첫 번째 과목을 성공으로 표시합니다.
   */
  async markFirstPendingAsSucceeded() {
    await this.page.getByText('신청 대기').locator('..').getByRole('button', { name: '성공' }).first().click();
  }

  async clickSaveStep() {
    await this.page.getByRole('button', { name: '다음 단계 저장' }).click();
  }

  async expectSaveStepToast() {
    await expect(
      this.page.getByText('다음 단계가 저장되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }
}
