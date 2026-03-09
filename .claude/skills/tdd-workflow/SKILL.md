# TDD 워크플로우

tdd-guide agent와 /tdd command가 참조하는 RED→GREEN→REFACTOR 방법론.

## 핵심 원칙

**테스트는 사양(specification)이다.** 구현 전 테스트를 작성하면:
- 설계를 명확히 강제
- 회귀 방지 보장
- 리팩터링 자신감 제공
- 커버리지 목표가 자연스럽게 달성됨

## 7단계 TDD 프로세스

```
1. User Journey    → 기능의 사용자 여정 정의
2. Test Generation → 테스트 케이스 목록 작성 (Happy Path → Edge → Error)
3. Run → Fail      → 테스트 실행, 컴파일 에러 또는 assertion 실패 확인 (RED)
4. Implement       → 테스트를 통과시키는 최소한의 코드 작성
5. Run → Pass      → 모든 새 테스트 통과 확인 (GREEN)
6. Refactor        → 중복 제거, 네이밍 개선 (테스트 재실행으로 검증)
7. Coverage        → 80%+ 확인, 누락 케이스 보완
```

## AAA 패턴 (모든 테스트에 적용)

```java
// Arrange - 테스트 데이터와 의존성 설정
// Act     - 테스트 대상 메서드 실행
// Assert  - 결과 검증
```

## 커버리지 기준

| 대상 | 기준 | 측정 |
|------|------|------|
| 전체 | 80%+ | JaCoCo line coverage |
| 핵심 비즈니스 로직 | 100% | 시간표 충돌, 수강신청 시뮬레이션 |
| 프론트엔드 (현재) | E2E 커버 | Playwright (Jest/RTL 미구성) |

## UniPlan 도메인 예시

### 시간표 충돌 검증 (Unit)

```java
@Test
void 시간_충돌하는_강의_추가_시_예외_발생() {
    // Arrange
    Timetable timetable = createTimetableWithCourse(MON, "09:00", "11:00");
    Course conflictingCourse = createCourse(MON, "10:00", "12:00");

    // Act & Assert
    assertThatThrownBy(() -> timetable.addCourse(conflictingCourse))
        .isInstanceOf(TimeConflictException.class)
        .hasMessageContaining("시간 충돌");
}
```

### 수강신청 시뮬레이션 (Component)

```java
@Test
void 수강신청_시뮬레이션_전체_실패_시_대안없음_반환() {
    // Arrange: 모든 과목이 마감된 시나리오
    // Act: 시뮬레이션 실행
    // Assert: 빈 결과 또는 적절한 상태 반환
}
```

## RED 상태 판정 기준

| 결과 | 판정 | 다음 액션 |
|------|------|---------|
| 컴파일 에러 | ✅ RED | GREEN Phase 진행 |
| Assertion 실패 | ✅ RED | GREEN Phase 진행 |
| 모든 테스트 통과 | ❌ 너무 약함 | 테스트 강화 후 재실행 |

## 안티패턴 (금지)

- **구현 세부사항 테스트**: `verify(repo, times(1)).save(any())` — 동작이 아닌 상호작용 검증
- **공유 상태**: `@BeforeClass static List` 등 테스트 간 공유 데이터
- **순서 의존성**: 테스트 A가 성공해야 테스트 B가 동작하는 구조
- **과도한 Mock**: 비즈니스 로직까지 모킹하여 실제 동작 미검증
- **테스트 내 로직**: if/for 문이 있는 테스트 — 두 개의 테스트로 분리

## REFACTOR 체크리스트

- [ ] 중복 코드 제거 (Extract Method)
- [ ] 매직 넘버 상수화
- [ ] 긴 메서드 분리 (50줄 초과 시)
- [ ] 테스트 데이터 빌더 패턴 적용 (반복 사용 시)
- [ ] 모든 테스트 재실행 통과 확인
