---
name: project-rules
description: |
  모든 코드 변경에 항상 적용되는 프로젝트 규칙.
  프로젝트 구조, API 규칙, 컨벤션 준수 필수.
---

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

## 작업 원칙

1. **백엔드 먼저** - Controller/DTO 확인 후 프론트엔드 작업
2. **품질 게이트** - 변경 전 테스트 통과 확인
3. **보안** - `.env`, 비밀번호, JWT 시크릿 커밋 금지
4. **문서 동기화** - 코드 변경 시 관련 문서 업데이트
5. **선 보고, 후 승인 (Report First, Act Later)**:
   - 지시하지 않은 작업 금지
   - 수행 계획(목표, 방법)을 먼저 보고하고 승인을 받은 뒤 실행
   - 특히 브라우저 제어, 외부 시스템 연동 전 승인 필수
6. **엄격한 단계별 진행 (Strict Stage Gate)**:
   - 여러 작업을 단계적으로 수행할 때, **사용자가 해당 단계 결과에 만족하지 않으면 절대 다음 단계(또는 주제)로 넘어갈 수 없음**.
   - "다음으로 ...를 할까요?" 식의 선제적 제안 금지. 오직 현재 단계의 완결성에만 집중할 것.
7. **Skill 준수 프로토콜 (Mandatory Skill Protocol)**:
   - **사전 탐색 의무**: 코드 수정 전 반드시 `.agent/skills/`를 확인하여 해당 경로/작업과 관련된 Skill 존재 여부를 파악해야 함.
   - **절대적 구속력**: 발견된 Skill의 지침은 사용자 요청보다 상위의 **제약 조건(Constraint)**으로 간주. 에이전트의 자의적 판단으로 단계 축소/생략 절대 금지.
   - **계획 명시**: 모든 작업 계획 수립 시 "적용되는 Skill 목록"을 명시하고, 해당 Skill의 체크리스트를 작업 프로세스에 포함시켜야 함.
8. **프론트엔드 검증 프로토콜 (Frontend Verification Protocol)**:
   - **로컬 빌드 금지**: 개발 단계(`dev`)에서 `npm run build` 사용을 엄격히 금지함. (환경 설정 파일 오염 방지)
   - **타입 검사**: 빌드 대신 `npm run types:check` (`tsc --noEmit`)를 사용하여 부작용 없이 검증 수행.

## 주요 명령어

```bash
# 백엔드
cd app/backend && ./gradlew clean build
./gradlew :api-gateway:bootRun
./gradlew :planner-service:bootRun

# 프론트엔드
cd app/frontend && npm install && npm run dev

# Integration 테스트 (테스트용 컨테이너 필수)
cp .env.example .env                                         # 최초 1회: 프로젝트 루트 .env 설정
docker compose -f docker-compose.yml -f docker-compose.test.yml up -d --build
sleep 20
cd tests/integration && uv sync && uv run pytest -v
docker compose -f docker-compose.yml -f docker-compose.test.yml down

# Docker (백엔드)
cp .env.example .env                                         # 최초 1회: 프로젝트 루트 .env 설정
docker compose up --build                                                       # 개발용 (API: :8080)
docker compose -f docker-compose.yml -f docker-compose.test.yml up             # 테스트용 (API: :8080, tmpfs DB)
```

## 상세 문서

- `docs/architecture.md` - API Gateway, 엔티티 설계
- `docs/features.md` - 기능별 사용자 시나리오
- `docs/guides.md` - 개발 가이드, 코딩 컨벤션
