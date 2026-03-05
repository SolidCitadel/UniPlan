import { type Page, type Locator, expect } from '@playwright/test';

export class WishlistPage {
  readonly page: Page;
  readonly heading: Locator;
  readonly emptyMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.heading = page.getByRole('heading', { name: '위시리스트' });
    this.emptyMessage = page.getByText('위시리스트가 비어있습니다.');
  }

  async goto() {
    await this.page.goto('/wishlist');
  }

  async expectVisible() {
    await expect(this.heading).toBeVisible();
  }

  async expectEmpty() {
    await expect(this.emptyMessage).toBeVisible({ timeout: 5_000 });
  }

  async expectCourseVisible(courseName: string) {
    await expect(this.page.getByText(courseName)).toBeVisible({ timeout: 5_000 });
  }

  /**
   * 과목명에 해당하는 항목의 우선순위 select를 변경합니다.
   * 위시리스트 항목은 카드 내에 <select>와 courseName이 같이 있습니다.
   */
  async changePriority(courseName: string, newPriority: 1 | 2 | 3 | 4 | 5) {
    const card = this.page.locator('[class*="p-4"]').filter({
      has: this.page.getByText(courseName, { exact: true }),
    });
    await card.locator('select').selectOption(String(newPriority));
  }

  /**
   * 과목명에 해당하는 항목의 삭제 버튼을 클릭합니다.
   */
  async deleteCourse(courseName: string) {
    const card = this.page.locator('[class*="p-4"]').filter({
      has: this.page.getByText(courseName, { exact: true }),
    });
    await card.getByRole('button', { name: '삭제' }).click();
  }

  async expectDeleteToast() {
    await expect(
      this.page.getByText('삭제되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }

  async expectPriorityChangeToast() {
    await expect(
      this.page.getByText('우선순위가 변경되었습니다')
    ).toBeVisible({ timeout: 5_000 });
  }
}
