# API Gateway - README

## 개요
UniPlan의 **단일 진입점(Single Entry Point)**으로, 모든 클라이언트 요청을 받아 적절한 마이크로서비스로 라우팅합니다.

## 주요 역할
- 🚪 **API 라우팅**: 클라이언트 요청을 적절한 마이크로서비스로 전달
- 🔐 **JWT 인증**: Access Token 검증 및 사용자 정보 추출
- 🔄 **경로 재작성**: `/api/v1/users` → `/users` 등
- 📊 **통합 API 문서**: 모든 서비스의 Swagger 문서 통합
- 🛡️ **CORS 설정**: 프론트엔드 요청 허용

## 기술 스택
- **Framework**: Spring Cloud Gateway
- **언어**: Java
- **포트**: 8080
- **인증**: JWT (JJWT 라이브러리)

## 라우팅 규칙

### 1. 인증 API (인증 불필요)
```
/api/v1/auth/** → user-service:8081/auth/**
```

**경로 재작성**: `/api/v1` 제거
- `POST /api/v1/auth/signup` → `POST /auth/signup`
- `POST /api/v1/auth/login` → `POST /auth/login`

### 2. 사용자 API (JWT 필요)
```
/api/v1/users/** → user-service:8081/users/**
```

**JWT 검증 후 헤더 추가**:
- `X-User-Id`: 사용자 ID
- `X-User-Email`: 이메일
- `X-User-Role`: 권한 (USER, ADMIN)

**경로 재작성**: `/api/v1` 제거
- `GET /api/v1/users/me` → `GET /users/me`
- `GET /api/v1/users/{userId}` → `GET /users/{userId}`

### 3. OAuth2 경로 (향후 확장용)
```
/oauth2/** → user-service:8081/oauth2/**
/login/oauth2/** → user-service:8081/login/oauth2/**
```

## JWT 검증 흐름

### AuthenticationHeaderFilter
```
1. Authorization 헤더에서 Bearer 토큰 추출
2. JWT 서명 검증 (HS256)
3. Payload에서 사용자 정보 추출
   - sub: 사용자 ID
   - email: 이메일
   - role: 권한
4. 다운스트림 서비스로 헤더 전달
   - X-User-Id
   - X-User-Email
   - X-User-Role
```

### 코드 예시
```java
// JWT 검증
Claims claims = Jwts.parser()
    .verifyWith(secretKey)
    .build()
    .parseSignedClaims(token)
    .getPayload();

String userId = claims.getSubject();
String email = claims.get("email", String.class);
String role = claims.get("role", String.class);

// 헤더 추가
ServerWebExchange modifiedExchange = exchange.mutate()
    .request(request -> request
        .header("X-User-Id", userId)
        .header("X-User-Email", email)
        .header("X-User-Role", role))
    .build();
```

## 설정 파일

### application-local.yml
```yaml
server:
  port: 8080

spring:
  cloud:
    gateway:
      globalcors:
        cors-configurations:
          '[/**]':
            allowed-origins: "http://localhost:3000"
            allowed-methods:
              - GET
              - POST
              - PUT
              - DELETE
              - PATCH
              - OPTIONS
            allowed-headers: "*"
            allow-credentials: true

services:
  user-service:
    uri: http://localhost:8081
  planner-service:
    uri: http://localhost:8082
  catalog-service:
    uri: http://localhost:8083

jwt:
  secret: ${JWT_SECRET:uniplan-jwt-secret-key-minimum-256-bits-for-local-development}
```

## Swagger 통합

### 드롭다운 방식
```
http://localhost:8080/swagger-ui.html
```

각 서비스의 API 문서를 드롭다운으로 선택하여 확인:
- User Service
- Planner Service
- Catalog Service

### 설정
```yaml
springdoc:
  swagger-ui:
    urls:
      - name: "User Service"
        url: /user-service/v3/api-docs
      - name: "Planner Service"
        url: /planner-service/v3/api-docs
```

## CORS 설정

### 허용 설정
- **Origin**: `http://localhost:3000` (Flutter 웹)
- **Methods**: GET, POST, PUT, DELETE, PATCH, OPTIONS
- **Headers**: 모든 헤더 허용
- **Credentials**: 허용 (쿠키, Authorization 헤더)

