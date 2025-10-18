# JWT 로직 Common-Lib 중앙화 리팩토링

## 🎯 리팩토링 목적

JWT 토큰 파싱 및 생성 로직을 `common-lib`로 중앙화하여:
- **JWT 구조 변경 시 의존성 격리**: JWT Claims 스키마 변경 시 한 곳만 수정
- **DRY 원칙 적용**: 중복 코드 제거
- **일관성 보장**: 모든 서비스에서 동일한 JWT 처리 로직 사용

## 📦 새로 추가된 Common-Lib 구조

```
common-lib/
└── src/main/java/com/uniplan/common/
    ├── jwt/
    │   ├── JwtClaims.java           # JWT Claims DTO
    │   ├── JwtTokenUtil.java         # JWT 파싱/생성 유틸
    │   └── JwtConstants.java         # JWT 관련 상수
    └── header/
        └── SecurityHeaderConstants.java  # 마이크로서비스 간 보안 헤더 상수
```

### JwtClaims.java
JWT의 Claims를 표현하는 DTO 클래스:
```java
@Getter
@Builder
public class JwtClaims {
    private Long userId;
    private String email;
    private String role;
    
    // JWT Claims → JwtClaims 변환
    public static JwtClaims fromClaims(Claims claims)
    
    // JwtClaims → JWT Claims 변환
    public void applyClaims(JwtBuilder builder)
}
```

**핵심 기능:**
- JWT 구조를 이 클래스에서만 정의
- 변환 로직 캡슐화
- 기본값 처리 메서드 제공 (`getEmailOrEmpty()`, `getRoleOrDefault()`)

### JwtTokenUtil.java
JWT 토큰 생성 및 파싱을 담당하는 유틸리티 클래스:
```java
public class JwtTokenUtil {
    // Access Token 생성
    public String createAccessToken(JwtClaims jwtClaims, long expirationMillis)
    
    // Refresh Token 생성
    public String createRefreshToken(Long userId, long expirationMillis)
    
    // JWT 파싱 및 Claims 추출
    public Claims parseClaims(String token)
    
    // JWT에서 JwtClaims 객체 추출
    public JwtClaims extractJwtClaims(String token)
    
    // JWT 유효성 검증
    public boolean validateToken(String token)
    
    // Bearer 토큰 추출
    public static String extractBearerToken(String authorizationHeader)
}
```

### JwtConstants.java
JWT 관련 상수 정의:
```java
public class JwtConstants {
    public static final String CLAIM_EMAIL = "email";
    public static final String CLAIM_ROLE = "role";
    public static final String CLAIM_TYPE = "type";
    
    public static final String TOKEN_TYPE_ACCESS = "access";
    public static final String TOKEN_TYPE_REFRESH = "refresh";
    
    public static final String AUTHORIZATION_HEADER = "Authorization";
    public static final String BEARER_PREFIX = "Bearer ";
}
```

### SecurityHeaderConstants.java
마이크로서비스 간 통신에 사용되는 보안 헤더:
```java
public class SecurityHeaderConstants {
    public static final String X_USER_ID = "X-User-Id";
    public static final String X_USER_EMAIL = "X-User-Email";
    public static final String X_USER_ROLE = "X-User-Role";
}
```

## 🔄 변경 사항

### 1. Common-Lib 설정

**build.gradle.kts:**
```kotlin
dependencies {
    // JWT 관련 의존성
    implementation("io.jsonwebtoken:jjwt-api:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.3")
    
    // Lombok
    compileOnly("org.projectlombok:lombok:1.18.34")
    annotationProcessor("org.projectlombok:lombok:1.18.34")
}
```

### 2. API Gateway 리팩토링

**변경 전 (AuthenticationHeaderFilter.java):**
```java
// JWT 구조 하드코딩
String userId = claims.getSubject();
String email = claims.get("email", String.class);
String role = claims.get("role", String.class);

// 헤더 이름 하드코딩
.header("X-User-Id", userId)
.header("X-User-Email", email != null ? email : "")
.header("X-User-Role", role != null ? role : "USER")
```

**변경 후:**
```java
// common-lib 사용
JwtClaims jwtClaims = jwtTokenUtil.extractJwtClaims(token);

// 상수 사용
.header(SecurityHeaderConstants.X_USER_ID, String.valueOf(jwtClaims.getUserId()))
.header(SecurityHeaderConstants.X_USER_EMAIL, jwtClaims.getEmailOrEmpty())
.header(SecurityHeaderConstants.X_USER_ROLE, jwtClaims.getRoleOrDefault())
```

**장점:**
- JWT Claims 필드명 변경 시 `JwtClaims`만 수정
- 헤더 이름 변경 시 `SecurityHeaderConstants`만 수정
- 기본값 처리 로직 재사용

### 3. User Service 리팩토링

**변경 전 (JwtTokenProvider.java):**
```java
// JWT 생성 로직 직접 작성
return Jwts.builder()
    .subject(String.valueOf(userId))
    .claim("email", email)
    .claim("role", role)
    .issuedAt(now)
    .expiration(expiryDate)
    .signWith(secretKey, Jwts.SIG.HS256)
    .compact();
```

**변경 후:**
```java
// common-lib 사용
JwtClaims jwtClaims = JwtClaims.builder()
    .userId(userId)
    .email(email)
    .role(role)
    .build();

return jwtTokenUtil.createAccessToken(jwtClaims, accessTokenExpiration);
```

