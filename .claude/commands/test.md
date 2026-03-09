---
description: 변경 영향 범위에 따라 빌드→정적분석→테스트→보안→Integration→E2E 검증 수행. verification-loop skill 참조.
---

# /test

References the verification-loop skill.

## 사용 시점

- /plan Phase 3에서 자동 호출
- TDD GREEN 이후 전체 검증 필요 시
- /code-review · /arch-review · /qa-review 후 수정이 있을 때 재실행

## 검증 흐름 (verification-loop skill 참조)

변경 영역에 따라 실행 범위 결정:

| 변경 영역 | 실행 범위 |
|-----------|-----------|
| `app/backend/` | Phase 1~5 (빌드·정적분석·테스트·보안·Integration) |
| `app/frontend/` 페이지/컴포넌트 | Phase 1 + 빌드 + Phase 6 (E2E) |
| `app/frontend/` 스타일/설정 | 프론트엔드 빌드만 |

## 커맨드 흐름

/tdd → /test → /code-review → /arch-review → /qa-review

## 관련 파일

- Skill (검증 절차): .claude/skills/verification-loop/
