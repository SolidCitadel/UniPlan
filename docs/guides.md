# Development Guides

UniPlan 프로젝트의 개발 방법론, 테스트 전략, 코딩 컨벤션을 설명합니다.

---

## DDD (Domain-Driven Design)

### 적용 범위

UniPlan은 MSA 기반이므로 서비스별로 독립적인 도메인을 가집니다.

**서비스별 도메인**:
- **user-service**: 사용자 인증 및 계정 관리
- **planner-service**: 시간표, 시나리오, 수강신청 플래닝
- **catalog-service**: 강의 목록 및 검색

### 도메인 모델 설계 원칙

1. **엔티티 중심 설계**
   - 각 엔티티는 비즈니스 로직을 포함
   - 예: `Timetable.addCourse(courseId)` → 제외 과목 검증 내장

2. **애그리거트 경계**
   - Timetable이 TimetableItem을 관리
   - Scenario가 자식 Scenario 리스트를 관리
   - Registration이 RegistrationStep을 관리

3. **도메인 이벤트**
   - 향후 추가 예정: `CourseFailedEvent`, `ScenarioNavigatedEvent` 등

4. **레이어 분리**
   ```
   Controller → Service → Domain Model → Repository
   ```

### 패키지 구조 (예: planner-service)

```
planner-service/
├── domain/
│   ├── timetable/
│   │   ├── Timetable.java (엔티티)
│   │   ├── TimetableRepository.java (인터페이스)
│   │   └── TimetableService.java (도메인 로직)
│   ├── scenario/
│   │   ├── Scenario.java
│   │   ├── ScenarioRepository.java
│   │   └── ScenarioService.java
│   └── registration/
│       ├── Registration.java
│       ├── RegistrationRepository.java
│       └── RegistrationService.java
├── controller/
│   ├── TimetableController.java
│   ├── ScenarioController.java
│   └── RegistrationController.java
└── dto/
    ├── TimetableRequest.java
    ├── TimetableResponse.java
    └── ...
```

---

## Test Strategy

### 테스트 레벨

**1. 단위 테스트 (Unit Test)**
- 대상: 도메인 로직, 유틸리티 함수
- 프레임워크: JUnit 5 (백엔드), Jest (프론트엔드)
- 예시:
  ```java
  @Test
  void shouldRejectExcludedCourseWhenAddingToTimetable() {
      Timetable timetable = new Timetable();
      timetable.addExcludedCourse(101L);

      assertThrows(IllegalArgumentException.class, () -> {
          timetable.addCourse(101L);
      });
  }
  ```

**2. 통합 테스트 (Integration Test)**
- 대상: Controller + Service + Repository
- 프레임워크: Spring Boot Test, MockMvc
- 예시:
  ```java
  @SpringBootTest
  @AutoConfigureMockMvc
  class TimetableControllerTest {
      @Test
      void shouldCreateTimetable() throws Exception {
          mockMvc.perform(post("/timetables")
                  .contentType(APPLICATION_JSON)
                  .content("{\"name\":\"Plan A\"}"))
              .andExpect(status().isOk())
              .andExpect(jsonPath("$.name").value("Plan A"));
      }
  }
  ```

**3. E2E 테스트 (End-to-End Test)**
- 대상: API Gateway를 통한 전체 시스템
- 위치: `tests/e2e/`
- 프레임워크: pytest (Python, uv)

**구조 (도메인별 분리):**
```
tests/e2e/
├── pyproject.toml        # 의존성 (uv)
├── conftest.py           # fixtures
├── test_auth.py          # 인증
├── test_courses.py       # 강의 검색
├── test_wishlist.py      # 위시리스트
├── test_timetable.py     # 시간표
├── test_scenario.py      # 시나리오
└── test_registration.py  # 수강신청
```

각 파일에 Happy Path + Edge Cases 포함.

**실행:**
```bash
cd tests/e2e
uv sync
uv run pytest -v
```

### 테스트 커버리지 목표

- **백엔드**: 핵심 도메인 로직 80% 이상
- **프론트엔드**: 주요 비즈니스 로직 60% 이상

### 테스트 작성 원칙

