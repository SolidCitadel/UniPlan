# UniPlan Project Guide

수강신청 계획 웹 애플리케이션. Spring Boot MSA + Next.js.

## 프로젝트 구조

```
app/backend/          # Spring Boot MSA (Java 21)
  ├── api-gateway/    # :8080 - JWT 인증, 라우팅
  ├── user-service/   # :8081 - 사용자 인증
  ├── catalog-service/# :8083 - 강의 검색
  └── planner-service/# :8082 - 시간표, 시나리오, 수강신청

app/frontend/         # Next.js (TypeScript)
  └── React Query + shadcn/ui + Tailwind

tests/integration/      # pytest Integration 테스트
tests/e2e/            # Playwright E2E 테스트
scripts/              # 크롤러/유틸리티 (Python, uv)
```

## 핵심 규칙

### API 경로
- 외부: `/api/v1/*` → Gateway가 `/api/v1` 제거 후 내부 서비스로 전달
- 예: 클라이언트 `/api/v1/timetables/1` → planner-service `/timetables/1`

### API 계약 (중요)
- **요청**: `excludedCourseIds` (Long 배열)
- **응답**: `excludedCourses` (courseId 포함 객체 배열)

### JWT 인증
- 헤더: `Authorization: Bearer {token}`
- Gateway가 검증 후 `X-User-Id`, `X-User-Email` 헤더 추가
- 인증 불필요: `/api/v1/auth/**`, `/api/v1/universities/**`

### 멀티 대학 지원
- 회원가입 시 대학 선택 필수 (`universityId`)
- 강의 검색 시 대학 + 학기로 필터링
- 프론트엔드 학기 선택은 localStorage에 저장

## 구현 워크플로우

요구사항을 받으면 아래 순서대로 진행. 각 단계는 이전 단계 완료 후 수행.

### Phase 1: 구현
1. 요구사항 분석 및 영향 범위 파악
2. 백엔드 먼저 (Controller/DTO → Service → Entity/Repository)
3. 프론트엔드 (API 타입 → 컴포넌트)
4. 변경 전 기존 테스트 통과 확인 (`./gradlew test`)

### Phase 2: 변경 영향 파악 & 보완
변경된 파일을 기반으로 해당하는 Skills를 **순서대로** 적용:

| 조건 | Skill | 필수 여부 |
|------|-------|-----------|
| `app/backend/` 변경 | `backend-test-guard` | 필수 |
| DTO/에러 응답 변경 | `frontend-sync` | 필수 |
| 모든 코드 변경 | `doc-sync` | 필수 |
| 아키텍처/기술 결정 | `adr-management` | 해당 시 |

### Phase 3: 최종 검증
1. `./gradlew test` 전체 통과
2. `npm run build` 성공 (프론트엔드 변경 시)
3. `/arch-review`로 아키텍처 리뷰

### Phase 4: 커밋
Phase 1~3 완료 후에만 커밋 수행.

### 보안
- `.env`, 비밀번호, JWT 시크릿 커밋 금지

### 환경변수 원칙 (ADR-005)
- **기본값 금지**: `${VAR:default}` 또는 `?? 'default'` 패턴 사용 금지
- **즉시 실패**: 누락된 환경변수는 명확한 에러와 함께 즉시 실패해야 함
- **예외**: `application-local.yml`에서는 값을 직접 하드코딩 허용
- **온보딩**: 각 모듈 디렉터리의 `.env.example`을 `.env`로 복사하는 것이 필수 절차

## 주요 명령어

```bash
# 백엔드
cd app/backend && ./gradlew clean build
./gradlew :api-gateway:bootRun
./gradlew :planner-service:bootRun

# 프론트엔드
cd app/frontend && npm install && npm run dev

# Integration 테스트 (테스트용 컨테이너 필수)
docker compose -f docker-compose.test.yml up -d --build
sleep 30
cp tests/integration/.env.example tests/integration/.env   # 최초 1회
cd tests/integration && uv sync && uv run pytest -v
docker compose -f docker-compose.test.yml down

# E2E 테스트 (백엔드 컨테이너 기동 후)
cd tests/e2e && npm run test:smoke             # smoke만 빠르게
cd tests/e2e && npm test                       # 전체
cd tests/e2e && npm run test:ui                # 대화형 디버깅

# Docker (백엔드)
docker compose up --build                      # 개발용 (API: :8080)
docker compose -f docker-compose.test.yml up   # 테스트용 (API: :8080, tmpfs DB)
docker compose -f docker-compose.yml -f docker-compose.observability.yml up --build  # Observability 포함 (Prometheus: :9090, Grafana: :3001)
```

## 상세 문서

- `docs/requirements.md` - 프로젝트 요구사항
- `docs/features.md` - 기능별 사용자 시나리오
- `docs/architecture.md` - API Gateway, 엔티티 설계
- `docs/guides/` - 개발 가이드 (Backend, Frontend, Testing, Deployment)
