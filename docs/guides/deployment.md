# 배포 및 로컬 실행 가이드 (Deployment Guide)

## 1. 사전 요구사항 (Prerequisites)
- **Docker Desktop**: 컨테이너 오케스트레이션 필수
- **JDK 21**: 로컬 빌드용
- **Node.js 20+**: 프론트엔드 개발용

## 2. 로컬 개발 환경 (Local Development)

UniPlan은 `docker-compose`를 사용하여 로컬에서 전체 마이크로서비스 환경을 쉽게 구축할 수 있습니다.

### Docker Compose 서비스 (`docker-compose.yml`)
| 서비스 | 컨테이너명 | 호스트 포트 | 설명 |
|--------|------------|-------------|------|
| **Redis** | `uniplan-redis` | 6379 | 과목 데이터 캐싱 (Planner Service용) |
| **MySQL** | `uniplan-mysql` | 3316 | 통합 데이터베이스 (User, Planner, Catalog 스키마) |
| **API Gateway** | `gateway-service` | 8080 | 단일 진입점 (`/api/v1/**`) |
| **User Service** | `user-service` | - | 인증 및 사용자 관리 (내부망 전용) |
| **Planner Service** | `planner-service` | - | 시간표/시나리오 로직 (내부망 전용) |
| **Catalog Service** | `catalog-service` | 8083 | 강의 데이터 제공 (디버깅용 직접 접근 허용) |

> **참고**: 내부 서비스들은 Gateway를 통해서만 접근하는 것이 원칙이나, 개발 편의를 위해 Catalog Service 등 일부는 호스트 포트가 노출될 수 있습니다.

### 실행 방법
```bash
# 1. 프론트엔드 환경변수 설정 (최초 1회)
cp app/frontend/.env.local.example app/frontend/.env.local

# 2. 전체 서비스 실행 (Detach 모드)
docker compose up -d --build

# 3. 프론트엔드 개발 서버 실행
cd app/frontend && npm install && npm run dev

# 4. 로그 확인 (JSON 형식)
docker compose logs -f api-gateway

# 4-1. jq로 구조화 로그 보기 (가독성 향상)
docker compose logs -f planner-service | jq '.'

# 4-2. 특정 requestId로 요청 추적
docker compose logs user-service planner-service catalog-service | jq 'select(.requestId == "a1b2c3d4-...")'

# 5. 서비스 상태 확인 (Actuator health)
curl http://localhost:8080/actuator/health   # api-gateway
curl http://localhost:8081/actuator/health   # user-service (로컬 직접 실행 시)
```

> **환경변수 필수**: `app/frontend/.env.local`이 없으면 `npm run dev` 시 즉시 오류가 발생합니다.

## 3. Observability 스택 (`docker-compose.observability.yml`)

Prometheus + Grafana를 포함한 메트릭 모니터링 환경을 선택적으로 기동할 수 있습니다.

### 서비스 목록

| 서비스 | 호스트 포트 | 설명 |
|--------|------------|------|
| **Prometheus** | 9090 | 메트릭 수집 (15초 주기 scrape) |
| **Grafana** | 3001 | 메트릭/트레이스 시각화 (admin / GRAFANA_ADMIN_PASSWORD) |
| **Tempo** | 내부망 | 분산 트레이스 수집 (OTLP HTTP 4318, API 3200) |

### 실행 방법

```bash
# 0. 환경변수 설정 (최초 1회)
cp .env.example .env
# GRAFANA_ADMIN_PASSWORD 기본값은 admin (프로덕션 사용 전 반드시 변경)

# Observability 포함 기동 (기존 서비스 + Prometheus + Grafana)
docker compose -f docker-compose.yml -f docker-compose.observability.yml up -d --build

# Prometheus 타겟 상태 확인
# 브라우저: http://localhost:9090/targets → 4개 서비스 모두 UP이어야 함

# Grafana 접속
# 브라우저: http://localhost:3001 (admin / GRAFANA_ADMIN_PASSWORD 값)
# → Dashboards → Import → ID 4701 입력 → Prometheus 데이터소스 선택 → Import
```

> **포트 참고**: Grafana는 3001 포트를 사용합니다 (Next.js 개발 서버 3000과 충돌 방지).

### 대시보드 임포트 (JVM Micrometer)

Grafana 공식 대시보드 ID **4701** (JVM Micrometer)을 임포트하면 JVM 힙, GC, HTTP 요청 수/응답시간 등을 즉시 확인할 수 있습니다.

1. Grafana 좌측 메뉴 → Dashboards → Import
2. `4701` 입력 후 Load
3. Prometheus 데이터소스 선택 → Import

### 분산 트레이스 조회 (Grafana Tempo)

서비스 간 요청 흐름을 트레이스로 확인합니다:

1. Grafana 좌측 메뉴 → Explore
2. 데이터소스 드롭다운 → **Tempo** 선택
3. Search 탭 → Service Name 드롭다운에서 서비스 선택 (예: `api-gateway`)
4. **Run query** → 트레이스 목록 확인
5. 트레이스 클릭 → span 상세 및 서비스 간 호출 시간 확인

```bash
# JSON 로그에 traceId 포함 확인
docker compose logs api-gateway | jq 'select(.traceId != null) | {traceId, spanId, message}' 2>/dev/null | head -20
```

---

## 4. 테스트 환경 (`docker-compose.test.yml`)

Integration 테스트를 위해 별도의 컴포즈 파일을 사용합니다.

```bash
docker-compose -f docker-compose.test.yml up -d --build
```

## 4. 운영 배포 (`docker-compose.prod.yml`)

운영 환경에서는 `docker-compose.prod.yml`과 `.env` 파일을 사용하여 시크릿을 주입합니다.

```bash
# 1. .env 파일 생성 (시크릿 설정)
cp .env.example .env
# .env 파일을 편집하여 JWT_SECRET, DB_PASSWORD 등 설정

# 2. 운영 환경 실행
docker-compose -f docker-compose.prod.yml up -d --build
```

> 📝 `docker-compose.prod.yml`은 필요 시 생성해야 합니다. 현재는 `docker-compose.yml`만 존재합니다.

## 5. CI/CD (GitHub Actions)

### OpenAPI Type Sync (`openapi-types.yml`)

생성된 OpenAPI 타입이 최신 백엔드 스펙과 일치하는지 검증합니다.

**트리거**: 수동 (`workflow_dispatch`)

**검증 대상**:
- 프론트엔드 TypeScript: `app/frontend/src/types/generated/`
- Integration 테스트 Python: `tests/integration/models/generated/`

**로컬에서 타입 재생성**:
```bash
# 백엔드 실행 필요
docker compose up -d --build

# 프론트엔드 타입 생성
cd app/frontend && npm run types:generate

# Integration 테스트 모델 생성
cd tests/integration && uv run python scripts/generate_models.py
```

> **중요**: 백엔드 DTO를 변경한 경우, 반드시 타입/모델을 재생성하고 커밋해야 합니다. CI에서 불일치 감지 시 빌드가 실패합니다.

