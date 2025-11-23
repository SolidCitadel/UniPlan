# Planner Service Entity Design

## 구현 상태: ✅ 완료 (2025-11-02)

모든 핵심 엔티티와 API가 완전히 구현되었습니다:
- ✅ Wishlist (희망과목)
- ✅ Timetable (시간표)
- ✅ Scenario (의사결정 트리)
- ✅ Registration (수강신청 시뮬레이션)

## Architecture Overview

```
Wishlist → Timetable → Scenario → Registration
   |           |          |            |
   └── 과목 저장 → 조합 생성 → 대안 구조화 → 실시간 네비게이션
```

## Entity Model

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
    List<TimetableItem> items;  // 강의 목록
    Set<Long> excludedCourseIds;  // 제외된 과목 목록 (대안 시간표용)
    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}

@Entity
@Table(name = "timetable_items")
class TimetableItem {
    Long id;
    Timetable timetable;
    Long courseId;  // catalog-service의 Course 참조
    Integer orderIndex;
}

@ElementCollection
@Table(name = "timetable_excluded_courses")
class ExcludedCourse {
    Long timetableId;
    Long courseId;
}
```

**용도**: 특정 학기의 강의 조합 (예: "2025-1학기 기본 계획")
**제외 과목 관리**: DB에는 excludedCourseIds로 저장하지만, API 응답은 `excludedCourses`(각 항목에 `courseId`와 과목 상세 포함) 배열로 내려 클라이언트가 바로 활용 가능

### 3. Scenario (의사결정 트리 노드)
```java
@Entity
@Table(name = "scenarios")
class Scenario {
    Long id;
    Long userId;
    String name;            // "Plan A", "CS101 실패 시 대안"
    String description;

    // 트리 구조
    Scenario parentScenario;      // null이면 루트
    List<Scenario> childScenarios;

    // 실패 조건 (여러 과목 조합)
    Set<Long> failedCourseIds;    // empty면 기본(루트), 있으면 대안
    Integer orderIndex;     // 형제 노드 간 순서

    // 실제 시간표 참조
    Timetable timetable;    // 이 시나리오의 강의 조합

    LocalDateTime createdAt;
    LocalDateTime updatedAt;
}
```

**용도**: 수강신청 실패 시 대안 계획을 트리 구조로 표현

**Decision Tree Example** (여러 과목 실패 조합 지원):
```
Plan A (CS101, CS102, CS103) - failedCourseIds: []
  ├─ Plan B: CS101만 실패 → (CS104, CS102, CS103) - failedCourseIds: [101]
  ├─ Plan C: CS102만 실패 → (CS101, CS106, CS103) - failedCourseIds: [102]
  └─ Plan D: CS101 + CS102 실패 → (CS104, CS106, CS103) - failedCourseIds: [101, 102]
```

**장점**: 단일 과목 실패뿐만 아니라 여러 과목 조합 실패에도 대응 가능

### 4. Registration (수강신청 시뮬레이션)
```java
@Entity
@Table(name = "registrations")
class Registration {
    Long id;
    Long userId;

    Scenario startScenario;    // 시작 시나리오 (Plan A)
    Scenario currentScenario;  // 현재 시나리오 (실패 시 변경됨)

    RegistrationStatus status; // IN_PROGRESS, COMPLETED, CANCELLED

    LocalDateTime startedAt;
    LocalDateTime completedAt;
    LocalDateTime updatedAt;

