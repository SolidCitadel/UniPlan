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
- [API Path Mapping](../../docs/backend/api-path-mapping.md)
- [Swagger 아키텍처](../../docs/backend/swagger-architecture.md)

