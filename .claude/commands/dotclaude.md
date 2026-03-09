---
description: .claude/ 폴더 수정 시 필요한 배경지식 로드. 구조 이해, 설계 원칙, 참조 문서 안내.
---

# /dotclaude — .claude/ 수정 가이드

`.claude/` 설정을 수정하기 전에 이 커맨드를 실행하세요.

## .claude/ 자동 주입 규칙

Claude Code가 **자동으로** 컨텍스트에 주입하는 파일:
- `CLAUDE.md` — 모든 에이전트·대화에 공통 적용
- `.claude/agents/*.md` — 에이전트 정의
- `.claude/skills/*/SKILL.md` — 스킬 컨텍스트 (모든 대화에 항상 주입)

**자동 주입되지 않는** 파일:
- `.claude/commands/*.md` — 슬래시 커맨드 호출 시에만 로드
- `.claude/docs/*` — 명시적으로 읽을 때만 로드

## 3-tier 구조 원칙

```
Command  (얇은 진입점)  → 라우팅 + agent/skill 참조만
Agent    (페르소나)     → 실행 책임, tools 접근
Skill    (순수 지식)    → 재사용 가능한 도메인 지식, 항상 auto-inject
```

설계 원칙:
- Command는 방법론을 직접 담지 않는다 — agent/skill로 위임
- Skill은 항상 로드되므로 **모든 에이전트에 공통 필요한 지식**만 담는다
- Agent는 페르소나 + 실행 절차. 특정 에이전트에만 필요한 지식은 여기에

## CLAUDE.md 원칙

모든 에이전트에 주입되므로 **진짜 공통 지식만** 포함:
- 프로젝트 구조 (파일 위치)
- API 경로·JWT 규칙 (모든 에이전트가 알아야 함)
- 명령어 실행 원칙 (cd 패턴, git 위치)
- 보안 (커밋 금지 목록)

포함하면 안 되는 것:
- 워크플로우 Phase 설명 → `commands/plan.md`
- 특정 에이전트 전용 규칙 → 해당 agent 파일
- 항상 필요하지 않은 참조 문서 링크

## 참조 문서

- `.claude/docs/architecture.md` — 현재 구조 + 3-tier 동작 원칙 (이 파일과 함께 읽기)
- `.claude/docs/ecc-analysis.md` — ECC 벤치마킹 분석 (3-tier 채택 근거, 역사적 기록)
- `.claude/docs/workflow-decisions.md` — 워크플로우 설계 결정 근거 (Double Loop TDD 등)

