# JWT 인증 플로우 가이드

## 🎯 전체 아키텍처

```
┌──────────────┐
│   브라우저    │
└──────┬───────┘
       │
       │ 1. Google 로그인
       ▼
┌─────────────────────────────────────────────────────────────┐
│ User Service (8081)                                         │
│                                                             │
│ OAuth2LoginSuccessHandler                                  │
│   ├─ Google에서 사용자 정보 받음                              │
│   ├─ DB에 저장/업데이트                                       │
│   └─ JWT 토큰 발급 ───────────────────┐                      │
│                                       │                      │
│ /login/success                        │                      │
│   └─ { accessToken, refreshToken } ◄──┘                     │
└─────────────────────────────────────────────────────────────┘
       │
       │ 2. 토큰 저장 (브라우저)
       ▼
┌──────────────┐
│  브라우저     │
│ localStorage  │
│ accessToken   │
│ refreshToken  │
└──────┬───────┘
       │
       │ 3. 이후 모든 API 요청
       │    Authorization: Bearer {accessToken}
       ▼
┌─────────────────────────────────────────────────────────────┐
│ API Gateway (8080)                                          │
│                                                             │
│ AuthenticationHeaderFilter                                 │
│   ├─ Authorization 헤더에서 JWT 추출                         │
│   ├─ JWT 검증 (서명, 만료시간)                               │
│   ├─ 토큰에서 userId 추출                                    │
│   └─ X-User-Id 헤더 추가 ───────────────────┐               │
│                                             │               │
│ 라우팅: /api/v1/users/** → User Service     │               │
└─────────────────────────────────────────────┼───────────────┘
                                              │
                                              │ X-User-Id: 123
                                              ▼
┌─────────────────────────────────────────────────────────────┐
│ User Service (8081)                                         │
│                                                             │
│ UserController.getMyInfo()                                 │
│   ├─ @RequestHeader("X-User-Id") 받음                       │
│   ├─ UserService.getUserInfo(userId) 호출                  │
│   └─ 사용자 정보 반환                                        │
└─────────────────────────────────────────────────────────────┘
```

## 📋 구현 완료 항목

### ✅ User Service
1. **JWT 토큰 발급**
   - `JwtTokenProvider` - 토큰 생성/검증
   - `OAuth2LoginSuccessHandler` - 로그인 성공 시 JWT 발급
   - `/login/success` - 토큰 정보 반환

2. **사용자 API**
   - `UserController` - X-User-Id 헤더로 사용자 인증
   - `GET /api/v1/users/me` - 내 정보 조회
   - `GET /api/v1/users/{userId}` - 특정 사용자 조회

### ✅ API Gateway
1. **JWT 검증 필터**
   - `AuthenticationHeaderFilter` - JWT 파싱 및 검증
   - X-User-Id 헤더 추가

2. **라우팅 설정**
   - `/api/v1/auth/**` → User Service (JWT 검증 제외)
   - `/api/v1/users/**` → User Service (JWT 검증 필요)

3. **CORS 설정**
   - Flutter 웹 클라이언트 허용

## 🚀 테스트 시나리오

### A. API Gateway를 통한 정상 플로우

#### 1단계: 로그인 & 토큰 받기
```bash
# 브라우저에서 접속
http://localhost:8081

# Google 로그인 완료 후 /login/success로 리디렉션
# 응답 예시:
{
  "message": "Login successful",
  "user": {
    "sub": "1234567890",
    "name": "홍길동",
    "email": "hong@gmail.com"
  },
  "tokens": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 86400
  }
}
```

#### 2단계: API Gateway를 통해 내 정보 조회
```bash
# 토큰을 헤더에 포함하여 요청
curl -X GET http://localhost:8080/api/v1/users/me \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# API Gateway 처리:
# 1. JWT 검증
# 2. userId 추출 (예: 1)
# 3. X-User-Id: 1 헤더 추가
# 4. User Service로 프록시

# User Service 응답:
{
  "id": 1,
  "googleId": "1234567890",
  "email": "hong@gmail.com",
  "name": "홍길동",
  "picture": "https://...",
  "displayName": "홍길동",
  "role": "USER",
  "status": "ACTIVE",
  "createdAt": "2025-10-16T10:30:00",
  "updatedAt": "2025-10-16T10:30:00"
}
```

### B. 직접 테스트 (API Gateway 없이)