## 에러 처리

### JWT 검증 실패
```json
HTTP 401 Unauthorized
(응답 본문 없음)
```

### 서비스 연결 실패
```json
HTTP 500 Internal Server Error
{
  "timestamp": "2025-10-16T20:30:00",
  "path": "/api/v1/users/me",
  "status": 500,
  "error": "Internal Server Error"
}
```

## 프로젝트 구조
```
api-gateway/
├── src/main/java/com/uniplan/gateway/
│   ├── filter/
│   │   └── AuthenticationHeaderFilter.java  # JWT 검증 필터
│   └── global/
│       └── config/
│           └── FilterConfig.java            # 라우팅 설정
└── src/main/resources/
    ├── application.yml
    └── application-local.yml
```

## 실행 방법

### 1. 로컬 환경
```bash
./gradlew bootRun
```

### 2. 빌드 후 실행
```bash
./gradlew clean build
java -jar build/libs/api-gateway-0.0.1-SNAPSHOT.jar
```

## 테스트 방법

### 1. 인증 없이 접근 (회원가입/로그인)
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

### 2. JWT 토큰으로 인증된 요청
```bash
curl -X GET http://localhost:8080/api/v1/users/me \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### 3. JWT 검증 실패 테스트
```bash
# 잘못된 토큰
curl -X GET http://localhost:8080/api/v1/users/me \
  -H "Authorization: Bearer invalid-token"
# → 401 Unauthorized

# 토큰 없음
curl -X GET http://localhost:8080/api/v1/users/me
# → 401 Unauthorized
```

## 로그 확인

### JWT 검증 성공
```
INFO  AuthenticationHeaderFilter - JWT 검증 성공 - userId: 1, email: test@example.com, role: USER
```

### JWT 검증 실패
```
ERROR AuthenticationHeaderFilter - JWT 검증 실패: JWT signature does not match locally computed signature
```

## 변경 이력

### 2025-10-16
- ✅ AuthenticationHeaderFilter에서 email, role 정보 추출 및 헤더 전달
- ✅ OAuth2 라우팅 간소화 (복잡한 헤더 처리 제거)
- ✅ JWT 검증 로직 개선
- ✅ 에러 처리 통일

## 향후 계획
- [ ] Rate Limiting (요청 횟수 제한)
- [ ] Circuit Breaker (서비스 장애 대응)
- [ ] 요청/응답 로깅
- [ ] API 버전 관리 (v2, v3 등)

## 참고 문서
- [API Path Mapping](../API_PATH_MAPPING.md)
- [JWT 인증 가이드](../JWT_AUTH_GUIDE.md)
- [Swagger 아키텍처](../SWAGGER_ARCHITECTURE.md)
- [인증 시스템 변경 이력](../CHANGELOG_AUTH_2025-10-16.md)
# 인증 시스템 변경 이력 (2025-10-16)

## 개요
OAuth2 기반 인증에서 ID/PW 기반 인증 시스템으로 전환하고, JWT를 활용한 마이크로서비스 인증 아키텍처를 구현했습니다.

## 주요 변경 사항

### 1. 인증 방식 변경

#### 이전 (OAuth2)
- Google OAuth2를 통한 소셜 로그인
- Spring Security OAuth2 Client 사용
- 세션 기반 인증

#### 현재 (ID/PW + JWT)
- 이메일/비밀번호 기반 회원가입 및 로그인
- JWT 토큰 발급 및 검증
- Stateless 인증 (세션 사용 안 함)

#### 향후 계획
- OAuth2 소셜 로그인을 추가 옵션으로 제공 예정
- ID/PW 로그인과 OAuth2 로그인 공존

### 2. User 엔티티 변경

#### 변경된 필드
```java
@Entity
@Table(name = "users")
class User {
    // 변경: nullable로 수정 (OAuth2 사용자는 null)
    @Column(name = "google_id", unique = true)
    private String googleId;  // nullable
    
    // 추가: ID/PW 로그인용 비밀번호 필드
    @Column(length = 255)
    private String password;  // BCrypt 암호화, nullable
    
