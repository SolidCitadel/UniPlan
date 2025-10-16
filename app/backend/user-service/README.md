# User Service

## 개요
UniPlan의 **사용자 인증 및 계정 관리**를 담당하는 마이크로서비스입니다.

### 주요 역할
- 🔐 **ID/PW 기반 인증**: 이메일과 비밀번호를 통한 회원가입/로그인
- 🎫 **JWT 토큰 발급**: 인증 성공 시 액세스 토큰 및 리프레시 토큰 생성
- 👤 **사용자 정보 관리**: 프로필, 설정 등 사용자 데이터 CRUD
- 🔄 **향후 확장 예정**: OAuth2 소셜 로그인 (Google, Naver, Kakao 등)

## 기술 스택
- **Framework**: Spring Boot 3.5.6
- **언어**: Kotlin
- **인증**: Spring Security + JWT
- **데이터베이스**: MySQL (운영) / H2 (개발/테스트)
- **ORM**: Spring Data JPA + Hibernate
- **빌드 도구**: Gradle (Kotlin DSL)
- **API 문서**: Swagger/OpenAPI 3.0

## API 엔드포인트

### 인증 API (`/auth`)

#### 1. 회원가입
```http
POST /api/v1/auth/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "홍길동"
}
```

**응답 (201 Created):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "userId": 1,
  "email": "user@example.com",
  "name": "홍길동"
}
```

**에러 응답 (409 Conflict):**
```json
{
  "timestamp": "2025-10-16T20:30:00",
  "status": 409,
  "error": "Conflict",
  "message": "이미 사용 중인 이메일입니다"
}
```

#### 2. 로그인
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**응답 (200 OK):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "userId": 1,
  "email": "user@example.com",
  "name": "홍길동"
}
```

**에러 응답 (401 Unauthorized):**
```json
{
  "timestamp": "2025-10-16T20:30:00",
  "status": 401,
  "error": "Unauthorized",
  "message": "이메일 또는 비밀번호가 올바르지 않습니다"
}
```

### 사용자 API (`/users`)

#### 3. 내 정보 조회
```http
GET /api/v1/users/me
Authorization: Bearer {accessToken}
```

**응답 (200 OK):**
```json
{
  "id": 1,
  "email": "user@example.com",
  "name": "홍길동",
  "displayName": "홍길동",
  "role": "USER",
  "status": "ACTIVE",
  "createdAt": "2025-10-16T20:30:00",
  "updatedAt": "2025-10-16T20:30:00"
}
```

#### 4. 사용자 정보 조회 (ID로)
```http
GET /api/v1/users/{userId}
Authorization: Bearer {accessToken}
```

## 인증 흐름

### 1. 회원가입/로그인 흐름
```
Client → API Gateway → User Service → Database
  │           │              │            │
  │ POST      │              │            │
  │ /auth/    │ JWT 없음     │ 사용자     │
  │ login     │ 통과         │ 조회       │
  │           │              │            │
  │           │              │ 비밀번호   │
  │           │              │ 검증       │
  │           │              │            │
  │           │              │ JWT 생성   │
  │           │ AuthResponse │            │
  │ ← ← ← ← ← ← ← ← ← ← ← ← ←│            │
  │ (accessToken, refreshToken)           │
```

### 2. 인증된 API 호출 흐름
```
Client → API Gateway → User Service
  │           │              │
  │ GET       │ JWT 검증     │ X-User-Id
  │ /users/me │ 성공         │ 헤더로
  │ + JWT     │              │ userId 전달
  │           │              │
  │           │ GET /users/me│ 사용자
  │           │ X-User-Id: 1 │ 정보 조회
  │           │              │
  │ ← ← ← ← ← UserResponse ← ←
```

## JWT 토큰 구조

### Access Token
- **만료 시간**: 24시간
- **Payload**:
  - `sub`: 사용자 ID
  - `email`: 이메일
  - `role`: 권한 (USER, ADMIN)
  - `iat`: 발행 시간
  - `exp`: 만료 시간

### Refresh Token
- **만료 시간**: 7일
- **Payload**:
  - `sub`: 사용자 ID
  - `type`: "refresh"
  - `iat`: 발행 시간
  - `exp`: 만료 시간

## 에러 응답 코드

| HTTP 상태 코드 | 설명 | 예시 |
|--------------|------|------|
| 400 Bad Request | 입력값 검증 실패 | 이메일 형식 오류, 비밀번호 길이 부족 |
| 401 Unauthorized | 인증 실패 | 로그인 실패, 잘못된 비밀번호 |
| 404 Not Found | 리소스를 찾을 수 없음 | 존재하지 않는 사용자 |
| 409 Conflict | 리소스 중복 | 이미 사용 중인 이메일 |
| 500 Internal Server Error | 서버 오류 | 예상치 못한 오류 |