```bash
# User Service에 직접 요청
# X-User-Id 헤더를 직접 추가
curl -X GET http://localhost:8081/api/v1/users/me \
  -H "X-User-Id: 1"

# 동일한 응답
{
  "id": 1,
  "googleId": "1234567890",
  ...
}
```

## 🔑 JWT 시크릿 키 관리

**중요:** User Service와 API Gateway가 **동일한 시크릿 키**를 사용해야 합니다!

### User Service (application-local.yml)
```yaml
jwt:
  secret: uniplan-jwt-secret-key-minimum-256-bits-for-local-development
  expiration: 86400000      # 24시간
  refresh-expiration: 604800000  # 7일
```

### API Gateway (application-local.yml)
```yaml
jwt:
  secret: uniplan-jwt-secret-key-minimum-256-bits-for-local-development
```

**운영 환경:**
```bash
# 환경 변수로 설정
export JWT_SECRET="your-production-secret-key-256-bits-minimum"
```

## 📝 API Gateway 필터 적용 방법

### 방법 1: 특정 경로에만 적용 (권장)
```yaml
routes:
  - id: user-service-protected
    uri: http://localhost:8081
    predicates:
      - Path=/api/v1/users/**
    filters:
      - AuthenticationHeaderFilter  # JWT 검증 필요
      
  - id: user-service-public
    uri: http://localhost:8081
    predicates:
      - Path=/api/v1/auth/**
    # 필터 없음 (로그인은 JWT 불필요)
```

### 방법 2: 전역 필터로 적용
```yaml
default-filters:
  - AuthenticationHeaderFilter
```

## ⚠️ 주의사항

### 1. 토큰 저장 위치 (프론트엔드)
- ✅ **권장:** `localStorage` 또는 `sessionStorage`
- ⚠️ **주의:** XSS 공격 가능성 → Content Security Policy 설정 필요
- 🔒 **대안:** HttpOnly 쿠키 (CSRF 토큰 필요)

### 2. HTTPS 필수
- 로컬: HTTP 허용
- 운영: **반드시 HTTPS** (토큰 탈취 방지)

### 3. 토큰 갱신
- Access Token 만료 시 Refresh Token으로 재발급
- Refresh Token API 구현 필요 (향후 작업)

## 🧪 Postman 테스트 가이드

### 1. 로그인
```
GET http://localhost:8081/login/success
(브라우저에서 Google 로그인 후)

→ accessToken 복사
```

### 2. API Gateway를 통한 요청
```
GET http://localhost:8080/api/v1/users/me
Headers:
  Authorization: Bearer {복사한 accessToken}
```

### 3. User Service 직접 요청 (테스트용)
```
GET http://localhost:8081/api/v1/users/me
Headers:
  X-User-Id: 1
```

## 📊 에러 처리

### 401 Unauthorized
```json
{
  "status": 401,
  "message": "Missing or invalid Authorization header"
}
```

**원인:**
- Authorization 헤더 누락
- Bearer 접두사 누락
- JWT 토큰 형식 오류
- 토큰 만료
- 잘못된 서명

### 403 Forbidden
```json
{
  "status": 403,
  "message": "Insufficient permissions"
}
```

**원인:**
- 권한 부족 (향후 역할 기반 인증 추가 시)

## 🎓 핵심 개념 정리

### Q: API Gateway를 안 쓰면?
**A:** User Service에 직접 요청하되, `X-User-Id` 헤더를 **수동으로 추가**해야 합니다.
```bash
curl -H "X-User-Id: 1" http://localhost:8081/api/v1/users/me
```

### Q: API Gateway를 쓰면?
**A:** JWT 토큰만 보내면 Gateway가 자동으로 `X-User-Id` 헤더를 추가합니다.
```bash
curl -H "Authorization: Bearer {token}" http://localhost:8080/api/v1/users/me
```

### Q: 왜 X-User-Id를 전달하나요?
**A:** 
- User Service는 JWT 검증 로직이 없음 (단순화)
- API Gateway가 중앙에서 JWT 검증 (DRY 원칙)
- 각 서비스는 X-User-Id만 신뢰하면 됨 (빠름)

## 🚀 다음 단계

- [ ] API Gateway에 필터 활성화
- [ ] Refresh Token API 구현
- [ ] 토큰 블랙리스트 (로그아웃 시)
- [ ] Rate Limiting (과도한 요청 방지)
- [ ] API 문서 Swagger에 JWT 테스트 추가