> **핵심 원칙: 테스트는 최대한 적극적으로 실패를 유발해야 한다.**
>
> E2E 테스트는 **프론트엔드 개발자가 백엔드 컨트롤러를 확인하지 않고도 API를 구현할 수 있는 계약서** 역할을 한다.
> 상태 코드, DTO 필드, 응답 구조 등 모든 세부사항을 명시적으로 검증해야 한다.

**1. 단일 상태 코드 검증 (느슨한 검증 금지)**
```python
# ❌ Bad - 느슨한 검증은 API 계약을 모호하게 만듦
assert response.status_code in (200, 400, 409)
assert response.status_code in (200, 201)  # 어느 것이 정확한 응답인지 알 수 없음

# ✅ Good - 정확한 상태 코드 검증
assert response.status_code == 201, f"Expected 201, got {response.status_code}: {response.text}"
assert response.status_code == 409, "중복 리소스는 409 Conflict"
```

**RESTful 상태 코드 규칙:**
| 동작 | 상태 코드 | 설명 |
|------|-----------|------|
| POST (리소스 생성) | **201 Created** | 새 리소스 생성 |
| POST (상태 변경) | **200 OK** | complete, cancel, navigate 등 |
| GET | **200 OK** | 조회 성공 |
| PUT/PATCH | **200 OK** | 수정 성공 |
| DELETE | **204 No Content** | 삭제 성공 (본문 없음) |
| 중복 리소스 | **409 Conflict** | 이미 존재 |
| 잘못된 요청 | **400 Bad Request** | 유효성 검증 실패 |
| 리소스 없음 | **404 Not Found** | 존재하지 않는 리소스 |
| 인증 실패 | **401 Unauthorized** | 토큰 없음/만료 |

**2. DTO 필드 완전 검증**
```python
# ❌ Bad - 일부 필드만 검증
def test_create_timetable(auth_client):
    response = auth_client.post("/timetables", json={...})
    assert response.status_code == 201
    assert response.json()["id"] is not None  # 나머지 필드는?

# ✅ Good - 모든 필수 필드 검증 (프론트엔드 계약)
def test_create_timetable(auth_client):
    response = auth_client.post("/timetables", json={
        "name": "Test", "openingYear": 2026, "semester": "1"
    })
    assert response.status_code == 201

    data = response.json()
    # 필수 필드 존재 검증
    assert "id" in data
    assert "name" in data
    assert "openingYear" in data
    assert "semester" in data
    assert "items" in data
    assert "excludedCourses" in data
    assert "createdAt" in data
    assert "updatedAt" in data

    # 타입 검증
    assert isinstance(data["id"], int)
    assert isinstance(data["items"], list)
    assert isinstance(data["excludedCourses"], list)

    # 값 검증
    assert data["name"] == "Test"
    assert data["openingYear"] == 2026
```

**3. 에러 응답도 구체적으로 검증**
```python
# ❌ Bad - 에러 코드만 검증
def test_duplicate_email(api_client):
    response = api_client.post("/auth/signup", json={...})
    assert response.status_code in (400, 409)  # 어느 것?

# ✅ Good - 에러 코드와 메시지 구조 검증
def test_duplicate_email(api_client):
    response = api_client.post("/auth/signup", json={...})
    assert response.status_code == 409

    error = response.json()
    assert "message" in error or "error" in error
    # 프론트엔드가 에러 메시지를 표시할 수 있도록
```

**4. Skip 금지 - 예상치 못한 상황은 Fail**
```python
# ❌ Bad - skip으로 문제를 숨김
def test_search_course(auth_client):
    response = auth_client.get("/courses?size=1")
    if not response.json():
        pytest.skip("과목이 없습니다")  # 문제가 숨겨짐!

# ✅ Good - fixture로 데이터 준비
@pytest.fixture
def test_course(catalog_client):
    """테스트용 과목 생성"""
    return catalog_client.create_course({...})

def test_search_course(auth_client, test_course):
    response = auth_client.get(f"/courses?name={test_course['name']}")
    assert response.status_code == 200
    assert len(response.json()) > 0
```

**5. 테스트는 자체적으로 데이터 준비**
- fixture를 통해 필요한 데이터 생성
- 외부 상태에 의존하지 않음
- 테스트 간 독립성 보장

