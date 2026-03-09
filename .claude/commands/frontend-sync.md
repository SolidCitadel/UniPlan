---
description: 백엔드 DTO/에러 응답 변경 후 프론트엔드 타입 동기화. frontend-sync-mapping skill의 매핑 테이블·에러 패턴 참조.
---

# /frontend-sync

References the frontend-sync-mapping skill.

## 사용 시점

- 백엔드 DTO (`*Request.java`, `*Response.java`) 변경 후
- 에러 응답 구조(`GlobalExceptionHandler`) 변경 후
- /plan Phase 2에서 DTO 변경 발생 시 자동 호출

## 실행 절차

1. 변경된 백엔드 DTO 파일 식별
2. frontend-sync-mapping skill의 Java↔TypeScript 타입 매핑 참조
3. `app/frontend/src/types/index.ts` 불일치 필드 수정
4. 관련 API 클라이언트 (`src/lib/api/*.ts`) 및 컴포넌트 확인
5. 에러 처리 패턴 검증 (frontend-sync-mapping skill 참조)
6. `cd app/frontend && npm run build` 성공 확인

## 커맨드 흐름

/tdd (DTO 변경 발생) → /frontend-sync → /test

## 관련 파일

- Skill (매핑 테이블·에러 패턴): .claude/skills/frontend-sync-mapping/