    // ...기존 필드들...
}
```

#### 지원하는 사용자 타입
1. **로컬 사용자** (ID/PW 회원가입)
   - `email`, `password`, `name` 필수
   - `googleId` = null

2. **OAuth2 사용자** (향후 구현)
   - `email`, `googleId`, `name` 필수
   - `password` = null

### 3. API 엔드포인트 변경

#### 추가된 API
- `POST /api/v1/auth/signup` - 회원가입
- `POST /api/v1/auth/login` - 로그인

#### 유지된 API
- `GET /api/v1/users/me` - 내 정보 조회
- `GET /api/v1/users/{userId}` - 사용자 정보 조회

#### 제거된 API
- `GET /auth/user` - OAuth2 사용자 정보 조회 (임시 제거)
- `GET /auth/login/success` - OAuth2 로그인 성공 콜백 (임시 제거)

### 4. JWT 토큰 구조

#### Access Token Payload
```json
{
  "sub": "1",              // 사용자 ID
  "email": "user@example.com",
  "role": "USER",          // 권한
  "iat": 1697457600,       // 발행 시간
  "exp": 1697544000        // 만료 시간 (24시간)
}
```

#### Refresh Token Payload
```json
{
  "sub": "1",              // 사용자 ID
  "type": "refresh",
  "iat": 1697457600,
  "exp": 1698062400        // 만료 시간 (7일)
}
```

### 5. API Gateway 변경

#### JWT 검증 필터 수정
```java
// AuthenticationHeaderFilter.java
// JWT에서 email, role 정보도 추출하여 헤더로 전달
Claims claims = Jwts.parser()
    .verifyWith(secretKey)
    .build()
    .parseSignedClaims(token)
    .getPayload();

String userId = claims.getSubject();
String email = claims.get("email", String.class);
String role = claims.get("role", String.class);

// 다운스트림 서비스로 전달하는 헤더
- X-User-Id: {userId}
- X-User-Email: {email}
- X-User-Role: {role}
```

#### 라우팅 설정 간소화
```java
// FilterConfig.java
// OAuth2 관련 복잡한 헤더 처리 제거
.route("user-service-oauth2", r -> r
    .path("/oauth2/**", "/login/oauth2/**")
    .uri(userServiceUri))
```

### 6. User Service 변경

#### 새로운 서비스 및 컨트롤러
- `AuthService` - 회원가입/로그인 비즈니스 로직
- `AuthController` - 회원가입/로그인 API
- `JwtTokenProvider` - JWT 토큰 생성 메서드 추가
  - `createAccessToken(userId, email, role)`
  - `createRefreshToken(userId)`

#### 새로운 DTO
- `SignupRequest` - 회원가입 요청
- `LoginRequest` - 로그인 요청
- `AuthResponse` - 인증 응답 (토큰 포함)

#### 전역 예외 처리
- `GlobalExceptionHandler` - 전역 예외 핸들러
- `AuthenticationException` - 401 Unauthorized
- `DuplicateResourceException` - 409 Conflict
- `ResourceNotFoundException` - 404 Not Found
- `ErrorResponse` - 에러 응답 DTO

#### Security 설정 변경
```java
// 이전: OAuth2 로그인 + 인증 필요
.authorizeHttpRequests(authz -> authz
    .requestMatchers("/auth/**").permitAll()
    .anyRequest().authenticated()
)
.oauth2Login(oauth2 -> oauth2
    .successHandler(oAuth2LoginSuccessHandler)
)

// 현재: 모든 요청 허용 (Gateway에서 인증)
.authorizeHttpRequests(authz -> authz
    .anyRequest().permitAll()
)
.csrf(csrf -> csrf.disable())
```

### 7. 인증 흐름 변경

#### 이전 흐름 (OAuth2)
```
Client → Google OAuth → Callback → User Service → JWT 발급
```

#### 현재 흐름 (ID/PW + JWT)
```
1. 회원가입/로그인
Client → Gateway → User Service → JWT 발급

