import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.resolve(__dirname, '.env') });

function requireEnv(key: string): string {
  const val = process.env[key];
  if (!val) {
    throw new Error(
      `Required env var '${key}' is not set. Copy tests/e2e/.env.example to tests/e2e/.env`
    );
  }
  return val;
}

const BASE_URL = requireEnv('BASE_URL');
const API_BASE_URL = requireEnv('API_BASE_URL');

export default defineConfig({
  testDir: './specs',
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: 1,
  reporter: [['html'], ['list']],

  use: {
    baseURL: BASE_URL,
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },

  projects: [
    {
      name: 'setup',
      testMatch: /auth\.setup\.ts/,
      testDir: './fixtures',
    },
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        storageState: '.auth/user.json',
      },
      dependencies: ['setup'],
    },
  ],

  webServer: {
    // 로컬: dev 서버 재사용 / CI: production build 후 start (신뢰성 향상)
    command: process.env.CI ? 'npm run build && npm run start' : 'npm run dev',
    cwd: '../../app/frontend',
    url: BASE_URL,
    env: {
      NEXT_PUBLIC_API_URL: API_BASE_URL,
    },
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
