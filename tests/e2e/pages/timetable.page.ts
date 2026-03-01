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
}
