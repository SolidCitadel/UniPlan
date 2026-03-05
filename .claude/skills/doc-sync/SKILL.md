---
name: doc-sync
description: |
  모든 코드 변경 시 반드시 사용.
  어떤 변경이든 관련 문서가 있는지 점검하고 최신화 필수.
  docs/, CLAUDE.md, Swagger 애노테이션이 코드와 일치하는지 확인.
---

# 문서 동기화 워크플로우

코드가 변경되었습니다. 관련 문서를 업데이트해야 합니다.

## 1. 변경 유형별 문서 매핑

| 변경 유형 | 업데이트 대상 문서 |
|----------|-------------------|
| API 엔드포인트 추가/삭제 | `docs/architecture.md` (라우팅 테이블) |
| API 경로 변경 | `docs/architecture.md`, `CLAUDE.md` |
| DTO 구조 변경 | `docs/architecture.md` (API 계약) |
| Entity 구조 변경 | `docs/architecture.md` (Entity Design) |
| 인증 흐름 변경 | `docs/architecture.md` (JWT 인증 흐름) |
| 테스트 전략 변경 | `docs/guides/testing.md` |
| 코딩 컨벤션 변경 | `docs/guides/backend.md`, `docs/guides/frontend.md` |
| 새 기능/UI 추가 | `docs/features.md`, `docs/requirements.md` |
| 주요 명령어 변경 | `CLAUDE.md`, `README.md` |
| Docker 설정 변경 | `CLAUDE.md`, `README.md`, docker-compose 주석 |
| 새 서비스/모듈 추가 | `README.md` (디렉터리 구조, 기술 스택) |
| 새 테스트 레이어 추가 | `README.md` (테스트 섹션) |
| `.claude/` 수정 | 아래 `.claude/ 수정 원칙` 참고 |

## 2. 문서별 체크리스트

### README.md

- [ ] 기술 스택 (버전, 도구) 정확한지
- [ ] 디렉터리 구조가 실제 구조와 일치하는지
- [ ] 빠른 시작 명령어 정확한지 (포트, 경로 포함)
- [ ] 테스트 섹션에 모든 테스트 레이어(단위/Integration/Infra/E2E) 포함되어 있는지
- [ ] 문서 링크 유효한지

### CLAUDE.md

- [ ] 프로젝트 구조 정확한지
- [ ] API 경로 규칙 정확한지
- [ ] 주요 명령어 정확한지 (백엔드 빌드/실행, 프론트엔드 dev, Docker)

### docs/architecture.md

- [ ] 서비스별 라우팅 테이블 정확한지
- [ ] Swagger URL 정확한지
- [ ] Entity 구조 (필드, 관계) 정확한지
- [ ] API 설계 원칙 예시 정확한지

### docs/features.md

- [ ] 사용자 시나리오가 현재 구현과 일치하는지
- [ ] API 명세 정확한지
- [ ] 제약사항 정확한지

### docs/requirements.md

- [ ] 구현 완료/미구현 상태 정확한지

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

## 4. `.claude/` 수정 원칙

`.claude/` 폴더를 수정할 때 아래 기준으로 배치한다.

| 배치 위치 | 기준 |
|----------|------|
| `CLAUDE.md` | 서브에이전트 포함 **모든 상황**에서 항상 필요한 배경지식과 컨벤션. 최소한으로 유지 |
| `skills/` | **특정 상황**에서만 필요한 지식과 워크플로우 |
| `agents/` | 맥락을 완전히 초기화하고 **새로운 페르소나**로 평가해야 하는 경우 |
| `docs/` | 작업 중 실시간 참조가 아닌 **사후 참조** 문서 |

### 판단 기준 예시

- "API 경로 규칙" → 어떤 코드를 짜든 항상 알아야 함 → **CLAUDE.md**
- "테스트 실행 방법" → 테스트 단계에서만 필요 → **skills/test-guard**
- "아키텍처 리뷰 기준" → 리뷰 시에만 필요하고, 완전히 독립적 시각 필요 → **agents/**
- "멀티 대학 지원 도메인 지식" → 구현 시 코드 보면 파악 가능, 상시 필요 없음 → **docs/**

## 5. 문서 수정

변경된 코드에 맞게 문서 업데이트.

### 주의사항

- 코드와 문서의 예시가 일치해야 함
- API 경로, 요청/응답 구조가 실제와 동일해야 함
- 명령어는 실제 동작하는 것으로 기재

## 완료 조건

- [ ] 변경과 관련된 모든 문서 확인
- [ ] 필요한 문서 수정 완료
- [ ] Swagger 애노테이션 업데이트 완료 (API 변경 시)
- [ ] 문서 예시와 실제 코드 일치 확인
- [ ] **이 조건 충족 전까지 변경 작업 미완료로 간주**

## 문서 위치 참고

```
UniPlan/
├── README.md                  # 프로젝트 소개, 빠른 시작, 디렉터리 구조
├── .claude/
│   ├── CLAUDE.md              # 프로젝트 가이드 (공통 배경지식, 최소화)
│   ├── skills/                # 상황별 워크플로우
│   └── agents/                # 독립 페르소나 에이전트
├── docs/
│   ├── architecture.md        # 아키텍처, API, Entity
│   ├── guides/                # 개발 가이드, 테스트, 컨벤션
│   ├── features.md            # 기능별 사용자 시나리오
│   ├── requirements.md        # 요구사항
│   └── adr/                   # Architecture Decision Records
└── app/backend/**/
    └── *Controller.java       # Swagger 애노테이션
```