2. 인증된 API 호출
Client → Gateway (JWT 검증) → User Service (헤더로 사용자 정보)
```

## 에러 처리 개선

### HTTP 상태 코드 정규화

#### 이전
- 모든 비즈니스 로직 오류가 500 Internal Server Error로 반환

#### 현재
| 상황 | 이전 | 현재 |
|------|------|------|
| 로그인 실패 | 500 | 401 Unauthorized |
| 이메일 중복 | 500 | 409 Conflict |
| 사용자 없음 | 500 | 404 Not Found |
| 입력값 오류 | - | 400 Bad Request |

### 에러 응답 형식
```json
{
  "timestamp": "2025-10-16T20:30:00",
  "status": 401,
  "error": "Unauthorized",
  "message": "이메일 또는 비밀번호가 올바르지 않습니다"
}
```

## 보안 개선

### 1. 비밀번호 암호화
- **알고리즘**: BCrypt
- **Salt Rounds**: 기본값 (10)
- **구현**: `BCryptPasswordEncoder`

### 2. JWT 보안
- **서명 알고리즘**: HS256
- **Secret Key**: 최소 256비트
- **토큰 만료**: Access 24시간, Refresh 7일

### 3. CSRF 보호
- REST API이므로 CSRF 비활성화
- JWT 기반 인증으로 CSRF 공격 방어

## 테스트 가이드

### 1. 회원가입 테스트
```bash
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "테스트사용자"
  }'
```

### 2. 로그인 테스트
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### 3. 내 정보 조회 테스트
```bash
curl -X GET http://localhost:8080/api/v1/users/me \
  -H "Authorization: Bearer {받은_accessToken}"
```

### 4. 에러 케이스 테스트

#### 이메일 중복 (409)
```bash
# 동일한 이메일로 두 번 회원가입 시도
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123", "name": "테스트"}'
```

#### 로그인 실패 (401)
```bash
# 잘못된 비밀번호
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "wrongpassword"}'
```

#### 입력값 검증 실패 (400)
```bash
# 짧은 비밀번호
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "123", "name": "테스트"}'
```

## 마이그레이션 가이드

### 기존 OAuth2 사용자 데이터 유지
기존 `users` 테이블의 OAuth2 사용자 데이터는 유지됩니다:
- `google_id`가 있는 사용자: OAuth2 사용자 (향후 재활성화 시 사용)
- `password`가 있는 사용자: 로컬 사용자 (새로 가입)

### 데이터베이스 마이그레이션
```sql
-- password 컬럼 추가 (이미 추가됨)
ALTER TABLE users ADD COLUMN password VARCHAR(255);

-- google_id를 nullable로 변경
ALTER TABLE users MODIFY COLUMN google_id VARCHAR(255) NULL;
```

## 향후 작업

### 단기 (1-2주)
- [ ] Refresh Token을 이용한 Access Token 재발급 API
- [ ] 로그아웃 기능 (토큰 블랙리스트)
- [ ] 비밀번호 변경 API
- [ ] 사용자 프로필 수정 API

### 중기 (1개월)
- [ ] OAuth2 소셜 로그인 재활성화 (Google)
- [ ] Naver, Kakao OAuth2 추가
- [ ] 이메일 인증 (회원가입 시)
- [ ] 비밀번호 찾기 (이메일 인증)

### 장기 (2-3개월)
- [ ] 관리자 기능 (사용자 관리)
- [ ] 사용자 활동 로그
- [ ] 2FA (Two-Factor Authentication)
- [ ] Rate Limiting (로그인 시도 제한)

## 관련 파일

### User Service
- `User.java` - 사용자 엔티티 (password 필드 추가)
- `AuthService.java` - 회원가입/로그인 서비스
- `AuthController.java` - 회원가입/로그인 API
- `JwtTokenProvider.java` - JWT 생성/검증
- `GlobalExceptionHandler.java` - 전역 예외 처리
- `SecurityConfig.java` - Spring Security 설정
- `SignupRequest.java`, `LoginRequest.java`, `AuthResponse.java` - DTO

### API Gateway
- `AuthenticationHeaderFilter.java` - JWT 검증 및 헤더 전달
- `FilterConfig.java` - 라우팅 설정

### 설정 파일
- `application.yml` - JWT 기본 설정
- `application-local.yml` - 로컬 환경 설정

## 참고 문서
- [User Service README](../../user-service/README_NEW.md)
- [API Path Mapping](../API_PATH_MAPPING.md)
- [JWT 인증 가이드](../JWT_AUTH_GUIDE.md)

