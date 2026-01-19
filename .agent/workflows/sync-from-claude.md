---
description: .claude 폴더를 분석하여 .agent 폴더를 최신화
---

# .claude → .agent 동기화

## 매핑 테이블

| .claude 소스 | .agent 대상 | 변환 |
|-------------|-------------|------|
| `CLAUDE.md` | `skills/project-rules/SKILL.md` | YAML frontmatter 추가 |
| `skills/backend-test-guard/SKILL.md` | `skills/backend-test-guard/SKILL.md` | 그대로 복사 |
| `skills/doc-sync/SKILL.md` | `skills/doc-sync/SKILL.md` | 그대로 복사 |
| `skills/frontend-sync/SKILL.md` | `skills/frontend-sync/SKILL.md` | 그대로 복사 |
| `agents/architecture-reviewer.md` | `workflows/arch-review.md` | 워크플로우 형식 변환 |

## 실행 단계

1. `.claude/CLAUDE.md` 읽고 `.agent/skills/project-rules/SKILL.md` 업데이트
   - 상단에 YAML frontmatter 추가:
     ```yaml
     ---
     name: project-rules
     description: |
       모든 코드 변경에 항상 적용되는 프로젝트 규칙.
       프로젝트 구조, API 규칙, 컨벤션 준수 필수.
     ---
     ```
   - 나머지 내용은 CLAUDE.md 그대로

2. `.claude/skills/` 폴더의 각 SKILL.md를 `.agent/skills/`로 복사
   - backend-test-guard
   - doc-sync
   - frontend-sync

3. `.claude/agents/architecture-reviewer.md` 내용을 `.agent/workflows/arch-review.md`로 변환

4. 변경된 파일 목록 출력

## 복사 제외

- `settings.local.json` - Antigravity 권한 시스템과 호환 안됨
