---
description: 기능 요구사항을 받아 Phase 0~6 전체를 순서대로 오케스트레이션. planner agent + tdd-guide agent + 검증 커맨드 자동 호출.
---

# /plan - UniPlan 워크플로우 오케스트레이터

사용자 입력: $ARGUMENTS

이 커맨드는 planner agent, tdd-guide agent, 그리고 /code-review, /arch-review, /qa-review,
/test, /doc-sync 커맨드를 순서대로 호출하여 전체 개발 워크플로우를 실행합니다.

## Phase 0: 기획 검토 (선택적)

요구사항이 불명확하거나 사용자가 요청 시 → `/pm` 호출

## Phase 1: 계획 수립

→ **planner agent** 호출 (TDD-aware 구현 계획 수립)
→ 계획 요약 후 **사용자 승인 대기** (승인 없이 Phase 2 진입 금지)

## Phase 2: TDD 구현

→ `/tdd` 호출 (tdd-guide agent + tdd-workflow skill + springboot-tdd skill)
  - 2-A Inner RED: Unit/Component 테스트 먼저 작성 + 실패 확인
  - 2-B Inner GREEN: 최소 구현 + 테스트 통과 확인
  - 2-C REFACTOR: 코드 정리 (기능 변경 없음)
  - 2-D Outer RED 코드화: Integration/E2E 시나리오 → 테스트 코드 작성 (실행은 Phase 3)
→ DTO/에러 응답 변경 발생 시: `/frontend-sync` 호출

## Phase 3: 테스트

→ `/test` 호출 (verification-loop skill — 빌드→정적분석→테스트→보안→Integration→E2E)

## Phase 4: 검증

→ `git add` (staged 기준으로 검증)
→ `/code-review` 호출 → **Block(CRITICAL) 발견 시 수정 필수 → Phase 3 재실행**
→ `/arch-review` 호출 → Critical 시 수정 후 Phase 3 재실행
→ `/qa-review` 호출 → Critical 갭 시 테스트 추가 후 Phase 3 재실행

## Phase 5: 문서화

→ `/doc-sync` 호출
→ 아키텍처/기술 결정 시: `/adr` 호출

## Phase 6: 커밋

모든 Phase 완료 후 커밋 수행.

## 핸드오프 형식 (각 Phase 완료 시 인라인 출력)

```
### Phase N 핸드오프
- 수행 내용: [한 줄]
- 수정 파일: [목록]
- 테스트 상태: RED / GREEN / 통과 / 실패
- 발견 문제: [있으면 기술]
- 다음 Phase 참고사항: [권고]
```

## 원칙

- Phase 완료 조건 미충족 시 해당 Phase 반복
- 사용자 승인(Phase 1 이후) 없이 Phase 2 진입 금지
- 각 호출 전 "→ [이름] 호출 중..." 출력

## 커맨드 흐름

/pm (선택) → /plan → /tdd → /frontend-sync (조건) → /test → /code-review → /arch-review → /qa-review → /doc-sync → /adr (조건)

## 관련 파일

- Agent (계획): .claude/agents/planner.md
- Agent (TDD): .claude/agents/tdd-guide.md
- Command (TDD): .claude/commands/tdd.md
- Command (테스트): .claude/commands/test.md
