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
- 프레임워크: JUnit 5 (백엔드), Flutter Test (프론트엔드)
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
- 대상: 프론트엔드가 사용하는 API Gateway 전체 워크플로우
- 위치: `tests/e2e/`
- 프레임워크: Dart Test
- 핵심: **공통 DTO 패키지**를 통해 프론트엔드와 DTO 공유

**구조:**
```
packages/
  └── uniplan_models/          # 공통 DTO 패키지
      ├── pubspec.yaml
      └── lib/
          └── src/
              ├── timetable.dart      # Freezed DTO
              ├── scenario.dart
              └── registration.dart

tests/
  └── e2e/
      ├── pubspec.yaml         # uniplan_models 의존
      └── test/
          ├── full_workflow_test.dart
          ├── auth_test.dart
          └── registration_test.dart

app/frontend/
  └── pubspec.yaml             # uniplan_models 의존
```

**장점:**
- ✅ 프론트엔드와 동일한 DTO 사용 → 완전한 API 계약 검증
- ✅ E2E 테스트 통과 = 프론트엔드 파싱 보장
- ✅ 타입 안정성 (컴파일 타임 오류 감지)
- ✅ DTO 변경 시 한 곳만 수정

**예시:**
```dart
// tests/e2e/test/full_workflow_test.dart
import 'package:test/test.dart';
import 'package:uniplan_models/uniplan_models.dart';  // 프론트와 같은 DTO

test('Timetable alternative returns correct format', () async {
  final response = await http.post(...);

  // 프론트엔드와 동일한 파싱 로직
  final timetable = Timetable.fromJson(jsonDecode(response.body));

  // ✅ 이게 통과하면 프론트엔드도 파싱 가능!
  expect(timetable.excludedCourses.length, 2);
  expect(timetable.excludedCourses[0].courseId, 101);
});
```

**실행:**
```bash
cd tests/e2e
dart pub get
dart test
```

### 테스트 커버리지 목표

- **백엔드**: 핵심 도메인 로직 80% 이상
- **프론트엔드**: 주요 비즈니스 로직 (Notifier, Mapper) 60% 이상

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
flutter analyze
flutter test
```

**E2E (선택적, 주요 변경 시):**
```bash
cd tests/e2e
dart pub get
dart test
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

### 프론트엔드 (Flutter/Dart)

**1. 명명 규칙**
- 클래스: PascalCase (`TimetableListScreen`)
- 변수/함수: camelCase (`fetchTimetables`, `selectedTimetable`)
- 파일: snake_case (`timetable_list_screen.dart`)
- 상수: lowerCamelCase (`defaultPadding`)

**2. 상태 관리 (Riverpod 3)**
- `AsyncNotifier` + `AsyncNotifierProvider`만 사용
- `StateNotifier`, `AutoDisposeAsyncNotifier` 금지
- 예시:
  ```dart
  @riverpod
  class TimetableList extends AsyncNotifier<List<Timetable>> {
    @override
    Future<List<Timetable>> build() async {
      return ref.read(timetableRepositoryProvider).fetchAll();
    }

    Future<void> create(TimetableRequest req) async {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        await ref.read(timetableRepositoryProvider).create(req);
        return ref.read(timetableRepositoryProvider).fetchAll();
      });
    }
  }
  ```

**3. 엔티티/DTO (Freezed)**
- abstract class + freezed 패턴만 사용
- 예시:
  ```dart
  @freezed
  class Timetable with _$Timetable {
    const factory Timetable({
      required int id,
      required String name,
      required int openingYear,
      required String semester,
    }) = _Timetable;

    factory Timetable.fromJson(Map<String, dynamic> json) =>
        _$TimetableFromJson(json);
  }
  ```

**4. 디자인 토큰 (AppTokens)**
- 색상: `AppTokens.primary`, `AppTokens.surface`
- 타이포: `AppTokens.heading`, `AppTokens.body`, `AppTokens.caption`
- 스페이싱: `AppTokens.spacing16`, `AppTokens.spacing24`
- 라운딩: `AppTokens.radius12`
- 하드코딩된 색상/폰트 지양

**5. 코드 생성**
- `*.g.dart`, `*.freezed.dart`는 `build_runner`로 생성
- 생성 후 반드시 커밋:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
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
- [ ] 품질 게이트 통과 (test, analyze)
- [ ] 코드 생성 파일 갱신 (프론트엔드)
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

## 요약

### DDD
- 서비스별 독립 도메인
- 엔티티 중심 비즈니스 로직
- 명확한 레이어 분리

### Test
- 단위/통합/E2E 테스트
- E2E: 공통 DTO 패키지로 프론트엔드와 완전한 계약 검증
- 품질 게이트 필수 통과
- 핵심 로직 80% 커버리지 목표

### Conventions
- 백엔드: Java/Kotlin 표준 규칙
- 프론트엔드: Riverpod 3 + Freezed + AppTokens
- 공통: 명확한 커밋 메시지, PR 체크리스트, 보안 준수