## 프로젝트 구조
```
user-service/
├── src/main/java/com/uniplan/user/
│   ├── domain/
│   │   ├── auth/                      # 인증 도메인
│   │   │   ├── controller/
│   │   │   │   └── AuthController     # 회원가입/로그인 API
│   │   │   ├── service/
│   │   │   │   ├── AuthService        # 인증 비즈니스 로직
│   │   │   │   └── JwtTokenProvider   # JWT 생성/검증
│   │   │   └── dto/
│   │   │       ├── SignupRequest
│   │   │       ├── LoginRequest
│   │   │       └── AuthResponse
│   │   │
│   │   └── user/                      # 사용자 도메인
│   │       ├── controller/
│   │       │   └── UserController     # 사용자 정보 조회 API
│   │       ├── service/
│   │       │   └── UserService
│   │       ├── repository/
│   │       │   └── UserRepository
│   │       ├── entity/
│   │       │   ├── User               # 사용자 엔티티
│   │       │   ├── UserRole           # USER, ADMIN
│   │       │   └── UserStatus         # ACTIVE, INACTIVE, BANNED
│   │       └── dto/
│   │           └── UserResponse
│   │
│   └── global/                        # 전역 설정
│       ├── config/
│       │   └── SecurityConfig         # Spring Security 설정
│       └── exception/
│           ├── GlobalExceptionHandler # 전역 예외 처리
│           ├── ErrorResponse
│           ├── AuthenticationException    # 401
│           ├── DuplicateResourceException # 409
│           └── ResourceNotFoundException  # 404
```

## 데이터베이스 스키마

### users 테이블
| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|---------|------|
| id | BIGINT | PK, AUTO_INCREMENT | 사용자 ID |
| email | VARCHAR(255) | UNIQUE, NOT NULL | 이메일 |
| password | VARCHAR(255) | | 암호화된 비밀번호 (BCrypt) |
| name | VARCHAR(100) | | 이름 |
| google_id | VARCHAR(255) | UNIQUE | Google OAuth ID (향후 확장용) |
| picture | TEXT | | 프로필 사진 URL |
| display_name | VARCHAR(50) | | 닉네임 |
| role | VARCHAR(20) | NOT NULL | 권한 (USER, ADMIN) |
| status | VARCHAR(20) | NOT NULL | 상태 (ACTIVE, INACTIVE, BANNED) |
| created_at | TIMESTAMP | NOT NULL | 생성 시간 |
| updated_at | TIMESTAMP | | 수정 시간 |

## 실행 방법

### 1. 로컬 환경에서 실행
```bash
# 빌드
./gradlew clean build

# 실행
./gradlew bootRun
```

### 2. API Gateway를 통한 접근
```
http://localhost:8080/api/v1/auth/signup    # 회원가입
http://localhost:8080/api/v1/auth/login     # 로그인
http://localhost:8080/api/v1/users/me       # 내 정보 조회
```

### 3. Swagger UI
```
http://localhost:8080/swagger-ui.html
```

## 보안

### 1. 비밀번호 암호화
- **알고리즘**: BCrypt
- **구현**: Spring Security의 `BCryptPasswordEncoder`

### 2. JWT 서명
- **알고리즘**: HS256
- **Secret Key**: 환경 변수 또는 설정 파일에서 관리
- **최소 길이**: 256비트 이상

### 3. API Gateway 연동
- API Gateway에서 JWT를 검증하고 `X-User-Id`, `X-User-Email`, `X-User-Role` 헤더로 사용자 정보를 전달
- User Service는 이미 검증된 요청만 받으므로 별도의 인증 처리 불필요

## 향후 확장 계획

### 1. OAuth2 소셜 로그인
- [ ] Google OAuth2
- [ ] Naver OAuth2
- [ ] Kakao OAuth2

### 2. 토큰 관리
- [ ] Refresh Token을 통한 Access Token 재발급 API
- [ ] 로그아웃 (토큰 무효화)
- [ ] 토큰 블랙리스트 관리

### 3. 사용자 관리 기능
- [ ] 비밀번호 변경
- [ ] 비밀번호 찾기 (이메일 인증)
- [ ] 프로필 수정
- [ ] 회원 탈퇴

## 변경 이력

### 2025-10-16
- ✅ ID/PW 기반 회원가입/로그인 구현
- ✅ JWT 토큰 발급 및 검증 (email, role 포함)
- ✅ 전역 예외 처리 (401, 404, 409, 400, 500)
- ✅ API Gateway 연동 (JWT 검증 후 헤더로 사용자 정보 전달)
- ✅ User 엔티티에 password 필드 추가 (OAuth2와 ID/PW 모두 지원)
- ✅ Spring Security 설정 간소화 (Gateway에서 인증 처리)
- ✅ Swagger/OpenAPI 문서화

## 참고 문서
- [API Path Mapping](../API_PATH_MAPPING.md)
- [JWT 인증 가이드](../JWT_AUTH_GUIDE.md)
- [Swagger 아키텍처](../SWAGGER_ARCHITECTURE.md)

