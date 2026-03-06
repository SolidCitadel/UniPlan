# Testing Guide

UniPlan의 6단계 테스트 전략 및 작성 가이드입니다. 상세한 배경은 [ADR-006](../adr/006-test-strategy.md)을 참고하세요.

## Test Levels

| 유형 | 범위 | DB | 외부 서비스 | 위치 |
|------|------|-----|------------|------|
| **Unit** | 단일 클래스 | Mock | Mock | `unit/` |
| **Component** | 단일 서비스 | TestContainers | Mock | `component/` |
| **Contract** | API 계약 | - | WireMock | `contract/` |
| **Integration** | 전체 시스템 (앱 로직) | 실제 (tmpfs) | 실제 | `tests/integration/` |
| **Infra** | Observability 도구 동작 | - | 실제 (observability profile) | `tests/infra/` |
| **E2E** | 사용자 여정 | 실제 | 실제 | `tests/e2e/` (Playwright) |

---

## 1. Backend Testing rules

### Unit Test
- **목적**: 비즈니스 로직의 상세 검증, 엣지 케이스 확인
- **도구**: JUnit 5, Mockito
- **규칙**: DB나 Spring Context를 띄우지 마세요. (`@SpringBootTest` 금지)

### Component Test
- **목적**: Spring Context, DB 연동, API 응답 규격 검증
- **도구**: `@SpringBootTest`, `TestContainers` (MySQL)
- **규칙**:
  - H2 Database 사용 금지 (MySQL과의 호환성 문제)
  - `DockerRequiredExtension`을 사용하여 Docker 미실행 시 Fail-fast

### Contract Test
- **목적**: 마이크로서비스 간(Feign) 통신 규격 검증
- **도구**: Spring Cloud Contract 또는 WireMock
- **규칙**: `@SpringBootTest` 사용 시 Redis 등 외부 인프라는 반드시 Mock 처리
  ```java
  // Redis 자동구성 제외 + RedisTemplate Mock
  @TestPropertySource(properties = {
      "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,..."
  })
  @MockBean RedisTemplate<String, Object> redisTemplate;
  @MockBean RedisConnectionFactory redisConnectionFactory;
  ```

---

## 2. Integration Testing

Python(`pytest`)을 사용하여 실제 실행 중인 컨테이너 환경을 블랙박스 테스트합니다.

### 실행 방법
```bash
# 0. 최초 1회: 환경변수 설정
cp .env.example .env                                          # 프로젝트 루트 .env (Docker Compose 필수)
cp tests/integration/.env.example tests/integration/.env     # Integration 테스트 설정

# 1. 테스트 환경 구동 (tmpfs DB 사용으로 빠름)
docker compose -f docker-compose.yml -f docker-compose.test.yml up -d --build
sleep 30

# 2. 테스트 실행
cd tests/integration
uv sync
uv run pytest -v

# 3. 정리
docker compose -f docker-compose.yml -f docker-compose.test.yml down
```

> **환경변수 필수**: `tests/integration/.env`가 없으면 테스트가 즉시 실패합니다. `.env.example`에 모든 필수 변수가 정의되어 있습니다.

### 작성 가이드 (Best Practices)

1.  **Skip 금지**: 데이터가 없다고 테스트를 스킵하지 마세요. Fixture를 사용해 데이터를 생성하세요.
2.  **엄격한 검증**:
    - Status Code: `200` vs `201` 구분
    - 응답 본문: 필수 필드 누락 여부 전수 검사
3.  **에러 응답 검증**: 실패 케이스(4xx)에서도 에러 메시지 포맷이 올바른지 확인하세요.

### Pydantic Model Generation (Validation)

OpenAPI 스펙에서 자동 생성된 Pydantic 모델을 사용하여 Response Body를 검증합니다. 이를 통해 DTO 필드 누락이나 타입 불일치를 자동으로 감지할 수 있습니다.

**모델 생성**:
```bash
cd tests/integration
uv run python scripts/generate_models.py
```

**테스트 내 사용**:
```python
from models.generated.user_models import UserResponse

response = client.get("/users/me")
user = UserResponse(**response.json())  # 검증 자동 수행
assert user.email == "test@example.com"
```

---

## 3. Infra Testing

Python(`pytest`)을 사용하여 Observability 스택(Loki, Prometheus, Tempo, Grafana)의 동작을 검증합니다. 앱 로직이 아닌 인프라 파이프라인(로그 수집, 메트릭 scrape, 트레이스 전달, Grafana 프로비저닝)이 대상입니다.

### 실행 방법

