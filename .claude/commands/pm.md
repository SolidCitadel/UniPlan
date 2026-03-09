---
description: 기능 구현 전 UX/기획 관점 상담. product-manager agent가 기술 편향 없이 사용성·비즈니스 가치 평가.
---

# /pm

This command invokes the product-manager agent.
References the pm-evaluation-criteria skill.

## 사용 시점

- 새 기능 구현 전 UX/요구사항 방향이 불명확할 때
- /plan Phase 0에서 선택적으로 호출
- **Phase 1 진입 전에만 의미 있음** (구현 후 방향 수정 비용 최소화)

## 커맨드 흐름

/pm → /plan → /tdd

## 관련 파일

- Agent: .claude/agents/product-manager.md
- Skill (평가 기준): .claude/skills/pm-evaluation-criteria/
