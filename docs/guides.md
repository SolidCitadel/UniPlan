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

## 요약

### DDD
- 서비스별 독립 도메인
- 엔티티 중심 비즈니스 로직
- 명확한 레이어 분리

### Test
- 단위 테스트: JUnit 5 + Mockito
- 통합 테스트: SpringBootTest + MockMvc
- E2E 테스트: pytest (도메인별 Happy Path + Edge Cases)
- 품질 게이트 필수 통과

### Conventions
- 백엔드: Java/Kotlin 표준 규칙
- 프론트엔드: React Query + TypeScript + shadcn/ui
- 공통: 명확한 커밋 메시지, PR 체크리스트, 보안 준수
