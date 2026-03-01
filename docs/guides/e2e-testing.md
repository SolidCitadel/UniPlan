# E2E Testing Guide (Playwright)

브라우저 레벨의 사용자 여정 전체를 검증하는 E2E 테스트 가이드입니다.
백엔드 API 정합성은 [Integration Testing](testing.md)에서, 이 가이드는 프론트엔드 포함 전체 흐름을 다룹니다.

---

## 위치 및 구조

```
tests/e2e/
├── package.json              # playwright 의존성
├── playwright.config.ts      # 핵심 설정 (webServer, projects)
├── .env.example              # 환경 변수 템플릿
├── .gitignore                # playwright-report/, .auth/ 제외
│
├── fixtures/
│   ├── auth.setup.ts         # 인증 세션 1회 생성 → storageState 저장
│   └── base.fixture.ts       # Page Object 주입용 커스텀 fixture
│
├── pages/                    # Page Object Model (POM)
│   ├── login.page.ts
│   ├── signup.page.ts
│   └── timetable.page.ts
│
└── specs/
    ├── smoke.spec.ts          # @smoke 태그 - CI에서 빠르게 돌릴 subset
    ├── auth.spec.ts           # 로그인/회원가입 시나리오
    └── timetable.spec.ts      # 시간표 CRUD 핵심 흐름
```

---

## 로컬 실행

### 1. 백엔드 기동

```bash
docker compose -f docker-compose.test.yml up -d --build
sleep 20
```

### 2. 의존성 설치 (최초 1회)

```bash
cd tests/e2e
npm install
npx playwright install chromium
```

### 3. 환경 변수 설정

```bash
cp .env.example .env
# 필요 시 .env 수정 (기본값으로도 동작)
```

### 4. 테스트 실행

```bash
# 전체 실행
npm test

# @smoke만 빠르게
npm run test:smoke

# UI Mode (대화형 디버깅)
npm run test:ui

# 브라우저 표시하며 실행
npm run test:headed

# 코드 생성 (브라우저 조작 → Playwright 코드 자동 생성)
npm run codegen
```

---

## 핵심 설계

### 인증 전략 - storageState 패턴

매 테스트마다 로그인하지 않고 1회 로그인 후 브라우저 상태를 `.auth/user.json`에 저장.
나머지 테스트는 이 파일을 재사용하여 인증 비용을 최소화합니다.

```
[setup project]  auth.setup.ts → .auth/user.json 생성
[chromium]       storageState: '.auth/user.json' 로드 후 테스트 실행
```

인증 자체를 테스트하는 `auth.spec.ts`는 `test.use({ storageState: { cookies: [], origins: [] } })`로 세션을 초기화합니다.

### webServer - Next.js 자동 기동

`playwright.config.ts`의 `webServer` 옵션으로 테스트 실행 시 Next.js를 자동으로 시작합니다.
로컬에서 이미 dev 서버가 떠 있으면 재사용(`reuseExistingServer: true`)합니다.

### 로케이터 우선순위

```typescript
// 1순위: 시맨틱 (접근성)
page.getByRole('button', { name: '로그인' })
page.getByRole('heading', { name: '시간표' })

// 2순위: 레이블
page.getByLabel('이메일')

// 3순위: Placeholder
page.getByPlaceholder('시간표 이름')

// 4순위: data-testid (필요 시 추가)
page.getByTestId('timetable-card')

// 최후 수단 (지양)
page.locator('.class-name')
```

---

## Page Object Model (POM)

반복되는 UI 인터랙션을 Page Object로 캡슐화합니다.

```typescript
// 직접 locator 사용 (지양)
await page.getByLabel('이메일').fill(email);
await page.getByLabel('비밀번호').fill(password);
await page.getByRole('button', { name: '로그인' }).click();

// POM 사용 (권장)
await loginPage.login(email, password);
```

새 페이지가 필요하면 `pages/` 디렉터리에 `*.page.ts` 파일을 추가하고
`fixtures/base.fixture.ts`에 fixture를 등록하세요.

---

## 실패 시 디버깅

```bash
# 실패 리포트 열기
npm run report

# Trace Viewer로 상세 분석
npx playwright show-trace playwright-report/data/<trace-file>.zip

# 특정 테스트만 재실행 (headed 모드)
npx playwright test specs/auth.spec.ts --headed
```

실패 시 `test-results/` 디렉터리에 스크린샷과 비디오가 자동 저장됩니다.

---

## 새 테스트 작성 가이드

1. **spec 파일 위치**: `specs/` 디렉터리, 파일명 `*.spec.ts`
2. **fixture 활용**: `import { test, expect } from '../fixtures/base.fixture'`
3. **태그**: CI smoke subset에 포함할 테스트는 제목에 `@smoke` 추가
4. **테스트 계정 의존성 없이 고유 데이터 생성**: `Date.now()` 활용

```typescript
import { test, expect } from '../fixtures/base.fixture';

test('@smoke 새 기능이 동작한다', async ({ page }) => {
  await page.goto('/new-feature');
  await expect(page.getByRole('heading', { name: '새 기능' })).toBeVisible();
});
```

---

## 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `E2E_USER_EMAIL` | `e2e-test@example.com` | 테스트용 계정 이메일 |
| `E2E_USER_PASSWORD` | `Test1234!` | 테스트용 계정 비밀번호 |
| `BASE_URL` | `http://localhost:3000` | Next.js URL |
| `API_BASE_URL` | `http://localhost:8080` | 백엔드 API URL |

`auth.setup.ts`가 테스트 계정을 자동으로 생성하므로 별도 계정 생성은 불필요합니다.
