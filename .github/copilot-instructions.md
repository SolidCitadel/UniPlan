# UniPlan - GitHub Copilot Instructions

## 프로젝트 개요
시나리오 기반 대학생 수강신청 플래너 웹 애플리케이션

## 기술 스택

### 클라이언트
- **Framework**: Flutter (웹 우선)
- **언어**: Dart

### 백엔드
- **아키텍처**: 마이크로서비스 (MSA)
- **Framework**: Spring Boot 3.x
- **언어**: Kotlin (Java 호환)
- **API Gateway**: Spring Cloud Gateway
- **통신**: RESTful API
- **DB**: MySQL
- **빌드 도구**: Gradle (Kotlin DSL)

## 서비스 구조

```
app/backend/
├── api-gateway/          # Spring Cloud Gateway (단일 진입점)
├── user-service/         # 사용자 인증/계정/데이터 관리
├── planner-service/      # 의사결정 트리 기반 시나리오 플랜 생성/관리 (핵심)
├── catalog-service/      # 강의 목록 관리, 크롤링, 검색 API
└── common-lib/           # 공통 DTO, 유틸리티, 예외 처리
```

## 코딩 가이드라인

### Kotlin 코드 스타일
- 패키지명: `com.uniplan.<service-name>`
- 클래스명: PascalCase
- 함수/변수명: camelCase
- 상수: UPPER_SNAKE_CASE
- 불변성 우선: `val` 사용, 가능하면 `data class` 활용
- Null 안전성: Non-null 타입 우선, 필요시 `?` 사용

### 패키지 구조
- **도메인 기반 구조 채택**: 레이어(controller/service/repository)보다 도메인별 응집도 우선
- 패키지 구조:
  ```
  com.uniplan.<service-name>/
  ├── domain/              # 도메인별 패키지
  │   ├── <domain-1>/      # 예: auth, user, timetable
  │   │   ├── controller/
  │   │   ├── service/
  │   │   ├── repository/
  │   │   ├── entity/
  │   │   └── dto/
  │   └── <domain-2>/
  └── global/              # 전역 설정 및 공통 코드
      ├── config/
      ├── exception/
      └── util/
  ```
- 도메인 예시:
  - `user-service`: `domain/auth`, `domain/user`
  - `planner-service`: `domain/timetable`, `domain/scenario`, `domain/plan`
  - `catalog-service`: `domain/course`, `domain/search`

### 아키텍처 패턴
- **도메인 우선 설계**: 관련 기능은 하나의 도메인 패키지에 응집
- **레이어 구조**: Controller → Service → Repository (각 도메인 내부에서)
- **DTO 분리**: 요청/응답용 DTO는 도메인 모델과 분리
- **공통 코드**: 여러 서비스에서 사용하는 DTO/유틸은 `common-lib`에 위치
- **예외 처리**: 커스텀 예외는 `global/exception` 또는 `common-lib`에 정의, `@ControllerAdvice`로 전역 처리

### REST API 규칙
- URL: kebab-case 사용 (`/api/v1/course-catalog`)
- HTTP 메서드: GET(조회), POST(생성), PUT(전체 수정), PATCH(부분 수정), DELETE(삭제)
- 응답 형식: JSON, 공통 응답 래퍼 사용 권장
- 상태 코드: 200(성공), 201(생성), 400(잘못된 요청), 401(인증 실패), 404(없음), 500(서버 오류)

### 데이터베이스
- JPA/Hibernate 사용
- Entity는 각 서비스 내부에 정의
- 컬럼명: snake_case
- 테이블명: 복수형 (`users`, `courses`, `timetables`)

## 핵심 도메인 모델

### 의사결정 트리 (Decision Tree)
- **노드**: 각 시간표 (기본 + 대안들)
- **엣지**: 실패 시나리오 (어떤 과목 실패 시 → 대체 시간표)
- **탐색**: 실시간 수강신청 중 성공/실패 입력 → 트리 경로 네비게이션

### 주요 엔티티
- `User`: 사용자 계정
- `Course`: 강의 정보 (과목명, 교수, 시간, 학점 등)
- `Timetable`: 시간표 (여러 Course 포함)
- `Scenario`: 의사결정 트리 노드 (기본 시간표 + 실패 시나리오 + 대안 시간표)

## 개발 우선순위
1. `planner-service`, `catalog-service` 모듈 생성 및 기본 구조 구축
2. 각 서비스별 핵심 도메인 모델 및 CRUD API 구현
3. API Gateway 라우팅 설정
4. MySQL 연동 및 마이그레이션
5. 의사결정 트리 알고리즘 구현
6. Flutter 웹 클라이언트 개발

## 주의사항
- 각 마이크로서비스는 독립적으로 배포 가능하도록 설계
- 서비스 간 직접 DB 접근 금지 (API 통신만 사용)
- 민감 정보(DB 패스워드 등)는 환경 변수나 설정 파일 분리
- 모든 API는 인증/인가 고려 (JWT 또는 OAuth2 권장)

## 참고 문서
- 요구사항 명세서: `요구사항명세서.md`
- 각 서비스별 README: 각 서비스 디렉터리 내 `README.md`
