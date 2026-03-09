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

docker/
docker-compose.yml          # base: 모든 환경 공통
docker-compose.override.yml # dev 전용 override (자동 적용)
docker-compose.test.yml     # test 전용 override
```

## 핵심 규칙

### API 경로
- 외부: `/api/v1/*` → Gateway가 `/api/v1` 제거 후 내부 서비스로 전달
- 예: 클라이언트 `/api/v1/timetables/1` → planner-service `/timetables/1`

### JWT 인증
- Gateway가 검증 후 `X-User-Id`, `X-User-Email` 헤더 추가
- 인증 불필요: `/api/v1/auth/**`, `/api/v1/universities/**`

## 명령어 실행 원칙

- `git` 명령은 프로젝트 루트에서 직접 실행 (`cd`나 `-C` 플래그 없이)
- 하위 디렉터리 명령: `cd subdir && command` (예: `cd app/backend && ./gradlew`)
- `.env`, 비밀번호, JWT 시크릿 커밋 금지

## 주요 명령어

```bash
cd app/backend && ./gradlew clean build
cd app/frontend && npm install && npm run dev
docker compose up --build                                            # 개발용
docker compose -f docker-compose.yml -f docker-compose.test.yml up  # 테스트용
```

## 상세 문서

- `docs/requirements.md` - 프로젝트 요구사항
- `docs/features.md` - 기능별 사용자 시나리오
- `docs/architecture.md` - API Gateway, 엔티티 설계
- `docs/guides/` - 개발 가이드 (Backend, Frontend, Testing, Deployment)
