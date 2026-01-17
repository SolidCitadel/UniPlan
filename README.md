# UniPlan

시나리오 기반 대학 수강신청 계획 및 실시간 네비게이션 서비스입니다.

## 프로젝트 소개

UniPlan은 대학 수강신청의 불확실성을 해결하기 위한 웹 애플리케이션입니다. 사용자는 Plan A/B/C 형태로 여러 시나리오를 미리 준비하고, 실제 수강신청 시점에는 과목 실패 상황에 따라 자동으로 다음 대안을 제시받습니다.

### 주요 기능

1. **강의 검색 및 위시리스트**
   - 과목명, 교수명, 학과, 캠퍼스별 검색
   - 우선순위(1~5) 기반 위시리스트 관리

2. **시간표 계획**
   - 여러 시간표 생성 및 관리
   - 시간 충돌 자동 감지
   - 대안 시간표 생성 (특정 과목 제외)

3. **시나리오 트리**
   - 의사결정 트리 구조로 대안 시나리오 관리
   - "과목 A 실패 시 Plan B로 이동" 형태의 계획
   - 여러 과목 동시 실패 조합 지원

4. **수강신청 시뮬레이션**
   - 실시간 성공/실패 기록
   - 자동 시나리오 네비게이션
   - 상태별 시각화 (성공/대기/실패/취소)

## 기술 스택

### 백엔드 (MSA)
- **프레임워크**: Spring Boot 3.x (Java 21)
- **빌드**: Gradle (Kotlin DSL)
- **데이터베이스**: MySQL (Production), H2 (Development)
- **인증**: JWT
- **문서화**: Swagger/OpenAPI

**서비스 구성**:
- `api-gateway` (8080): API Gateway, JWT 인증
- `user-service` (8081): 사용자 인증 및 계정 관리
- `catalog-service` (8083): 강의 목록 및 검색
- `planner-service` (8082): 시간표, 시나리오, 수강신청 로직

### 프론트엔드
- **프레임워크**: Next.js 16 (App Router)
- **언어**: TypeScript
- **상태관리**: React Query (@tanstack/react-query)
- **UI**: shadcn/ui + Tailwind CSS
- **HTTP**: axios

### 기타
- **크롤러/테스트**: Python 3.x (uv)

## 아키텍처

```
┌─────────────┐
│   Next.js   │  ← 사용자 인터페이스
│   Web App   │
└──────┬──────┘
       │ HTTP + JWT
       ▼
┌─────────────────────────────────────┐
│        API Gateway (8080)           │
│  - JWT 검증                          │
│  - 경로 라우팅 (/api/v1/* → /*)     │
│  - 통합 Swagger UI                   │
└──────┬──────────────────────────────┘
       │
       ├─→ User Service (8081)
       ├─→ Catalog Service (8083)
       └─→ Planner Service (8082)
              │
              └─→ MySQL DB
```

### 주요 설계 원칙

- **DDD (Domain-Driven Design)**: 서비스별 독립 도메인
- **API Gateway 패턴**: 단일 진입점, JWT 검증, 경로 변환
- **백엔드 우선 원칙**: API 계약을 먼저 확정하고 프론트엔드를 맞춤

## 디렉터리 구조

```
UniPlan/
├── app/
│   ├── backend/           # Spring Boot MSA
│   │   ├── api-gateway/
│   │   ├── user-service/
│   │   ├── catalog-service/
│   │   ├── planner-service/
│   │   └── common-lib/
│   └── frontend/          # Next.js Web
├── tests/
│   └── e2e/               # pytest E2E 시나리오 테스트
├── scripts/
│   ├── crawler/           # 강의 크롤러 (Python)
│   └── README.md
├── docs/                  # 문서
│   ├── architecture.md    # 아키텍처 설계
│   ├── features.md        # 기능 명세
│   ├── guides.md          # 개발 가이드
│   ├── requirements.md    # 프로젝트 요구사항
│   └── adr/               # Architecture Decision Records
├── docker/                # Docker 설정 파일
│   ├── backend.Dockerfile
│   └── mysql/
├── docker-compose.yml     # 개발용 Docker Compose
└── docker-compose.test.yml # 테스트용 Docker Compose
```

## 빠른 시작

### 필수 요구사항

- Java 21+
- Node.js 18+
- MySQL 8.0+ (또는 Docker)
- Python 3.11+ (API 테스트 및 크롤러)
- uv (Python 패키지 매니저)

### 1. 백엔드 실행

```bash
cd app/backend

# 빌드
./gradlew clean build

# 서비스 실행 (각각 별도 터미널)
./gradlew :api-gateway:bootRun      # http://localhost:8080
./gradlew :user-service:bootRun     # http://localhost:8081
./gradlew :catalog-service:bootRun  # http://localhost:8083
./gradlew :planner-service:bootRun  # http://localhost:8082
```

**Swagger UI**: http://localhost:8080/swagger-ui.html

### 2. 프론트엔드 실행

```bash
cd app/frontend

# 의존성 설치
npm install

# 개발 서버 실행
npm run dev
```

**접속**: http://localhost:3000

### 3. Docker Compose (올인원)

```bash
# 루트 디렉터리에서
docker compose up --build
```

- **API Gateway**: http://localhost:8180
- **Frontend (Nginx)**: http://localhost:3000
- **MySQL**: localhost:3316

## 개발 가이드

### 테스트

**백엔드:**
```bash
cd app/backend
./gradlew test
```

**프론트엔드:**
```bash
cd app/frontend
npm run build
npm run lint
```

**E2E 시나리오 테스트:**
```bash
cd tests/e2e
uv sync
uv run pytest -v
```

### 강의 크롤러

```bash
cd scripts
uv sync

# 메타데이터 크롤링
uv run python crawler/run.py metadata --university khu --year 2026 --semester 1

# 강의 크롤링
uv run python crawler/run.py courses --university khu --year 2026 --semester 1

# 업로드
uv run python crawler/run.py upload --university khu --year 2026 --semester 1

# 전체 파이프라인 (메타데이터 + 강의 + 업로드)
uv run python crawler/run.py full --university khu --year 2026 --semester 1
```

## 문서

프로젝트 상세 문서는 `docs/` 폴더를 참고하세요:

- **[architecture.md](docs/architecture.md)**: API Gateway, Swagger, 엔티티 설계
- **[features.md](docs/features.md)**: 기능별 사용자 시나리오
- **[guides.md](docs/guides.md)**: 개발 가이드 (DDD, 테스트, 컨벤션)
- **[requirements.md](docs/requirements.md)**: 프로젝트 요구사항

모듈별 문서:
- `scripts/crawler/docs/`: 크롤러 필드 매핑
- `tests/e2e/README.md`: E2E 테스트 가이드