    List<RegistrationStep> steps;  // 수강신청 진행 기록
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

enum RegistrationStatus {
    IN_PROGRESS,
    COMPLETED,
    CANCELLED
}

enum StepResult {
    SUCCESS,
    FAILED
}
```

**용도**: 실제 수강신청 중 성공/실패를 기록하고 의사결정 트리를 따라 자동 네비게이션

## API Endpoints

### Wishlist API
```
POST   /api/v1/wishlist                 # 희망과목 추가
GET    /api/v1/wishlist                 # 내 희망과목 조회
DELETE /api/v1/wishlist/{courseId}      # 희망과목 삭제
GET    /api/v1/wishlist/check/{courseId} # 포함 여부 확인
```

### Timetable API
```
POST   /api/v1/timetables                      # 시간표 생성
POST   /api/v1/timetables/{id}/alternatives    # 대안 시간표 생성 (복사 + 제외)
GET    /api/v1/timetables                      # 내 시간표 목록
GET    /api/v1/timetables/{id}                 # 시간표 조회
PUT    /api/v1/timetables/{id}                 # 시간표 수정
DELETE /api/v1/timetables/{id}                 # 시간표 삭제
POST   /api/v1/timetables/{id}/courses         # 강의 추가 (excludedCourseIds 검증)
DELETE /api/v1/timetables/{id}/courses/{courseId} # 강의 삭제
```

### Scenario API
```
POST   /api/v1/scenarios                       # 루트 시나리오 생성
POST   /api/v1/scenarios/{parentId}/alternatives # 대안 시나리오 생성
GET    /api/v1/scenarios                       # 내 시나리오 목록
GET    /api/v1/scenarios/{id}                  # 시나리오 조회
GET    /api/v1/scenarios/{id}/tree             # 의사결정 트리 조회
PUT    /api/v1/scenarios/{id}                  # 시나리오 수정
DELETE /api/v1/scenarios/{id}                  # 시나리오 삭제
POST   /api/v1/scenarios/{id}/navigate         # 실시간 네비게이션
GET    /api/v1/scenarios/{id}/children         # 자식 시나리오 조회
```

### Registration API
```
POST   /api/v1/registrations                   # 수강신청 시작
POST   /api/v1/registrations/{id}/steps        # 단계 기록 (SUCCESS/FAILED)
GET    /api/v1/registrations/{id}              # 수강신청 조회
GET    /api/v1/registrations                   # 내 수강신청 목록
POST   /api/v1/registrations/{id}/complete     # 수강신청 완료
DELETE /api/v1/registrations/{id}              # 수강신청 취소
GET    /api/v1/registrations/{id}/succeeded-courses # 성공한 과목 조회
```

## Complete User Workflow

### 1단계: 희망과목 담기
```json
POST /api/v1/wishlist
{
  "courseId": 101,
  "priority": 1  // 1(최우선) ~ 5(최하위)
}
```

### 2단계: 시간표 생성
```json
// Plan A 생성
POST /api/v1/timetables
{
  "name": "Plan A",
  "openingYear": 2025,
  "semester": "1학기"
}
→ Response: { "id": 1, ... }

// Plan A에 강의 추가
POST /api/v1/timetables/1/courses { "courseId": 101 }  # CS101
POST /api/v1/timetables/1/courses { "courseId": 102 }  # CS102
POST /api/v1/timetables/1/courses { "courseId": 103 }  # CS103

// Plan B 생성 (CS101 실패 시 대안)
POST /api/v1/timetables/1/alternatives
{
  "name": "Plan B - CS101 failed",
  "excludedCourseIds": [101]
}
→ Response: { "id": 2, "items": [102, 103], "excludedCourses": [ { "courseId": 101, "courseName": "Course 101" } ] }

// Plan B에 대체 과목 추가
POST /api/v1/timetables/2/courses { "courseId": 104 }  # CS104 (CS101 대신)

// ❌ CS101을 Plan B에 추가 시도 → 거부됨!
POST /api/v1/timetables/2/courses { "courseId": 101 }
→ 409 Conflict: "제외된 과목은 추가할 수 없습니다: 101"
```

### 3단계: 루트 시나리오 생성 (Plan A)
```json
POST /api/v1/scenarios
{
  "name": "Plan A",
  "timetableId": 1
}
→ Response: { "id": 10, ... }
```

### 4단계: 대안 시나리오 생성 (Plan B, C...)
```json
// Plan B 시나리오 (CS101 실패 → Plan B 시간표로 이동)
POST /api/v1/scenarios/10/alternatives
{
  "name": "CS101 failed → Plan B",
  "failedCourseId": 101,
  "timetableId": 2  // 2단계에서 생성한 Plan B 시간표
}
→ Response: { "id": 11, ... }

// Plan C 시간표 생성 (CS102 실패 시 대안)
POST /api/v1/timetables/1/alternatives
{
  "name": "Plan C - CS102 failed",
  "excludedCourseIds": [102]
}
→ Response: { "id": 3, "items": [101, 103], "excludedCourses": [ { "courseId": 102, "courseName": "Course 102" } ] }

POST /api/v1/timetables/3/courses { "courseId": 106 }  # CS106 (CS102 대신)

// Plan C 시나리오 (CS102 실패 → Plan C 시간표로 이동)
POST /api/v1/scenarios/10/alternatives
{
  "name": "CS102 failed → Plan C",
  "failedCourseId": 102,
  "timetableId": 3
}
→ Response: { "id": 12, ... }
```

### 5단계: 수강신청 시뮬레이션 시작
```json
POST /api/v1/registrations
{
  "scenarioId": 10  // Plan A로 시작
}
→ Response: {
  "id": 100,
  "currentScenario": { "id": 10, "name": "Plan A" }
}
```

### 6단계: 실시간 수강신청 진행

**Note**: CLI는 단일 과목 ID와 상태를 받지만, 백엔드 API는 리스트 형식을 요구합니다.

```json
# CS101 수강신청 실패
POST /api/v1/registrations/100/steps
{
  "succeededCourses": [],
  "failedCourses": [101]
}
→ Response: {
  "id": 100,
  "currentScenario": { "id": 11, "name": "CS101 failed → Plan B" },
  "succeededCourses": []
}

# CS104 수강신청 성공
POST /api/v1/registrations/100/steps
{
  "succeededCourses": [104],
  "failedCourses": []
}
→ Response: {
  "id": 100,
  "currentScenario": { "id": 11, "name": "CS101 failed → Plan B" },
  "succeededCourses": [104]
}
```

**CLI Convenience**: CLI 클라이언트는 `registration step 100 101 FAILED` 형식으로 단일 과목을 받아서 자동으로 리스트로 변환합니다.

### 7단계: 수강신청 완료
```json
POST /api/v1/registrations/100/complete
→ Response: {
  "status": "COMPLETED",
  "succeededCourses": [104, 102, 103]
}
```

## Benefits

1. **관심사 분리**:
   - Wishlist: 수강 희망
   - Timetable: 강의 조합 + 제외 과목 관리
   - Scenario: 의사결정 로직
   - Registration: 실시간 네비게이션

2. **재사용성**: 같은 Timetable을 여러 Scenario에서 참조 가능

3. **확장성**: 나중에 복잡한 조건(여러 강의 실패 조합) 추가 가능

4. **명확성**:
   - 실패 조건(`failedCourseId`)이 Scenario에 명시적으로 저장
   - 제외 과목(`excludedCourseIds`)이 Timetable에 저장되어 일관성 유지

5. **자동 네비게이션**: 수강신청 중 실패 시 자동으로 대안 시나리오로 이동

6. **데이터 무결성**:
   - Timetable이 자체적으로 제외 과목 검증 → 실수로 실패한 과목 추가 방지
   - 대안 시간표 생성 시 자동으로 제외 과목 제외 및 복사
