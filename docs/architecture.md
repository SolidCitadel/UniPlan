# Architecture

UniPlan의 시스템 아키텍처, API 설계, 엔티티 구조를 설명합니다.

---

## API Gateway & Routing

### 경로 변환 규칙

**핵심 원칙**: "마이크로서비스는 Gateway의 라우팅 규칙을 모른다"

```
클라이언트: /api/v1/users/me
    ↓
API Gateway: RewritePath 적용
    ↓
내부 서비스: /users/me
```

### 서비스별 라우팅

| 외부 경로 (클라이언트) | 내부 경로 (서비스) | 서비스 |
|---------------------|------------------|--------|
| `/api/v1/auth/**` | `/auth/**` | user-service |
| `/api/v1/users/**` | `/users/**` | user-service |
| `/api/v1/timetables/**` | `/timetables/**` | planner-service |
| `/api/v1/scenarios/**` | `/scenarios/**` | planner-service |
| `/api/v1/wishlist/**` | `/wishlist/**` | planner-service |
| `/api/v1/registrations/**` | `/registrations/**` | planner-service |
| `/api/v1/courses/**` | `/courses/**` | catalog-service |

### Gateway 설정 예시

```yaml
# api-gateway/application-local.yml
routes:
  - id: user-service
    uri: http://localhost:8081
    predicates:
      - Path=/api/v1/auth/**, /api/v1/users/**
    filters:
      - RewritePath=/api/v1/(?<segment>.*), /$\{segment}
```

### Controller 매핑 규칙

```java
// ❌ 잘못된 매핑 (Gateway가 이미 /api/v1 제거함)
@RequestMapping("/api/v1/users")

// ✅ 올바른 매핑
@RequestMapping("/users")
```

### JWT 인증 흐름

```
1. 클라이언트 요청
   GET /api/v1/users/me
   Authorization: Bearer {token}

2. Gateway
   - JWT 검증
   - X-User-Id, X-User-Email, X-User-Role 헤더 추가
   - 경로 변환: /api/v1/users/me → /users/me

3. User Service
   GET /users/me
   X-User-Id: 123

4. 응답
   200 OK { id: 123, email: "...", ... }
```

**인증 예외 경로**: `/api/v1/auth/**` (로그인/회원가입)

---

## Swagger Documentation

### 구조

```
backend/
├── api-gateway/              ← Swagger (통합) ✅
│   ├── Port: 8080
│   └── URL: http://localhost:8080/swagger-ui.html
│
├── user-service/             ← Swagger (독립) ✅
│   ├── Port: 8081
│   └── URL: http://localhost:8081/swagger-ui.html
│
├── planner-service/          ← Swagger (독립) ✅
│   ├── Port: 8082
│   └── URL: http://localhost:8082/swagger-ui.html
│
└── catalog-service/          ← Swagger (독립) ✅
    ├── Port: 8083
    └── URL: http://localhost:8083/swagger-ui.html
```

### 역할 분담

**API Gateway Swagger (통합 문서)**
- 목적: 프론트엔드 개발자를 위한 원스톱 문서
- 특징: 서비스별 그룹화, 통합 JWT 인증, Try it out 기능

**개별 서비스 Swagger (독립 문서)**
- 목적: 백엔드 개발자를 위한 서비스별 상세 문서
- 특징: 단일 책임, 빠른 로딩, 독립 배포

### 의존성

```kotlin
// API Gateway (WebFlux 기반)
implementation("org.springdoc:springdoc-openapi-starter-webflux-ui:2.3.0")

// 일반 서비스 (WebMVC 기반)
implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")
```

### Gateway에서 서비스 그룹화

```java
@Bean
public GroupedOpenApi userServiceApi() {
    return GroupedOpenApi.builder()
            .group("1. User Service")
            .pathsToMatch("/api/v1/auth/**", "/api/v1/users/**")
            .build();
}

@Bean
public GroupedOpenApi plannerServiceApi() {
    return GroupedOpenApi.builder()
            .group("2. Planner Service")
            .pathsToMatch("/api/v1/planner/**", "/api/v1/timetables/**")
            .build();
}
```

---

## Planner Service Entity Design

### 아키텍처 개요

```
Wishlist → Timetable → Scenario → Registration
   |           |          |            |
   └── 과목 저장 → 조합 생성 → 대안 구조화 → 실시간 네비게이션
```

### 1. WishlistItem (희망과목)

```java
@Entity
@Table(name = "wishlist_items")
class WishlistItem {
    Long id;
    Long userId;
    Long courseId;           // catalog-service의 Course 참조
    Integer priority;        // 1(최우선) ~ 5(최하위)
    LocalDateTime addedAt;

    // 제약조건: (userId, courseId) UNIQUE
}
```