**6. Skip 허용 케이스 (예외적)**
- 특정 환경에서만 실행 가능한 테스트 (OS, 외부 서비스)
- `@pytest.mark.skipif(condition, reason="...")` 사용
- reason에 명확한 사유 기록

**7. Edge Case도 명확한 계약**
```python
# ❌ Bad - 여러 에러 코드 허용
def test_add_excluded_course(auth_client, timetable_id, excluded_course_id):
    response = auth_client.post(f"/timetables/{timetable_id}/courses", json={"courseId": excluded_course_id})
    assert response.status_code in (400, 409)  # 둘 중 뭐가 맞아?

# ✅ Good - 백엔드 계약에 따라 하나만
def test_add_excluded_course(auth_client, timetable_id, excluded_course_id):
    response = auth_client.post(f"/timetables/{timetable_id}/courses", json={"courseId": excluded_course_id})
    assert response.status_code == 409, "제외된 과목 추가 시 409 Conflict"
```

### 품질 게이트

모든 PR은 다음 테스트를 통과해야 합니다:

**백엔드:**
```bash
cd app/backend
./gradlew clean test
```

**프론트엔드:**
```bash
cd app/frontend
npm run build
npm run lint
```

**E2E 시나리오 테스트 (선택적, 주요 변경 시):**
```bash
cd tests/e2e
uv sync
uv run pytest -v
```

---

## Coding Conventions

### 백엔드 (Java/Kotlin)

**1. 명명 규칙**
- 클래스: PascalCase (`TimetableService`)
- 메서드/변수: camelCase (`addCourse`, `excludedCourseIds`)
- 상수: UPPER_SNAKE_CASE (`MAX_PRIORITY`)
- 패키지: lowercase (`com.uniplan.planner.domain`)

**2. 코드 스타일**
- 들여쓰기: 4 spaces
- 한 줄 길이: 120자 이하
- 빌더 패턴 권장:
  ```java
  Timetable timetable = Timetable.builder()
      .name("Plan A")
      .openingYear(2025)
      .semester("1학기")
      .build();
  ```

**3. 애노테이션 순서**
```java
@Entity
@Table(name = "timetables")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Timetable { ... }
```

**4. Controller 규칙**
- RESTful API: `GET /timetables/{id}`, `POST /timetables`, `DELETE /timetables/{id}`
- 응답 형태: 일관된 DTO 사용
- 예외 처리: `@ControllerAdvice`로 전역 처리

### 프론트엔드 (Next.js/TypeScript)

**1. 명명 규칙**
- 컴포넌트: PascalCase (`TimetableList`, `WeeklyGrid`)
- 변수/함수: camelCase (`fetchTimetables`, `selectedTimetable`)
- 파일: kebab-case (`timetable-list.tsx`, `weekly-grid.tsx`)
- 타입/인터페이스: PascalCase (`Timetable`, `TimetableItem`)

**2. 상태 관리 (React Query)**
- `@tanstack/react-query` 사용
- 서버 상태: `useQuery`, `useMutation`
- 로컬 상태: `useState`, `useMemo`
- 예시:
  ```typescript
  const { data: timetables, isLoading } = useQuery({
    queryKey: ['timetables'],
    queryFn: timetableApi.getAll,
  });

  const createMutation = useMutation({
    mutationFn: timetableApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['timetables'] });
      toast.success('시간표가 생성되었습니다');
    },
  });
  ```

**3. 타입 정의**
- `src/types/` 디렉토리에 타입 정의
- 예시:
  ```typescript
  export interface Timetable {
    id: number;
    name: string;
    openingYear: number;
    semester: string;
    items: TimetableItem[];
    excludedCourses: ExcludedCourse[];
  }
  ```

**4. UI 컴포넌트 (shadcn/ui + Tailwind)**
- shadcn/ui 컴포넌트 사용 (`@/components/ui/`)
- Tailwind CSS로 스타일링
- 일관된 디자인 토큰 사용

