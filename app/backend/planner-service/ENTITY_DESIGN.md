# Planner Service Entity Design

## Decision Tree Structure

```
Base Scenario (CS101, CS102, CS103)
  ├─ Scenario 2: CS101 fails → (CS104, CS102, CS103)
  │   └─ Scenario 3: CS104 fails → (CS105, CS102, CS103)
  └─ Scenario 4: CS102 fails → (CS101, CS106, CS103)
```

## Entity Model

### Scenario (의사결정 트리 노드)
```java
@Entity
class Scenario {
    Long id;
    Long userId;

    // 트리 구조
    Scenario parentScenario;  // null이면 루트
    List<Scenario> childScenarios;

    // 이 시나리오가 발동되는 조건
    Long failedCourseId;  // null이면 기본(루트), 있으면 대안

    // 메타데이터
    String name;  // "Plan A", "CS101 실패 시 대안"
    Integer orderIndex;  // 형제 노드 간 순서

    // 실제 시간표
    Timetable timetable;  // 이 시나리오의 강의 조합
}
```

### Timetable (단순 강의 모음)
```java
@Entity
class Timetable {
    Long id;
    String name;
    Integer openingYear;
    String semester;
    List<TimetableItem> items;  // 강의 목록
}
```

### TimetableItem (시간표의 강의)
```java
@Entity
class TimetableItem {
    Long id;
    Timetable timetable;
    Long courseId;  // catalog-service의 Course 참조
}
```

## Usage Example

### 1. 기본 시나리오 생성
```json
POST /api/v1/scenarios
{
  "name": "Plan A - 기본 계획",
  "timetableRequest": {
    "name": "2025-1학기 기본",
    "openingYear": 2025,
    "semester": "1학기",
    "courseIds": [101, 102, 103]
  }
}
```

### 2. 대안 시나리오 생성
```json
POST /api/v1/scenarios/{parentId}/alternatives
{
  "name": "Plan B - CS101 실패 시",
  "failedCourseId": 101,
  "timetableRequest": {
    "name": "대안 1",
    "openingYear": 2025,
    "semester": "1학기",
    "courseIds": [104, 102, 103]
  }
}
```

### 3. 실시간 네비게이션
```json
POST /api/v1/scenarios/{scenarioId}/navigate
{
  "failedCourseId": 101
}
Response: {
  "nextScenario": { "id": 2, "name": "Plan B - CS101 실패 시", ... }
}
```

## Benefits

1. **관심사 분리**: Timetable은 강의 모음만, Scenario는 의사결정 로직만
2. **재사용성**: 같은 Timetable을 여러 Scenario에서 참조 가능
3. **확장성**: 나중에 복잡한 조건(여러 강의 실패 조합) 추가 가능
4. **명확성**: 실패 조건(`failedCourseId`)이 명시적으로 저장됨

## Migration Path

현재 구현(Timetable만) → Scenario 추가:
1. Scenario 엔티티 추가
2. 기존 Timetable은 그대로 유지
3. Scenario가 Timetable을 참조
4. 기존 API는 deprecated하고 새 Scenario API 추가