**용도**: 사용자가 수강하고 싶은 과목을 우선순위와 함께 저장

### 2. Timetable (시간표)

```java
@Entity
@Table(name = "timetables")
class Timetable {
    Long id;
    Long userId;
    String name;
    Integer openingYear;
    String semester;
    List<TimetableItem> items;        // 강의 목록
    Set<Long> excludedCourseIds;      // 제외된 과목 목록
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}

@Entity
@Table(name = "timetable_items")
class TimetableItem {
    Long id;
    Timetable timetable;
    Long courseId;
    Integer orderIndex;
}
```

**용도**: 특정 학기의 강의 조합 (예: "2025-1학기 기본 계획")

**제외 과목 관리**:
- DB 저장: `excludedCourseIds` (Set<Long>)
- API 응답: `excludedCourses` (각 항목에 courseId와 과목 상세 포함)
- 이유: 클라이언트가 바로 활용 가능하도록

### 3. Scenario (의사결정 트리)

```java
@Entity
@Table(name = "scenarios")
class Scenario {
    Long id;
    Long userId;
    String name;
    String description;

    // 트리 구조
    Scenario parentScenario;          // null이면 루트
    List<Scenario> childScenarios;

    // 실패 조건
    Set<Long> failedCourseIds;        // empty면 기본(루트)
    Integer orderIndex;

    // 실제 시간표 참조
    Timetable timetable;

    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}
```

**용도**: 수강신청 실패 시 대안 계획을 트리 구조로 표현

**Decision Tree 예시**:
```
Plan A (CS101, CS102, CS103)
  ├─ Plan B: CS101만 실패 → (CS104, CS102, CS103)
  ├─ Plan C: CS102만 실패 → (CS101, CS106, CS103)
  └─ Plan D: CS101 + CS102 실패 → (CS104, CS106, CS103)
```

### 4. Registration (수강신청 시뮬레이션)

```java
@Entity
@Table(name = "registrations")
class Registration {
    Long id;
    Long userId;

    Scenario startScenario;    // 시작 시나리오
    Scenario currentScenario;  // 현재 시나리오 (실패 시 변경)

    RegistrationStatus status; // IN_PROGRESS, COMPLETED, CANCELLED

    LocalDateTime startedAt;
    LocalDateTime completedAt;
    LocalDateTime updatedAt;

    List<RegistrationStep> steps;
}

@Entity
@Table(name = "registration_steps")
class RegistrationStep {
    Long id;
    Registration registration;
    Long courseId;
    StepResult result;         // SUCCESS, FAILED
    LocalDateTime timestamp;
}
```

**용도**: 실제 수강신청 중 성공/실패를 기록하고 의사결정 트리를 따라 자동 네비게이션

### API 계약 (중요)

**Timetable & Scenario 공통 규칙**:
- 요청: `excludedCourseIds` (Long 배열)
- 응답: `excludedCourses` (courseId를 포함한 객체 배열)

예시:
```json
// 요청
POST /api/v1/timetables/1/alternatives
{
  "name": "Plan B",
  "excludedCourseIds": [101, 102]
}

// 응답
{
  "id": 2,
  "excludedCourses": [
    { "courseId": 101, "courseName": "CS101", ... },
    { "courseId": 102, "courseName": "CS102", ... }
  ]
}
```

### 완전한 사용자 워크플로우

```
1. 희망과목 담기
   POST /api/v1/wishlist { courseId: 101, priority: 1 }

2. 시간표 생성
   POST /api/v1/timetables { name: "Plan A", ... }
   POST /api/v1/timetables/1/courses { courseId: 101 }
   POST /api/v1/timetables/1/alternatives { name: "Plan B", excludedCourseIds: [101] }

3. 시나리오 생성
   POST /api/v1/scenarios { name: "Plan A", timetableId: 1 }
   POST /api/v1/scenarios/10/alternatives { name: "Plan B", failedCourseId: 101, timetableId: 2 }

4. 수강신청 시작
   POST /api/v1/registrations { scenarioId: 10 }

5. 실시간 진행
   POST /api/v1/registrations/100/steps { succeededCourses: [], failedCourses: [101] }
   → 자동으로 Plan B로 네비게이션

6. 완료
   POST /api/v1/registrations/100/complete
```

### 설계 장점

1. **관심사 분리**: Wishlist(희망) → Timetable(조합) → Scenario(로직) → Registration(실행)
2. **재사용성**: 같은 Timetable을 여러 Scenario에서 참조 가능
3. **확장성**: 여러 강의 실패 조합 지원
4. **데이터 무결성**: Timetable이 제외 과목 검증하여 실수 방지
5. **자동 네비게이션**: 실패 시 자동으로 대안 시나리오로 이동