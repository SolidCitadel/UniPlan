---
description: 아키텍처/기술 결정 후 ADR 작성 및 관련 문서 업데이트. adr-management skill의 템플릿·판단 기준 참조.
---

# /adr

References the adr-management skill.

## 사용 시점

- 아키텍처 패턴 결정 (MSA, DDD, CQRS 등)
- 기술 스택 선택 (DB, 메시징, 인증 방식 등)
- 중요한 설계 원칙 확립 또는 변경
- /plan Phase 5에서 아키텍처 결정이 있을 때 자동 호출

## 실행 절차

1. adr-management skill의 ADR 작성 여부 판단 기준 확인
2. `docs/adr/NNN-kebab-case-title.md` 파일 생성 (skill의 템플릿 사용)
3. `docs/README.md` ADR 인덱스 업데이트
4. `docs/architecture.md`에 결정 사항 반영 (해당 시)
5. `CLAUDE.md` 핵심 규칙 변경 시 반영

## 커맨드 흐름

/doc-sync → /adr → 커밋

## 관련 파일

- Skill (템플릿·판단 기준·절차): .claude/skills/adr-management/
