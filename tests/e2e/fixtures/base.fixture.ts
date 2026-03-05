import { test as base } from '@playwright/test';
import { LoginPage } from '../pages/login.page';
import { SignupPage } from '../pages/signup.page';
import { TimetablePage } from '../pages/timetable.page';
import { CoursePage } from '../pages/course.page';
import { WishlistPage } from '../pages/wishlist.page';
import { ScenarioPage } from '../pages/scenario.page';
import { RegistrationPage } from '../pages/registration.page';
import { ApiHelper } from '../helpers/api.helper';

type Fixtures = {
  loginPage: LoginPage;
  signupPage: SignupPage;
  timetablePage: TimetablePage;
  coursePage: CoursePage;
  wishlistPage: WishlistPage;
  scenarioPage: ScenarioPage;
  registrationPage: RegistrationPage;
  api: ApiHelper;
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
  coursePage: async ({ page }, use) => {
    await use(new CoursePage(page));
  },
  wishlistPage: async ({ page }, use) => {
    await use(new WishlistPage(page));
  },
  scenarioPage: async ({ page }, use) => {
    await use(new ScenarioPage(page));
  },
  registrationPage: async ({ page }, use) => {
    await use(new RegistrationPage(page));
  },
  api: async ({ page }, use) => {
    await use(new ApiHelper(page));
  },
});

export { expect } from '@playwright/test';