**장점:**
- JWT 생성 로직 중앙화
- Claims 구조 변경 시 한 곳만 수정
- 테스트 용이성 증가

### 4. 의존성 추가

**user-service/build.gradle.kts:**
```kotlin
dependencies {
    // ...existing dependencies...
    
    // Common Library (JWT 유틸리티 포함)
    implementation(project(":common-lib"))
}
```

## ✅ 테스트

모든 서비스가 성공적으로 빌드되었습니다:

```bash
# Common-Lib 빌드
./gradlew :common-lib:clean :common-lib:build
# BUILD SUCCESSFUL

# API Gateway 빌드
./gradlew :api-gateway:clean :api-gateway:build -x test
# BUILD SUCCESSFUL

# User Service 빌드
./gradlew :user-service:clean :user-service:build -x test
# BUILD SUCCESSFUL
```

## 📊 리팩토링 효과

### Before: JWT 구조가 변경되면?
예: `role` → `userRole`로 변경

❌ **수정 필요한 파일:**
1. `api-gateway/AuthenticationHeaderFilter.java` - 파싱 로직
2. `user-service/JwtTokenProvider.java` - 생성 로직
3. 향후 추가되는 모든 서비스의 JWT 처리 코드

### After: JWT 구조가 변경되면?
예: `role` → `userRole`로 변경

✅ **수정 필요한 파일:**
1. `common-lib/JwtClaims.java` - 단 한 곳!

```java
// JwtClaims.java에서만 수정
public static JwtClaims fromClaims(Claims claims) {
    return JwtClaims.builder()
            .userId(parseLongSafely(claims.getSubject()))
            .email(claims.get(JwtConstants.CLAIM_EMAIL, String.class))
            .role(claims.get("userRole", String.class))  // 이것만 변경!
            .build();
}

public void applyClaims(JwtBuilder builder) {
    builder.subject(String.valueOf(userId))
           .claim(JwtConstants.CLAIM_EMAIL, email)
           .claim("userRole", role);  // 이것만 변경!
}
```

모든 서비스는 자동으로 새로운 구조 사용! 🎉

## 🚀 향후 확장성

### Catalog Service 추가 시
JWT 파싱이 필요하다면:
```java
// Catalog Service
implementation(project(":common-lib"))

// 바로 사용 가능!
JwtClaims claims = jwtTokenUtil.extractJwtClaims(token);
Long userId = claims.getUserId();
```

### JWT Claims 필드 추가 시
예: `department` 필드 추가

**1단계: JwtClaims.java 수정**
```java
@Getter
@Builder
public class JwtClaims {
    private Long userId;
    private String email;
    private String role;
    private String department;  // 추가!
    
    public static JwtClaims fromClaims(Claims claims) {
        return JwtClaims.builder()
                .userId(parseLongSafely(claims.getSubject()))
                .email(claims.get(JwtConstants.CLAIM_EMAIL, String.class))
                .role(claims.get(JwtConstants.CLAIM_ROLE, String.class))
                .department(claims.get("department", String.class))  // 추가!
                .build();
    }
    
    public void applyClaims(JwtBuilder builder) {
        builder.subject(String.valueOf(userId))
               .claim(JwtConstants.CLAIM_EMAIL, email)
               .claim(JwtConstants.CLAIM_ROLE, role)
               .claim("department", department);  // 추가!
    }
}
```

**2단계: 끝!**
- API Gateway: 자동으로 새 필드 파싱
- User Service: 토큰 생성 시 자동 포함
- 다른 서비스: 필요시 `claims.getDepartment()` 호출

## 🎓 핵심 개념

### 의존성 격리 (Dependency Isolation)
```
Before: API Gateway ──직접 의존──> JWT 구조
        User Service ──직접 의존──> JWT 구조

After:  API Gateway ──의존──> JwtClaims (common-lib)
        User Service ──의존──> JwtClaims (common-lib)
        JwtClaims ──캡슐화──> JWT 구조
```

### 단일 책임 원칙 (Single Responsibility)
- **JwtClaims**: JWT 구조 정의
- **JwtTokenUtil**: JWT 생성/파싱 로직
- **JwtConstants**: 상수 관리
- **API Gateway**: 요청 라우팅 및 JWT 검증
- **User Service**: 사용자 관리 및 JWT 발급

### DRY 원칙 (Don't Repeat Yourself)
Before:
```
JWT 파싱 로직: API Gateway에 1번, User Service에 1번 (중복!)
JWT 생성 로직: User Service에만 (향후 다른 서비스에서도 필요 시 중복 가능)
```

After:
```
JWT 파싱 로직: common-lib에 1번 (모든 서비스 재사용)
JWT 생성 로직: common-lib에 1번 (모든 서비스 재사용)
```

## 📝 결론

이번 리팩토링으로:
1. ✅ JWT 구조 변경 시 `common-lib`만 수정하면 됨
2. ✅ 모든 서비스에서 일관된 JWT 처리
3. ✅ 코드 중복 제거 (DRY 원칙)
4. ✅ 새로운 마이크로서비스 추가 시 즉시 JWT 기능 사용 가능
5. ✅ 테스트 및 유지보수 용이성 향상

**마이크로서비스 아키텍처에서 공통 로직은 반드시 중앙화하여 관리해야 합니다!** 🎯

