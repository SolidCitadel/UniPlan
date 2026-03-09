---
description: TDD 세션 실행. tdd-guide agent가 RED→GREEN→REFACTOR 사이클을 수행. 테스트 먼저 작성 강제.
---

# /tdd

This command invokes the tdd-guide agent to enforce test-driven development.
References the tdd-workflow skill and springboot-tdd skill.

## 사용 시점

- 새 기능 구현
- 버그 수정 (재현 테스트 먼저)
- /plan Phase 2에서 자동 호출

## 커맨드 흐름

/plan → /tdd → /frontend-sync (조건) → /test → /code-review

## 관련 파일

- Agent: .claude/agents/tdd-guide.md
- Skill (방법론): .claude/skills/tdd-workflow/
- Skill (Spring Boot 패턴): .claude/skills/springboot-tdd/
