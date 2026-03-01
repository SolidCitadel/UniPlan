import { test as base } from '@playwright/test';
import { LoginPage } from '../pages/login.page';
import { SignupPage } from '../pages/signup.page';
import { TimetablePage } from '../pages/timetable.page';

type Fixtures = {
  loginPage: LoginPage;
  signupPage: SignupPage;
  timetablePage: TimetablePage;
};

export const test = base.extend<Fixtures>({
  loginPage: async ({ page }, use) => {
    await use(new LoginPage(page));
  },
  signupPage: async ({ page }, use) => {
    await use(new SignupPage(page));
  },
  timetablePage: async ({ page }, use) => {
    await use(new TimetablePage(page));
  },
});

export { expect } from '@playwright/test';
