import { type Page, type Locator, expect } from '@playwright/test';

export class CoursePage {
  readonly page: Page;
  readonly heading: Locator;
  readonly searchButton: Locator;
  readonly resetButton: Locator;
  readonly emptyMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.heading = page.getByRole('heading', { name: '강의 검색' });
    this.searchButton = page.getByRole('button', { name: '검색', exact: true });
    this.resetButton = page.getByRole('button', { name: '초기화' });
    this.emptyMessage = page.getByText('검색 결과가 없습니다');
  }

  async goto() {
    await this.page.goto('/courses');
  }

  async expectVisible() {
    await expect(this.heading).toBeVisible();
  }

  /** 특정 필터 input에 값을 입력합니다 */
  async fillFilter(placeholder: '과목명' | '교수명' | '학과명' | '캠퍼스', value: string) {
    await this.page.getByPlaceholder(placeholder).fill(value);
  }

  async clickSearch() {
    await this.searchButton.click();
  }

  async clickReset() {
    await this.resetButton.click();
  }

  /** 강의 목록에서 index번째 과목명 Locator를 반환합니다 */
  getCourseName(index: number): Locator {
    return this.page.locator('p.font-semibold').nth(index);
  }

  /** 강의명에 해당하는 '+ 위시리스트' 버튼을 클릭합니다 */
  async clickAddToWishlist(courseName: string) {
    const row = this.page.locator('div').filter({ has: this.page.getByText(courseName, { exact: true }) });
    await row.getByRole('button', { name: '+ 위시리스트' }).click();
  }

  /** 위시리스트 우선순위 선택 다이얼로그에서 숫자를 클릭합니다 */
  async selectWishlistPriority(priority: 1 | 2 | 3 | 4 | 5) {
    await expect(
      this.page.getByRole('heading', { name: '위시리스트 우선순위 선택' })
    ).toBeVisible({ timeout: 5_000 });
    await this.page.getByRole('button', { name: String(priority) }).click();
  }

  async expectWishlistAddedToast() {
    await expect(
      this.page.getByText('위시리스트에 추가되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }
}
