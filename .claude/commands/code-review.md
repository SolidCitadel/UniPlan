---
description: 코드 품질과 보안을 code-reviewer agent가 검토. Approve/Warning/Block 판정 출력.
---

# /code-review

This command invokes the code-reviewer agent.
References the code-review-criteria skill, java-coding-standards skill, security-review skill.

## 전제 조건

`git add` 완료 (staged 변경사항 기준으로 검토)

## 사용 시점

- /plan Phase 4에서 /arch-review 이전에 자동 호출
- 독립적으로 코드 품질/보안 검토 필요 시

## 커맨드 흐름

/test → /code-review → /arch-review → /qa-review

## 관련 파일

- Agent: .claude/agents/code-reviewer.md
- Skill (판정 기준): .claude/skills/code-review-criteria/
- Skill (Java 기준): .claude/skills/java-coding-standards/
- Skill (보안): .claude/skills/security-review/