**5. API 클라이언트**
- axios 기반 (`@/lib/api/`)
- 인터셉터로 JWT 토큰 자동 첨부
- 예시:
  ```typescript
  export const timetableApi = {
    getAll: () => apiClient.get<Timetable[]>('/timetables').then(r => r.data),
    create: (data: CreateTimetableRequest) =>
      apiClient.post<Timetable>('/timetables', data).then(r => r.data),
  };
  ```

### 공통 규칙

**1. Git 커밋 메시지**
```
feat: 시간표 대안 생성 기능 추가
fix: 제외 과목 검증 버그 수정
docs: API 명세 업데이트
refactor: Scenario 엔티티 구조 개선
test: Timetable 단위 테스트 추가
```

**2. PR 체크리스트**
- [ ] 관련 테스트 추가/수정
- [ ] 품질 게이트 통과 (test, build, lint)
- [ ] 관련 문서 업데이트 (docs/, README)
- [ ] API 변경 시 Swagger 확인

**3. 보안**
- 비밀값 (.env, DB 비밀번호, JWT 시크릿) 커밋 절대 금지
- 로컬 설정은 예시 파일만 제공 (`.env.example`)

**4. 문서 우선**
- 코드 변경 시 관련 문서 동반 갱신
- API 변경 시 Swagger 애노테이션 업데이트
- 주요 결정 사항은 docs/adr/ 기록

---

## OpenAPI Type Generation

프론트엔드 타입을 백엔드 OpenAPI 스펙에서 자동 생성합니다. 백엔드 DTO 변경 시 프론트엔드에서 **컴파일 에러로 즉시 감지**됩니다.

### 디렉토리 구조

```
app/frontend/
├── scripts/
│   └── generate-types-index.mjs  # 인덱스 생성 스크립트
├── src/types/
│   ├── generated/                # 자동 생성 (Git 추적)
│   │   ├── user-service.ts
│   │   ├── planner-service.ts
│   │   ├── catalog-service.ts
│   │   └── index.ts
│   ├── aliases.ts                # 타입 별칭 (편의용)
│   ├── common.ts                 # 프론트엔드 전용 타입
│   └── index.ts                  # 통합 export
```

### 타입 생성 명령어

```bash
# 백엔드 시작 (Docker)
docker compose up -d

# 타입 생성 (http://localhost:8080 에서 OpenAPI 스펙 가져옴)
cd app/frontend
npm run types:generate

# TypeScript 체크
npm run types:check
```

### 개발 워크플로우

1. **백엔드 DTO 변경 시**:
   - 백엔드 서비스 재시작
   - `npm run types:generate` 실행
   - 생성된 타입 파일 커밋

2. **프론트엔드 개발 시**:
   - `@/types`에서 타입 import (기존과 동일)
   - 백엔드 변경 시 TypeScript 컴파일 에러로 불일치 감지

3. **CI에서** (수동 실행):
   - GitHub Actions > "OpenAPI Type Sync" > Run workflow
   - 생성된 타입이 커밋된 것과 다르면 빌드 실패

### 타입 사용 예시

```typescript
// 기본 사용법 (권장)
import type { Timetable, CreateTimetableRequest } from '@/types';

// 직접 생성 타입 접근 (고급)
import type { components } from '@/types/generated/planner-service';
type RawTimetable = components['schemas']['TimetableResponse'];
```

### 주의사항

- `src/types/generated/*.ts` 파일은 **수동 수정 금지**
- 백엔드가 실행 중이어야 타입 생성 가능 (OpenAPI 엔드포인트 필요)
- `aliases.ts`에서 타입 별칭 매핑 관리

---

## Configuration Management

### 설계 원칙

UniPlan은 **12-Factor App** 방식을 따라 환경변수로 설정을 주입합니다:

1. **application.yml**: 플레이스홀더만 (기본값 없음)
2. **application-local.yml**: 로컬 개발용 값 (bootRun 전용)
3. **docker-compose.yml**: Docker 환경 값 (하드코딩)
4. **.env**: 프로덕션 값 (gitignore)

### 파일 구조

```
각 서비스/src/main/resources/
├── application.yml        # 플레이스홀더만 (${VAR_NAME})
└── application-local.yml  # 로컬 개발용 값

프로젝트 루트/
├── docker-compose.yml     # 개발용 (하드코딩)
├── docker-compose.test.yml# 테스트용 (하드코딩, tmpfs)
└── .env.example           # 프로덕션 템플릿
```