```bash
# 0. 최초 1회: 프로젝트 루트 .env 설정 (Docker Compose 필수)
cp .env.example .env

# 1. Observability 프로파일 포함 테스트 환경 기동
docker compose -f docker-compose.yml -f docker-compose.test.yml --profile observability up -d --build

# 2. 테스트 실행 (환경변수는 pyproject.toml에 고정 포트 상수로 내장)
cd tests/infra
uv sync
uv run pytest -v

# 특정 파일만 실행
uv run pytest test_grafana.py -v
uv run pytest test_loki.py -v

# 3. 정리
docker compose -f docker-compose.yml -f docker-compose.test.yml --profile observability down
```

> **참고**: 별도 `.env` 파일이 필요 없습니다. `tests/infra/pyproject.toml`의 `[tool.pytest.ini_options] env`에 `--profile observability` 기동 시의 고정 포트 상수(LOKI_URL, TEMPO_URL, PROMETHEUS_URL, GRAFANA_URL 등)가 내장되어 있습니다.

### 테스트 파일 구조

```
tests/infra/
├── pyproject.toml        # 의존성 및 pytest 환경변수 (포트 상수)
├── conftest.py           # 공통 fixture (URL, 인증, generate_traffic)
├── test_loki.py          # Loki 로그 집계 검증 (Level 1~3)
├── test_prometheus.py    # Prometheus 메트릭 scrape 검증 (Level 1~3)
├── test_tempo.py         # Tempo 분산 트레이싱 검증 (Level 1~3)
└── test_grafana.py       # Grafana 프로비저닝 검증 (Level 1~3)
```

### 검증 계층 (각 파일 공통)

- **Level 1 - 서비스 헬스**: `/ready` 또는 `/api/health` 엔드포인트 200 응답 확인
- **Level 2 - 기본 동작**: 레이블/메트릭/스팬/데이터소스 존재 확인
- **Level 3 - 데이터 파이프라인**: 실제 데이터가 수집·저장·연계되는지 종단 검증

### 서비스 레이블 명명 규칙

Promtail은 Docker Compose 서비스 이름(`com.docker.compose.service` 레이블)을 Loki `service` 레이블로 매핑합니다. base+override 구조에서 dev/test 환경의 서비스 이름이 동일하므로 동일한 쿼리를 사용합니다.

```python
# dev/test 환경 모두 동일한 쿼리
'{service="api-gateway"}'
```

### Grafana 프로비저닝 검증 (`test_grafana.py`)

Grafana 데이터소스 자동 프로비저닝(`docker/grafana/provisioning/datasources/`)이 올바르게 적용됐는지 API로 검증합니다:

- Loki, Tempo, Prometheus 3개 데이터소스가 모두 프로비저닝됐는지 확인 (UID 기반)
- 각 데이터소스의 내부 서비스 URL(`http://loki:3100` 등)이 올바른지 확인
- Tempo의 `tracesToLogs.datasourceUid`가 실제 Loki UID와 일치하는지 확인 (Tempo→Loki 연계)
- Tempo의 `tracesToMetrics.datasourceUid`가 실제 Prometheus UID와 일치하는지 확인 (Tempo→Prometheus 연계)

### Integration 테스트 실행 시 OTel 경고

`--profile observability` 없이 Integration 테스트를 실행하면 Tempo 컨테이너가 없어 OTel exporter가 연결 실패 warning을 반복 출력합니다. 이는 정상 현상이며 앱 동작에 영향을 주지 않습니다(exponential backoff 후 재시도). Integration 테스트 69개는 해당 경고와 무관하게 정상 통과합니다. 자세한 배경은 [ADR-010](../adr/010-observability-stack.md)을 참고하세요.

---

## 4. Frontend Testing

- **Lint**: `npm run lint` (ESLint)
- **Build**: `npm run build` (타입 체크 포함)
- **Note**: 프론트엔드 로직 검증은 주로 Integration Test의 시나리오를 통해 간접 검증하거나, 복잡한 유틸리티 함수에 대해 Jest 단위 테스트를 작성합니다.

---

## 5. E2E Testing (Playwright)

브라우저 레벨의 사용자 여정 전체를 검증합니다. 현재 **32개** 테스트 (smoke **9개**).

### 위치 및 구조

```
tests/e2e/
├── package.json              # playwright 의존성
├── playwright.config.ts      # 핵심 설정 (webServer, projects)
├── .env.example              # 환경 변수 템플릿
│
├── fixtures/
│   ├── auth.setup.ts         # 인증 세션 1회 생성 → storageState 저장
│   └── base.fixture.ts       # Page Object + ApiHelper 주입용 커스텀 fixture
│
├── helpers/
│   └── api.helper.ts         # API 직접 호출로 테스트 데이터 생성/삭제
│
├── pages/                    # Page Object Model (POM)
│   ├── login.page.ts
│   ├── signup.page.ts
│   ├── course.page.ts        # /courses — 강의 검색·위시리스트 추가
│   ├── wishlist.page.ts      # /wishlist — 우선순위 변경·삭제
│   ├── timetable.page.ts     # /timetables + /timetables/[id]
│   ├── scenario.page.ts      # /scenarios + /scenarios/[id]
│   └── registration.page.ts  # /registrations + /registrations/[id]
│
└── specs/
    ├── smoke.spec.ts          # @smoke 태그 — CI에서 빠르게 돌릴 subset
    ├── auth.spec.ts           # 로그인/회원가입 시나리오
    ├── course.spec.ts         # 강의 검색 필터·위시리스트 추가
    ├── wishlist.spec.ts       # 위시리스트 조회·우선순위·삭제
    ├── timetable.spec.ts      # 시간표 CRUD + 상세(강의 추가·대안 생성)
    ├── scenario.spec.ts       # 시나리오 CRUD
    └── registration.spec.ts   # 수강신청 시작·완료·취소
```

