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

tests/e2e/            # pytest E2E 테스트
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
- 인증 불필요: `/api/v1/auth/**`

## 작업 원칙

1. **백엔드 먼저** - Controller/DTO 확인 후 프론트엔드 작업
2. **품질 게이트** - 변경 전 테스트 통과 확인
3. **보안** - `.env`, 비밀번호, JWT 시크릿 커밋 금지
4. **문서 동기화** - 코드 변경 시 관련 문서 업데이트

## 주요 명령어

```bash
# 백엔드
cd app/backend && ./gradlew clean build
./gradlew :api-gateway:bootRun
./gradlew :planner-service:bootRun

# 프론트엔드
cd app/frontend && npm install && npm run dev

# E2E 테스트
cd tests/e2e && uv sync && uv run pytest -v

# Docker (백엔드)
docker compose up --build        # API: :8080
docker compose -f docker-compose.test.yml up  # 테스트용 (API: :8280)
```

## 상세 문서

- `docs/architecture.md` - API Gateway, 엔티티 설계
- `docs/features.md` - 기능별 사용자 시나리오
- `docs/guides.md` - 개발 가이드, 코딩 컨벤션
