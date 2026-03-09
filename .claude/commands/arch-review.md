---
description: 스테이징된 변경사항의 아키텍처 적절성을 architecture-reviewer agent가 평가. SOLID·추상화·복잡도 기준.
---

# /arch-review

This command invokes the architecture-reviewer agent.
References the arch-review-criteria skill.

## 전제 조건

`git add` 완료 (staged 변경사항 기준으로 평가)

## 사용 시점

- 코드 변경 후 아키텍처 적절성 검토
- /plan Phase 4에서 /code-review 이후 자동 호출

## 커맨드 흐름

/test → /code-review → /arch-review → /qa-review

## 관련 파일

- Agent: .claude/agents/architecture-reviewer.md
- Skill (평가 기준): .claude/skills/arch-review-criteria/