### 실행

```bash
cd tests/e2e
npm run test:smoke   # smoke 9개 — 핵심 흐름 빠른 검증
npm test             # 전체 32개
npm run test:ui      # 대화형 디버깅
npm run test:headed  # 브라우저 표시하며 실행
npm run codegen      # 브라우저 조작 → 코드 자동 생성

# 도메인별 단독 실행
npx playwright test specs/course.spec.ts
npx playwright test specs/wishlist.spec.ts
npx playwright test specs/scenario.spec.ts
npx playwright test specs/registration.spec.ts
```

### 핵심 설계

**인증 전략 - storageState 패턴**

매 테스트마다 로그인하지 않고 1회 로그인 후 `.auth/user.json`에 저장. 나머지 테스트는 재사용하여 인증 비용 최소화.

**ApiHelper — UI 없이 테스트 데이터 생성/삭제**

`beforeEach`/`afterEach`에서 UI 조작 없이 API 직접 호출로 데이터를 준비하고 정리한다.
`localStorage`의 `accessToken`을 `page.evaluate()`로 지연 추출하므로 별도 인증 로직 불필요.

```typescript
test('위시리스트 항목이 표시된다', async ({ wishlistPage, api }) => {
  const course = await api.getFirstCourseWithClassTimes();
  await api.addToWishlist(course.id, 1);       // beforeEach 또는 테스트 내에서 준비
  await wishlistPage.goto();
  await wishlistPage.expectCourseVisible(course.courseName);
});

// afterEach cleanup
await api.clearWishlist();
await api.deleteTimetable(timetableId);
```

**로케이터 우선순위**

```typescript
page.getByRole('button', { name: '로그인' })  // 1순위: 시맨틱
page.getByLabel('이메일')                      // 2순위: 레이블
page.getByPlaceholder('시간표 이름')           // 3순위: Placeholder
page.getByTestId('timetable-card')             // 4순위: data-testid
page.locator('.class-name')                    // 최후 수단 (지양)
```

**Page Object Model (POM)**

반복되는 UI 인터랙션을 Page Object로 캡슐화. 새 페이지는 `pages/*.page.ts`에 추가하고 `fixtures/base.fixture.ts`에 등록.

**window.confirm 처리 패턴**

`confirm()` 다이얼로그가 있는 버튼 클릭 시 `page.once('dialog', ...)`를 버튼 클릭 **직전**에 등록한다.
Page Object 내부에 숨기지 않고 spec에서 직접 처리해야 accept/dismiss를 선택적으로 제어할 수 있다.

```typescript
// ✅ spec에서 직접 처리
page.once('dialog', (dialog) => dialog.accept());
await registrationPage.clickCancel();   // 내부에서 confirm() 호출
await registrationPage.expectCancelToast();
```

### 새 테스트 작성

```typescript
import { test, expect } from '../fixtures/base.fixture';

test('@smoke 새 기능이 동작한다', async ({ page, api }) => {
  // API로 데이터 준비 (UI 없이)
  const timetable = await api.createTimetable('E2E 테스트');
  // 테스트 로직
  await page.goto(`/timetables/${timetable.id}`);
  await expect(page.getByRole('heading', { name: 'E2E 테스트', level: 1 })).toBeVisible();
  // afterEach에서 정리
});
```

- smoke subset 포함 시 제목에 `@smoke` 추가
- 데이터 생성은 `api.*` 메서드로, 정리는 `afterEach`에서 수행
- `Date.now()`로 고유 이름 생성하여 테스트 간 충돌 방지

### 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `E2E_USER_EMAIL` | `e2e-test@example.com` | 테스트용 계정 이메일 |
| `E2E_USER_PASSWORD` | `Test1234!` | 테스트용 계정 비밀번호 |
| `BASE_URL` | `http://localhost:3000` | Next.js URL |
| `API_BASE_URL` | `http://localhost:8080` | 백엔드 API URL |

`auth.setup.ts`가 테스트 계정을 자동 생성하므로 별도 계정 생성 불필요.
