import { test, expect } from '../fixtures/base.fixture';
import { E2E_USER_EMAIL, E2E_USER_PASSWORD } from '../fixtures/constants';

/**
 * 인증 관련 E2E 테스트
 * - 로그인 성공/실패
 * - 회원가입 성공
 *
 * NOTE: auth.spec.ts는 storageState를 재정의하지 않으므로
 *       playwright.config.ts의 chromium project가 적용됨.
 *       로그인/회원가입 자체를 테스트하므로 기존 세션은 무시한다.
 */

test.describe('로그인', () => {
  test.use({ storageState: { cookies: [], origins: [] } });

  test('올바른 자격증명으로 로그인하면 강의 검색 페이지로 이동한다', async ({ loginPage, page }) => {
    await loginPage.goto();
    await loginPage.expectVisible();
    await loginPage.login(E2E_USER_EMAIL, E2E_USER_PASSWORD);

    await page.waitForURL('**/courses', { timeout: 10_000 });
    await expect(page.getByRole('heading', { name: '강의 검색' })).toBeVisible();
  });

  test('잘못된 비밀번호로 로그인하면 에러 메시지가 표시된다', async ({ loginPage, page }) => {
    await loginPage.goto();
    await loginPage.login('wrong@example.com', 'wrongpassword');

    await loginPage.expectErrorToast();

    // 로그인 페이지에 머무른다
    await expect(page).toHaveURL(/\/login/);
  });

  test('회원가입 링크를 클릭하면 회원가입 페이지로 이동한다', async ({ loginPage, page }) => {
    await loginPage.goto();
    await loginPage.signupLink.click();
    await page.waitForURL('**/signup');
    await expect(page.getByText('회원가입', { exact: true }).first()).toBeVisible();
  });
});

test.describe('회원가입', () => {
  test.use({ storageState: { cookies: [], origins: [] } });

  test('유효한 정보로 회원가입하면 로그인 후 강의 검색 페이지로 이동한다', async ({
    signupPage,
    page,
  }) => {
    const uniqueEmail = `e2e-${Date.now()}@example.com`;
    const password = 'Test1234!';

    await signupPage.goto();
    await signupPage.expectVisible();
    await signupPage.signup('E2E 테스트', uniqueEmail, password);

    // 회원가입 성공 후 자동 로그인 → /courses 이동
    await page.waitForURL('**/courses', { timeout: 15_000 });
    await expect(page.getByRole('heading', { name: '강의 검색' })).toBeVisible();
  });

  test('로그인 링크를 클릭하면 로그인 페이지로 이동한다', async ({ signupPage, page }) => {
    await signupPage.goto();
    await signupPage.loginLink.click();
    await page.waitForURL('**/login');
    await expect(page.getByText('UniPlan', { exact: true })).toBeVisible();
  });
});
