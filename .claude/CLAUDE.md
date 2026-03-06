# UniPlan Project Guide

수강신청 계획 웹 애플리케이션. Spring Boot MSA + Next.js.

## 프로젝트 구조

```
app/backend/          # Spring Boot MSA (Java 21)
  ├── api-gateway/    # :8080 - JWT 인증, 라우팅
  ├── user-service/   # :8081 - 사용자 인증
  ├── catalog-service/# :8083 - 강의 검색
  └── planner-service/# :8082 - 시간표, 시나리오, 수강신청

app/frontend/         # Next.js (TypeScript) · React Query + shadcn/ui + Tailwind

tests/
  ├── integration/    # pytest Integration 테스트 (애플리케이션 로직 검증)
  ├── infra/          # pytest Infra 테스트 (Observability 도구 동작 검증)
  └── e2e/            # Playwright E2E 테스트
scripts/              # 크롤러/유틸리티 (Python, uv)

docker/                     # Dockerfile 및 Observability 설정 (Grafana, Prometheus, Tempo, Loki, Promtail)
docker-compose.yml          # base: 모든 환경 공통 설정
docker-compose.override.yml # dev 전용: named volumes, 포트 노출 (docker compose up 시 자동 적용)
docker-compose.test.yml     # test 전용 override: tmpfs, JWT secret (base와 함께 사용)
```

## 핵심 규칙

### API 경로
- 외부: `/api/v1/*` → Gateway가 `/api/v1` 제거 후 내부 서비스로 전달
- 예: 클라이언트 `/api/v1/timetables/1` → planner-service `/timetables/1`

### JWT 인증
- 헤더: `Authorization: Bearer {token}`
- Gateway가 검증 후 `X-User-Id`, `X-User-Email` 헤더 추가
- 인증 불필요: `/api/v1/auth/**`, `/api/v1/universities/**`


## 구현 워크플로우

요구사항을 받으면 아래 순서대로 진행. 각 단계는 이전 단계 완료 후 수행.

### Phase 0: 기획 검토 (선택적)
새 기능 구현 전, UX/요구사항 방향이 불명확할 때 수동 호출:
- `/pm`으로 PM 관점 사전 상담 (사용성, 일관성, 빠진 요구사항)
- Phase 1 진입 전에만 의미 있음 (구현 후 방향 수정 비용 최소화)

### Phase 1: 구현
1. 요구사항 분석 및 영향 범위 파악
2. 백엔드 먼저 (Controller/DTO → Service → Entity/Repository)
3. 프론트엔드 (API 타입 → 컴포넌트)
4. DTO/에러 응답 변경 시 `frontend-sync`

### Phase 2: 테스트
- `test-guard` 실행

### Phase 3: 검증
1. 변경 파일 `git add` (이후 검증은 staged 기준으로 동작)
2. `/arch-review`로 아키텍처 리뷰 (설계 품질)
3. `/qa-review`로 커버리지 갭 확인 → 갭 발견 시 테스트 추가 후 통과 확인

### Phase 4: 문서화
- 모든 코드 변경 시: `doc-sync`
- 아키텍처/기술 결정 시: `adr-management`

### Phase 5: 커밋
Phase 1~4 완료 후에만 커밋 수행.

### 명령어 실행 원칙
- 작업 디렉터리는 항상 프로젝트 루트. `git` 명령은 `cd`나 `-C` 없이 직접 실행
- 하위 디렉터리 명령은 `cd subdir && command` 형태 사용 (예: `cd app/backend && ./gradlew`)

### 보안
- `.env`, 비밀번호, JWT 시크릿 커밋 금지

### 환경변수 원칙 (ADR-005)
- **기본값 금지**: `${VAR:default}` 또는 `?? 'default'` 패턴 사용 금지
- **즉시 실패**: 누락된 환경변수는 명확한 에러와 함께 즉시 실패해야 함 (Docker Compose: `${VAR:?error}`)
- **예외**: `application-local.yml`에서는 값을 직접 하드코딩 허용
- **값의 출처**: Docker Compose 환경변수 값은 `.env` 파일에서만 관리. compose 파일은 `${VAR:?error}` 참조만 포함
- **온보딩**: 프로젝트 루트 `cp .env.example .env` 후 docker compose 실행

## 주요 명령어

```bash
# 백엔드
cd app/backend && ./gradlew clean build
cd app/backend && ./gradlew :api-gateway:bootRun
cd app/backend && ./gradlew :planner-service:bootRun

# 프론트엔드
cd app/frontend && npm install && npm run dev

# Docker (백엔드)
docker compose up --build                                    # 개발용 (API: :8080)
docker compose --profile observability up --build            # 개발 + Observability (Grafana: :3001, Prometheus: :9090, Loki: :3100, Tempo: :3200)
docker compose -f docker-compose.yml -f docker-compose.test.yml up                              # 테스트용 (API: :8080, tmpfs DB)
docker compose -f docker-compose.yml -f docker-compose.test.yml --profile observability up      # 테스트 + Observability (Infra 테스트용)
```

## 상세 문서

- `docs/requirements.md` - 프로젝트 요구사항
- `docs/features.md` - 기능별 사용자 시나리오
- `docs/architecture.md` - API Gateway, 엔티티 설계
- `docs/guides/` - 개발 가이드 (Backend, Frontend, Testing, Deployment)
