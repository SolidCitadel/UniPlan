# Backend Development Guide

UniPlan 백엔드 (Spring Boot) 개발 가이드입니다.

## 1. DDD (Domain-Driven Design)

### 도메인 모델 설계 원칙

1. **엔티티 중심 설계**
   - 각 엔티티는 비즈니스 로직을 포함해야 합니다.
   - 예: `Timetable.addCourse(courseId)` 메서드 내에 제외 과목 검증 로직 포함.

2. **애그리거트 경계**
   - **Timetable**은 TimetableItem을 관리 (Cascade)
   - **Scenario**는 자식 Scenario 리스트를 관리
   - **Registration**은 RegistrationStep을 관리

3. **레이어 아키텍처**
   ```
   Controller (Presentation)
       ↓
   Service (Application)
       ↓
   Domain Model (Business Rules)
       ↓
   Repository (Infrastructure)
   ```

### 패키지 구조 (예: planner-service)

```
planner-service/
├── domain/                  # 도메인 별 패키징
│   ├── timetable/
│   │   ├── Timetable.java (Entity)
│   │   ├── TimetableRepository.java (Interface)
│   │   └── TimetableService.java (Business Logic)
│   ├── scenario/
│   └── registration/
├── controller/              # API 진입점
│   ├── TimetableController.java
│   └── ...
└── dto/                     # 데이터 전송 객체
    ├── TimetableRequest.java
    └── TimetableResponse.java
```

## 2. Coding Conventions (Java/Kotlin)

### 명명 규칙
- **클래스**: PascalCase (`TimetableService`)
- **메서드/변수**: camelCase (`addCourse`, `excludedCourseIds`)
- **상수**: UPPER_SNAKE_CASE (`MAX_PRIORITY`)
- **패키지**: lowercase (`com.uniplan.planner.domain`)

### 코드 스타일
- **Indentation**: 4 spaces
- **Builder Pattern**: 복잡한 객체 생성 시 Builder 사용 권장
  ```java
  Timetable timetable = Timetable.builder()
      .name("Plan A")
      .openingYear(2025)
      .build();
  ```

### Controller 규칙
- **RESTful API**: 리소스 중심 URL 설계
  - `GET /timetables/{id}`
  - `POST /timetables`
- **Response**: 항상 일관된 DTO 반환 (Entity 직접 반환 금지)
- **Error Handling**: `@ControllerAdvice`를 통한 전역 예외 처리

## 3. Configuration

설정 아키텍처(Spring Profile, Docker Compose 환경 구분, 주요 환경변수)는 [Architecture 문서](../architecture.md#설정-아키텍처-configuration-architecture) 및 [ADR-004](../adr/004-centralized-config.md)를 참조하세요.

## 4. API & Gateway Integration

### Controller 매핑 규칙
Gateway가 `/api/v1` 프리픽스를 제거하고 라우팅하므로, 내부 서비스의 Controller는 프리픽스 없이 매핑해야 합니다.

```java
// ❌ 잘못된 매핑 (Gateway가 이미 /api/v1 제거함)
@RequestMapping("/api/v1/users")

// ✅ 올바른 매핑
@RequestMapping("/users")
```

### Gateway 라우팅 설정 예시
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

### Swagger 설정 (Gateway 통합)
```java
// Gateway에서 서비스별 그룹화
@Bean
public GroupedOpenApi userServiceApi() {
    return GroupedOpenApi.builder()
            .group("1. User Service")
            .pathsToMatch("/api/v1/auth/**", "/api/v1/users/**")
            .build();
}
```

## 5. Internal Communication (MSA)

서비스 간 통신은 OpenFeign을 사용하며, 내부망 전용 API는 `/internal/**` 경로를 사용합니다.

### Internal Controller 패턴
```java
// catalog-service: InternalCourseController
@RestController
@RequestMapping("/internal/courses")
public class InternalCourseController {
    @GetMapping
    public List<CourseResponse> getCoursesByIds(@RequestParam List<Long> ids) {
        return courseQueryService.getCoursesByIds(ids);
    }
}
```

### Feign Client 패턴
```java
// planner-service: CatalogFeignClient
@FeignClient(name = "catalog-service", url = "${services.catalog.url}")
public interface CatalogFeignClient {
    @GetMapping("/internal/courses")
    List<CourseFullResponse> getCoursesByIds(@RequestParam("ids") List<Long> ids);
}
```

## 6. Domain Implementation Examples

### Planner Service Entity 참조 구현

**WishlistItem**
```java
@Entity
@Table(name = "wishlist_items")
class WishlistItem {
    Long id;
    Long userId;
    Long courseId;           // catalog-service의 Course 참조
    Integer priority;        // 1(최우선) ~ 5(최하위)
    // 제약조건: (userId, courseId) UNIQUE
}
```

**Timetable Structure**
```java
@Entity
@Table(name = "timetables")
class Timetable {
    Long id;
    List<TimetableItem> items;        // 강의 목록
    Set<Long> excludedCourseIds;      // 제외된 과목 목록
}
```

**Scenario (Decision Tree)**
```java
@Entity
@Table(name = "scenarios")
class Scenario {
    Scenario parentScenario;          // 부모 (null이면 루트)
    List<Scenario> childScenarios;    // 자식 (대안)
    Set<Long> failedCourseIds;        // 실패 조건
    Timetable timetable;              // 연결된 시간표
}
```

