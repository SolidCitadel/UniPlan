/** E2E 테스트 공통 상수. 기본값은 .env.example 참고. */
export const E2E_USER_EMAIL = process.env.E2E_USER_EMAIL ?? 'e2e-test@example.com';
export const E2E_USER_PASSWORD = process.env.E2E_USER_PASSWORD ?? 'Test1234!';
export const API_BASE_URL = process.env.API_BASE_URL ?? 'http://localhost:8080';
