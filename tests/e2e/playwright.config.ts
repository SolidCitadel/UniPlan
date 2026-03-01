import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.resolve(__dirname, '.env') });

const BASE_URL = process.env.BASE_URL ?? 'http://localhost:3000';

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
      NEXT_PUBLIC_API_URL: process.env.API_BASE_URL ?? 'http://localhost:8080',
    },
    reuseExistingServer: !process.env.CI,
    timeout: 120_000,
  },
});
