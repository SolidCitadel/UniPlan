import { type Page, type Locator, expect } from '@playwright/test';

export class SignupPage {
  readonly page: Page;
  readonly nameInput: Locator;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly confirmPasswordInput: Locator;
  readonly universitySelect: Locator;
  readonly submitButton: Locator;
  readonly loginLink: Locator;

  constructor(page: Page) {
    this.page = page;
    this.nameInput = page.getByLabel('이름');
    this.emailInput = page.getByLabel('이메일');
    this.passwordInput = page.getByLabel('비밀번호', { exact: true });
    this.confirmPasswordInput = page.getByLabel('비밀번호 확인');
    this.universitySelect = page.locator('#university');
    this.submitButton = page.getByRole('button', { name: '회원가입' });
    this.loginLink = page.getByRole('link', { name: '로그인' });
  }

  async goto() {
    await this.page.goto('/signup');
  }

  async selectFirstUniversity() {
    // Radix Select: trigger 클릭 후 첫 번째 항목 선택
    await this.universitySelect.click();
    const firstOption = this.page.getByRole('option').first();
    await firstOption.waitFor({ timeout: 5_000 });
    await firstOption.click();
  }

  async signup(name: string, email: string, password: string) {
    await this.nameInput.fill(name);
    await this.selectFirstUniversity();
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.confirmPasswordInput.fill(password);
    await this.submitButton.click();
  }

  async expectVisible() {
    await expect(this.page.getByText('회원가입', { exact: true }).first()).toBeVisible();
    await expect(this.submitButton).toBeVisible();
  }
}
