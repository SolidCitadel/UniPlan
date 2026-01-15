---
name: doc-sync
description: |
  API/구조 변경 시 반드시 사용.
  docs/ 문서, CLAUDE.md, Swagger 애노테이션이 코드와 일치하는지 확인.
  Controller, DTO, Entity 구조 변경 후 이 skill을 자동 적용.
---

# 문서 동기화 워크플로우

코드가 변경되었습니다. 관련 문서를 업데이트해야 합니다.

## 1. 변경 유형별 문서 매핑

| 변경 유형 | 업데이트 대상 문서 |
|----------|-------------------|
| API 엔드포인트 추가/삭제 | `docs/architecture.md` (라우팅 테이블) |
| API 경로 변경 | `docs/architecture.md`, CLAUDE.md |
| DTO 구조 변경 | `docs/architecture.md` (API 계약) |
| Entity 구조 변경 | `docs/architecture.md` (Entity Design) |
| 인증 흐름 변경 | `docs/architecture.md` (JWT 인증 흐름) |
| 테스트 전략 변경 | `docs/guides.md` |
| 코딩 컨벤션 변경 | `docs/guides.md` |
| 주요 명령어 변경 | CLAUDE.md |
| Docker 설정 변경 | CLAUDE.md, docker-compose.yml 주석 |

## 2. 문서별 체크리스트

### CLAUDE.md

- [ ] 프로젝트 구조 정확한지
- [ ] API 경로 규칙 정확한지
- [ ] API 계약 (excludedCourseIds/excludedCourses) 정확한지
- [ ] 주요 명령어 정확한지

### docs/architecture.md

- [ ] 서비스별 라우팅 테이블 정확한지
- [ ] Swagger URL 정확한지
- [ ] Entity 구조 (필드, 관계) 정확한지
- [ ] API 계약 예시 정확한지

### docs/guides.md

- [ ] 테스트 전략/명령어 정확한지
- [ ] 품질 게이트 명령어 정확한지
- [ ] 코딩 컨벤션 정확한지

### docs/features.md

- [ ] 사용자 시나리오가 현재 구현과 일치하는지

## 3. Swagger 애노테이션 확인

API 변경 시 Controller의 Swagger 애노테이션 업데이트:

```java
@Operation(summary = "...", description = "...")
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "..."),
    @ApiResponse(responseCode = "400", description = "...")
})
```

### 확인 항목

- [ ] `@Operation` summary/description 정확한지
- [ ] `@ApiResponse` 응답 코드별 설명 정확한지
- [ ] `@Schema` DTO 필드 설명 정확한지

## 4. 문서 수정

변경된 코드에 맞게 문서 업데이트.

### 주의사항

- 코드와 문서의 예시가 일치해야 함
- API 경로, 요청/응답 구조가 실제와 동일해야 함
- 명령어는 실제 동작하는 것으로 기재

## 5. 검증

수정된 문서 내용이 실제 코드와 일치하는지 확인.

## 완료 조건

- [ ] 변경과 관련된 모든 문서 확인
- [ ] 필요한 문서 수정 완료
- [ ] Swagger 애노테이션 업데이트 완료 (API 변경 시)
- [ ] 문서 예시와 실제 코드 일치 확인
- [ ] **이 조건 충족 전까지 변경 작업 미완료로 간주**

## 문서 위치 참고

```
UniPlan/
├── .claude/
│   └── CLAUDE.md          # 프로젝트 가이드 (핵심 규칙)
├── docs/
│   ├── architecture.md    # 아키텍처, API, Entity
│   ├── guides.md          # 개발 가이드, 테스트, 컨벤션
│   ├── features.md        # 기능별 사용자 시나리오
│   └── requirements.md    # 요구사항
└── app/backend/**/
    └── *Controller.java   # Swagger 애노테이션
```