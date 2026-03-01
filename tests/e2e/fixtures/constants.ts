/**
 * E2E 테스트 공통 상수
 * 환경변수가 없으면 즉시 실패합니다. tests/e2e/.env.example을 복사하여 .env를 생성하세요.
 */
function requireEnv(key: string): string {
  const val = process.env[key];
  if (!val) {
    throw new Error(
      `Required env var '${key}' is not set. Copy tests/e2e/.env.example to tests/e2e/.env`
    );
  }
  return val;
}

export const E2E_USER_EMAIL = requireEnv('E2E_USER_EMAIL');
export const E2E_USER_PASSWORD = requireEnv('E2E_USER_PASSWORD');
export const API_BASE_URL = requireEnv('API_BASE_URL');
