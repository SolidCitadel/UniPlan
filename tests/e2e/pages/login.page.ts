import { type Page, type Locator, expect } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly signupLink: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.getByLabel('이메일');
    this.passwordInput = page.getByLabel('비밀번호');
    this.submitButton = page.getByRole('button', { name: '로그인' });
    this.signupLink = page.getByRole('link', { name: '회원가입' });
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectVisible() {
    await expect(this.page.getByText('UniPlan', { exact: true })).toBeVisible();
    await expect(this.submitButton).toBeVisible();
  }

  async expectErrorToast() {
    await expect(this.page.getByText('이메일 또는 비밀번호가 올바르지 않습니다')).toBeVisible({ timeout: 5_000 });
  }
}
