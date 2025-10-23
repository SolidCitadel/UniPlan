# UniPlan

**시나리오 기반 대학교 수강신청 플래너**

UniPlan은 학생들이 수강신청 시 발생하는 불확실성을 관리할 수 있도록 대체 시간표의 의사결정 트리(플랜 A, B, C...)를 구축하고, 실제 수강신청 중 실시간 네비게이션을 제공합니다.

## 아키텍처 개요

```
UniPlan/
├── app/
│   ├── backend/           # Spring Boot 마이크로서비스 (MSA)
│   │   ├── api-gateway/   # 진입점 (port 8080)
│   │   ├── user-service/  # 인증 & 사용자 관리
│   │   ├── catalog-service/ # 강의 카탈로그 & 검색
│   │   ├── planner-service/ # 의사결정 트리 시나리오 (계획중)
│   │   └── common-lib/    # 공유 JWT 유틸리티
│   ├── cli-client/        # CLI 클라이언트 (Dart, 진행중)
│   └── frontend/          # Flutter 웹 클라이언트 (계획중)
├── scripts/
│   └── crawler/           # Python 강의 데이터 크롤러
└── docs/                  # 추가 문서
```

## 기술 스택

### Backend
- **프레임워크**: Spring Boot 3.x with Java 21
- **아키텍처**: 마이크로서비스 (MSA) with API Gateway
- **빌드**: Gradle with Kotlin DSL
- **데이터베이스**: MySQL (운영), H2 (개발/테스트)
- **인증**: JWT (access + refresh tokens)
- **API 문서**: Swagger/OpenAPI 3.0

### Scripts
- **언어**: Python 3.x
- **목적**: 대학교 강의 데이터 크롤링 및 catalog-service용 변환
- **아키텍처**: 3단계 독립 워크플로우 (메타데이터 → 크롤링 → 변환)

### CLI Client (진행중)
- **언어**: Dart
- **목적**: Frontend 완성 전 Backend API 테스트
- **개발 순서**: Backend → CLI Client → Frontend

### Frontend (계획중)
- **프레임워크**: Flutter web
- **기능**: 시간표 빌더, 의사결정 트리 편집기, 실시간 네비게이션

## 빠른 시작

### Backend

```bash
cd app/backend

# 모든 서비스 빌드
./gradlew clean build

# 서비스 실행 (각각 별도 터미널에서)
./gradlew :api-gateway:bootRun      # Port 8080
./gradlew :user-service:bootRun     # Port 8081
./gradlew :catalog-service:bootRun  # Port 8083
```

**Swagger UI**: http://localhost:8080/swagger-ui.html

### 강의 크롤러

```bash
cd scripts/crawler

# 초기 설정 (최초 1회만)
python -m venv venv
venv\Scripts\activate  # Windows
pip install -r requirements.txt

# 강의 데이터 크롤링 (3단계 워크플로우)
python crawl_metadata.py --year 2025 --semester 1
python run_crawler.py --year 2025 --semester 1 --limit 5
python transformer.py --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json

# catalog-service로 import
curl -X POST http://localhost:8080/api/courses/import \
  -H "Content-Type: application/json" \
  -d @output/transformed_2025_1.json
```

## 핵심 기능

### 1. 의사결정 트리 시나리오

학생들이 대체 시간표의 트리를 생성:

```
기본 시간표 (CS101, CS102, CS103)
  ├─ CS101 실패 → 대안 1 (CS104, CS102, CS103)
  │   └─ CS104 실패 → 대안 1a (CS105, CS102, CS103)
  └─ CS102 실패 → 대안 2 (CS101, CS106, CS103)
```

### 2. 실시간 네비게이션

수강신청 중 성공/실패 입력 → 시스템이 의사결정 트리 탐색 → 다음 대체 시간표 표시.

### 3. 강의 카탈로그

- 학과, 교수, 시간 등으로 강의 검색/필터링
- 강의 상세정보 확인: 학점, 강의실, 선수과목
- 시간표에 강의 추가 및 충돌 감지

## 개발 순서

1. ✅ **Backend**: API Gateway, User Service, Catalog Service 완료
2. ✅ **Crawler**: 3단계 워크플로우 완료 (메타데이터, 크롤링, 변환)
3. 🔄 **Planner Service**: 진행중 (의사결정 트리 구현)
4. 📋 **CLI Client**: 다음 단계 (Backend API 테스트용, Dart)
5. 📋 **Frontend**: 이후 단계 (Flutter web)

**개발 우선순위**: Backend → CLI Client → Frontend

## 프로젝트 상태

- ✅ **Backend 서비스**
  - API Gateway, User Service, Catalog Service 운영 중
  - JWT 인증, Swagger 문서화 완료

- ✅ **Crawler**
  - 3단계 워크플로우 완료
  - classTime DB 친화적 구조 (`[{day, startTime, endTime}]`)
  - 하드코딩 제거 (메타데이터 기반 동적 매핑)

- 🔄 **Planner Service**
  - 의사결정 트리 구현 진행중

- 📋 **CLI Client**
  - Dart로 구현 예정
  - Backend 테스트 및 검증용

- 📋 **Frontend**
  - Flutter web으로 구현 예정
  - CLI Client 완성 후 시작

## 문서

### 시작하기
- **CLAUDE.md**: AI 어시스턴트용 프로젝트 전체 가이드
- **요구사항명세서.md**: 요구사항 명세서

### Backend
- **API 경로 매핑**: `app/backend/API_PATH_MAPPING.md`
- **JWT 인증**: `app/backend/JWT_AUTH_GUIDE.md`
- **Swagger 아키텍처**: `app/backend/SWAGGER_ARCHITECTURE.md`
- **User Service**: `app/backend/user-service/README.md`
- **Catalog Service**: `app/backend/catalog-service/README.md`

### Scripts
- **크롤러 가이드**: `scripts/crawler/README.md`
- **변환 가이드**: `scripts/crawler/TRANSFORMATION_GUIDE.md`
- **필드 매핑**: `scripts/crawler/FIELD_MAPPING.md`

## 개발 환경

### 서비스 포트
- API Gateway: 8080 (메인 진입점)
- User Service: 8081
- Planner Service: 8082 (계획중)
- Catalog Service: 8083

### 환경 설정

1. **Java 21**: Spring Boot 3.x 필수
2. **MySQL**: 운영 데이터베이스용
3. **Python 3.x**: 강의 크롤러용
4. **Dart**: CLI Client용 (예정)
5. **JWT_SECRET**: 환경변수 설정 필수 (최소 256비트)

### 주요 명령어

```bash
# Backend
./gradlew clean build
./gradlew test
./gradlew :user-service:bootRun

# Crawler
python crawl_metadata.py --year 2025 --semester 1
python run_crawler.py --year 2025 --semester 1
python transformer.py --metadata ... --courses ...
```
