import { test, expect } from '../fixtures/base.fixture';

/**
 * @smoke 태그 - CI에서 빠르게 돌릴 최소 동작 확인 subset
 * 실행: npm run test:smoke
 */

test('@smoke 로그인 페이지가 렌더링된다', async ({ page }) => {
  await page.goto('/login');
  await expect(page.getByRole('heading', { name: 'UniPlan' })).toBeVisible();
  await expect(page.getByLabel('이메일')).toBeVisible();
  await expect(page.getByLabel('비밀번호')).toBeVisible();
  await expect(page.getByRole('button', { name: '로그인' })).toBeVisible();
});

test('@smoke 인증 후 강의 검색 화면이 렌더링된다', async ({ page }) => {
  // storageState로 이미 로그인된 상태
  await page.goto('/courses');
  await expect(page.getByRole('heading', { name: '강의 검색' })).toBeVisible();
  await expect(page.getByPlaceholder('과목명')).toBeVisible();
});

// 이 테스트는 playwright.config.ts의 storageState(인증 세션)가 적용된 상태에서 실행됩니다.
test('@smoke 강의 검색 API가 응답한다', async ({ page }) => {
  // waitForResponse를 goto 이전에 선언해야 레이스 컨디션 방지
  const responsePromise = page.waitForResponse(
    (res) => res.url().includes('/api/v1/courses') && res.status() === 200,
    { timeout: 10_000 }
  );
  await page.goto('/courses');

  const response = await responsePromise;
  expect(response.ok()).toBe(true);
});
