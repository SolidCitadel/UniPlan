---
description: 코드 변경에 따른 문서 동기화. 변경 유형별 체크리스트로 누락 문서 방지. doc-sync-checklist skill 참조.
---

# /doc-sync

References the doc-sync-checklist skill.

## 사용 시점

- 모든 코드 변경 후 (필수)
- /plan Phase 5에서 자동 호출

## 실행 절차

1. 변경된 파일 목록 확인 (`git diff --cached --name-only` 또는 최근 커밋)
2. doc-sync-checklist skill의 변경 유형별 매핑 참조
3. 해당 문서 확인 및 업데이트:
   - API 변경 → `docs/architecture.md`
   - 새 기능 → `docs/features.md`, `docs/requirements.md`
   - 명령어/설정 변경 → `CLAUDE.md`, `README.md`
   - `.claude/` 수정 → `CLAUDE.md` 워크플로우 섹션
4. API Controller 변경 시 Swagger 애노테이션 확인

## 커맨드 흐름

/qa-review → /doc-sync → /adr (조건) → 커밋

## 관련 파일

- Skill (체크리스트): .claude/skills/doc-sync-checklist/
