# QA 분석 기준

qa-reviewer agent와 /qa-review command가 참조하는 커버리지 갭 분석 기준.

## 역할 경계

- **qa-reviewer**: "이 코드에서 어떤 케이스가 테스트되지 않았는가?" (커버리지 관점)
- **architecture-reviewer**: "이 코드가 테스트하기 쉬운 구조인가?" (설계 관점)

## UniPlan 테스트 구조

테스트 레벨 구조(Unit/Component/Contract/Integration/E2E 경로·프레임워크)와 소스→테스트 파일 매핑은 **springboot-tdd skill** 참조.

### Integration 테스트 도메인 매핑

| 변경 도메인 | Integration 테스트 파일 |
|------------|------------------------|
| user-service (인증) | `test_auth.py` |
| catalog-service (강의) | `test_courses.py` |
| planner-service (위시리스트) | `test_wishlist.py` |
| planner-service (시간표) | `test_timetable.py` |
| planner-service (시나리오) | `test_scenario.py` |
| planner-service (수강신청) | `test_registration.py` |

## 분석 기준

### 1. 경계값 (Boundary Value)

- `null` / `""` (empty string) / 빈 컬렉션 처리
- 최솟값/최댓값 (페이징 `size=0`, `Long.MAX_VALUE`, 음수 ID)
- 위시리스트 우선순위 1~5 범위 외 값

### 2. Sad Path (비정상 흐름)

- **인증/인가**: 비인증 요청, 타인 리소스 접근, 만료된 토큰
- **중복/충돌**: 동일 과목 중복 추가, 동시 요청 경쟁 조건
- **존재하지 않는 리소스**: 삭제된 ID 참조, 연관 엔티티 없음
- **상태 전이 위반**: 완료된 수강신청에 step 추가, 이미 취소된 세션 재취소

### 3. UniPlan 비즈니스 엣지 케이스

- 시간 충돌이 있는 강의를 시간표에 추가 시도
- 제외된 과목(`excludedCourses`)을 시간표에 다시 추가 시도
- 루트 시나리오 삭제 시 자식 시나리오 처리
- 수강신청 시뮬레이션: 모든 과목 실패 후 대안 없는 경우

### 4. E2E 커버리지 (프론트엔드 변경 시)

- 변경된 페이지/컴포넌트를 거치는 사용자 시나리오가 E2E로 커버되는가?
- 새 UI 흐름(버튼 추가, 페이지 이동 등)에 대한 spec이 없는가?
- `test:smoke`에 포함되어야 할 핵심 경로가 빠졌는가?

### 5. 테스트 격리성

- 테스트 간 공유 상태 (DB 롤백 없는 데이터 잔류)
- 실행 순서 의존성 (다른 테스트가 선행해야 동작)
- 외부 서비스 호출이 Mock되지 않은 경우

## 엄격한 검증 규칙 (Integration 테스트)

```python
# ✅ 단일 상태 코드 검증
assert response.status_code == 201
assert response.status_code == 409, "중복 리소스는 409 Conflict"

# ❌ 금지
assert response.status_code in (200, 400, 409)

# ✅ Test Skip 금지
assert items, "테스트를 위한 필수 데이터가 없습니다"

# ❌ 금지
if not items:
    pytest.skip("데이터 없음")
```

## 출력 형식

```
## 분석 대상
[변경된 파일 목록]

## 이미 커버된 케이스
- [기존 테스트에서 검증 중인 주요 케이스]

## 커버리지 갭

### Critical (반드시 추가)
1. [파일/메서드]: [누락된 케이스] → [추천 테스트 위치: unit/component/contract/integration/e2e]

### Major (강력 권장)
1. [파일/메서드]: [누락된 케이스] → [추천 테스트 위치]

### Minor (선택적)
1. [파일/메서드]: [누락된 케이스]

## 결론
[총 갭 수 요약, 우선순위 액션]
```