### 환경변수 목록

| 변수명 | 서비스 | 설명 |
|--------|--------|------|
| `SERVER_PORT` | 전체 | 서버 포트 |
| `DB_URL` | user, catalog, planner | MySQL JDBC URL |
| `DB_USER` | user, catalog, planner | DB 사용자명 |
| `DB_PASSWORD` | user, catalog, planner | DB 비밀번호 |
| `JWT_SECRET` | user, api-gateway | JWT 서명 키 (32+ bytes) |
| `GOOGLE_CLIENT_ID` | user | Google OAuth2 클라이언트 ID |
| `GOOGLE_CLIENT_SECRET` | user | Google OAuth2 클라이언트 시크릿 |
| `OAUTH2_REDIRECT_URL` | user | 로그인 성공 후 프론트엔드 콜백 URL |
| `USER_SERVICE_URI` | api-gateway | user-service 주소 |
| `PLANNER_SERVICE_URI` | api-gateway | planner-service 주소 |
| `CATALOG_SERVICE_URI` | api-gateway | catalog-service 주소 |
| `CATALOG_SERVICE_URL` | planner | catalog-service 주소 |
| `CORS_ALLOWED_ORIGINS` | api-gateway | CORS 허용 도메인 |

### 로컬 개발 (bootRun)

IDE 또는 커맨드라인에서 `local` 프로필 활성화:

```bash
# Gradle
cd app/backend
./gradlew :api-gateway:bootRun --args='--spring.profiles.active=local'

# IntelliJ IDEA
# Run Configuration → VM Options: -Dspring.profiles.active=local
```

**주의**: 로컬 MySQL이 필요합니다 (localhost:3306).

### Docker 개발 환경

```bash
# 시작 (모든 서비스)
docker compose up --build

# 재시작 (특정 서비스만)
docker compose up --build api-gateway

# 종료
docker compose down

# 볼륨 포함 종료 (DB 초기화)
docker compose down -v
```

환경변수는 `docker-compose.yml`에 하드코딩되어 있으며, 별도 설정 불필요.

### E2E 테스트 환경

```bash
# 테스트 컨테이너 시작 (tmpfs DB)
docker compose -f docker-compose.test.yml up -d --build

# 대기 (서비스 준비)
sleep 20

# 테스트 실행
cd tests/e2e && uv sync && uv run pytest -v

# 종료
docker compose -f docker-compose.test.yml down
```

### 프로덕션 배포

1. `.env.example`을 `.env`로 복사
2. 실제 값 입력 (DB 비밀번호, JWT 시크릿, OAuth 키 등)
3. docker-compose에서 `.env` 파일 참조하도록 구성

```bash
# .env 파일 사용 예시
cp .env.example .env
# .env 파일 편집...

# docker-compose.prod.yml에서 .env 참조
docker compose -f docker-compose.prod.yml up -d
```

**보안 주의사항**:
- `.env` 파일은 절대 커밋하지 않음 (gitignore에 포함)
- JWT 시크릿은 최소 32바이트 이상의 랜덤 문자열 사용
- 프로덕션 DB 비밀번호는 강력한 비밀번호 사용

---

## 요약

### DDD
- 서비스별 독립 도메인
- 엔티티 중심 비즈니스 로직
- 명확한 레이어 분리

### Test
- 단위 테스트: JUnit 5 + Mockito
- 통합 테스트: SpringBootTest + MockMvc
- E2E 테스트: pytest (도메인별 Happy Path + Edge Cases)
- **Skip 금지**: 예상치 못한 상황은 fail, fixture로 데이터 준비
- 품질 게이트 필수 통과

### Conventions
- 백엔드: Java/Kotlin 표준 규칙
- 프론트엔드: React Query + TypeScript + shadcn/ui
- 공통: 명확한 커밋 메시지, PR 체크리스트, 보안 준수

### Configuration
- application.yml: 플레이스홀더만 (기본값 없음)
- application-local.yml: 로컬 개발용
- docker-compose: 환경별 값 하드코딩
- .env: 프로덕션용 (gitignore)
