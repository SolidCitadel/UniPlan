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
| **MySQL** | `uniplan-mysql` | 3316 | 통합 데이터베이스 (User, Planner, Catalog 스키마) |
| **API Gateway** | `gateway-service` | 8080 | 단일 진입점 (`/api/v1/**`) |
| **User Service** | `user-service` | - | 인증 및 사용자 관리 (내부망 전용) |
| **Planner Service** | `planner-service` | - | 시간표/시나리오 로직 (내부망 전용) |
| **Catalog Service** | `catalog-service` | 8083 | 강의 데이터 제공 (디버깅용 직접 접근 허용) |

> **참고**: 내부 서비스들은 Gateway를 통해서만 접근하는 것이 원칙이나, 개발 편의를 위해 Catalog Service 등 일부는 호스트 포트가 노출될 수 있습니다.

### 실행 방법
```bash
# 1. 백엔드 빌드 (선택사항, Docker에서 빌드함)
./gradlew clean bootJar

# 2. 전체 서비스 실행 (Detach 모드)
docker-compose up -d --build

# 3. 로그 확인
docker-compose logs -f api-gateway
```

## 3. 테스트 환경 (`docker-compose.test.yml`)

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
