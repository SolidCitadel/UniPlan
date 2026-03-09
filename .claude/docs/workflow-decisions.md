# 워크플로우 설계 결정

`.claude/` 파이프라인 설계 중 내린 결정과 그 근거를 누적하는 문서.
ECC 벤치마킹 결과가 아닌 UniPlan 고유 결정만 기록한다.

---

## 1. Double Loop TDD 채택 (Outside-In 방향)

**결정**: TDD는 High→Low (Outside-In) 방향으로 계획하고, Inner(Unit/Component)부터 실행한다.

**배경**:
- TDD 진영에는 두 학파가 있다 — Inside-Out(Chicago, Low→High)과 Outside-In(London, High→Low)
- 비즈니스 요구사항은 고수준 시나리오로 고정되어 있으므로, Outside-In이 개념적으로 더 정확하다
- 구현 전 Integration/E2E 수준의 "무엇이 통과해야 하는가"를 먼저 정의하면 구현 방향이 흔들리지 않는다

**구조 (Double Loop)**:
```
Outer RED (Integration/E2E 시나리오 정의) ─── planner가 계획
  └─ Inner RED → GREEN → REFACTOR (Unit/Component) ─── tdd-guide가 실행
  └─ Outer RED 코드화 (Integration/E2E 테스트 코드 작성) ─── tdd-guide가 실행
Outer GREEN (Integration/E2E 실행) ─── /test가 실행
```

**Inner/Outer 경계를 Unit/Component|Integration으로 끊은 이유**:
- Unit/Component는 `./gradlew test`로 인프라 없이 빠른 피드백 가능 (inner loop에 적합)
- Integration/E2E는 Docker·Playwright 필요 — 개발 루프에 포함하면 속도·안정성 저하
- tdd-guide는 Inner loop을 직접 실행하고, Outer는 코드 작성만 한 뒤 `/test`에 위임

---

## 2. Outer 실행을 `/test`에 위임 (별도 에이전트 미생성)

**결정**: Integration/E2E 테스트 실행 전담 에이전트를 만들지 않고 `/test` 커맨드가 담당한다.

**검토한 대안**:
- **별도 Outer 에이전트**: ECC의 `e2e-runner`와 유사. 하지만 tdd-guide가 방금 구현한 컨텍스트를 Outer 에이전트에게 전달하는 핸드오프 비용이 크다. Integration 실패 시 관련 컴포넌트를 열어봐야 하므로 오히려 뾰족한 컨텍스트가 유리하다.
- **`/tdd`를 Inner/Outer로 분리**: 같은 기능 구현의 연속인데 커맨드를 나누면 사용 부담이 증가한다.

**선택 이유**:
- tdd-guide는 Long-running 작업이라 컨텍스트가 이미 무겁다 — Outer 실행까지 포함하면 포화 위험
- `/test`는 이미 전체 검증 파이프라인(빌드→정적분석→Integration→E2E)을 담당하며, Integration/E2E 실패 시 독립적인 컨텍스트로 뾰족하게 디버깅하는 것이 더 효과적이다

---

## 3. qa-review를 Phase 4(검증)에 배치

**결정**: qa-review는 `/test` 이후 Phase 4에서 실행한다. Phase 2(TDD 구현) 중에는 사용하지 않는다.

**배경**:
- TDD는 계획된 시나리오에 대한 테스트를 작성하는 방법론이다
- qa-review는 "커버리지 갭이 있는가"를 분석하는 도구 — 갭이 있는지는 실행 결과 없이 알 수 없다
- `/test` 통과 후 커버리지 리포트가 생성된 상태에서야 의미 있는 갭 분석이 가능하다

**TDD와 qa-review의 역할 차이**:
- TDD: 계획된 케이스를 테스트로 먼저 작성 (설계 도구)
- qa-review: 작성된 테스트에서 빠진 케이스 식별 (검증 도구)
- Phase 4에서 Critical 갭 발견 시 → 테스트 추가 → `/test` 재실행 (이 루프는 TDD가 아닌 검증 루프)

---

## 4. code-review와 arch-review 분리

**결정**: 코드 품질+보안과 아키텍처 설계를 별도 커맨드·에이전트로 분리한다.

**이유**:
- 관점이 다르다: code-review는 구현 품질(N+1, @Valid, 하드코딩 등), arch-review는 설계 품질(SOLID, 추상화 레벨, 테스트 가능성)
- 페르소나가 다르다: code-reviewer는 시니어 개발자(코드 라인 판단), architecture-reviewer는 시니어 아키텍트(구조 판단)
- 함께 실행할 수 있으나, 분리하면 각각 Block/Critical 기준이 명확해지고 수정 범위도 명확해진다
