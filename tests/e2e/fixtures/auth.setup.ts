import { test as setup, expect } from '@playwright/test';
import * as path from 'path';
import * as fs from 'fs';
import { E2E_USER_EMAIL, E2E_USER_PASSWORD, API_BASE_URL, AUTH_FILE } from './constants';

const authFile = path.join(__dirname, '..', AUTH_FILE);

setup('authenticate', async ({ page }) => {
  // .auth 디렉토리 생성 (이미 존재하면 무시)
  const authDir = path.dirname(authFile);
  await fs.promises.mkdir(authDir, { recursive: true });

  // 테스트 계정이 없을 경우 자동 생성 시도
  await ensureTestUserExists(API_BASE_URL, E2E_USER_EMAIL, E2E_USER_PASSWORD);

  // 로그인 페이지 이동
  await page.goto('/login');
  await expect(page.getByText('UniPlan', { exact: true })).toBeVisible();

  // 로그인 폼 입력
  await page.getByLabel('이메일').fill(E2E_USER_EMAIL);
  await page.getByLabel('비밀번호').fill(E2E_USER_PASSWORD);
  await page.getByRole('button', { name: '로그인' }).click();

  // 로그인 성공 확인: /courses 로 리다이렉트
  await page.waitForURL('**/courses', { timeout: 10_000 });

  // 세션 저장 (localStorage 포함)
  await page.context().storageState({ path: authFile });
});

async function ensureTestUserExists(
  apiBaseUrl: string,
  email: string,
  password: string
): Promise<void> {
  // 대학 목록 조회
  const univRes = await fetch(`${apiBaseUrl}/api/v1/universities`).catch(() => null);
  if (!univRes?.ok) return;

  const universities: Array<{ id: number; name: string }> = await univRes.json();
  if (!universities.length) return;

  const universityId = universities[0].id;

  // 회원가입 시도 (이미 존재하면 409 → 무시)
  await fetch(`${apiBaseUrl}/api/v1/auth/signup`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      email,
      password,
      name: 'E2E 테스트 유저',
      universityId,
    }),
  }).catch(() => null);
}
