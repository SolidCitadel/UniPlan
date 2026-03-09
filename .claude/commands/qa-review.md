---
description: 스테이징된 변경사항의 테스트 커버리지 갭을 qa-reviewer agent가 식별. Critical 갭은 테스트 추가 필수.
---

# /qa-review

This command invokes the qa-reviewer agent.
References the qa-analysis-criteria skill.

## 전제 조건

`git add` 완료 (staged 변경사항 기준으로 분석)

## 사용 시점

- 코드 변경 후 커버리지 갭 확인
- /plan Phase 4에서 /arch-review 이후 자동 호출

## Critical 갭 발견 시

테스트 추가 → `/test` 재실행 후 통과 확인

## 커맨드 흐름

/test → /code-review → /arch-review → /qa-review

## 관련 파일

- Agent: .claude/agents/qa-reviewer.md
- Skill (분석 기준): .claude/skills/qa-analysis-criteria/
