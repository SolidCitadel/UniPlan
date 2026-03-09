# 보안 리뷰 체크리스트 (UniPlan)

code-reviewer agent가 참조하는 보안 취약점 검토 기준.
Spring Boot 백엔드와 Next.js 프론트엔드 특화.

## 10가지 보안 체크리스트

### 1. Secrets (CRITICAL)

```java
// ❌ 금지: 하드코딩된 비밀
String secret = "mySecretKey123";
String dbPassword = "password";

// ✅ 환경변수에서 로드
@Value("${JWT_SECRET}")
private String jwtSecret;
```

- [ ] JWT 시크릿, DB 비밀번호, API 키 하드코딩 없는지
- [ ] `.env` 파일 git 추가 없는지
- [ ] `application.yml`에 실제 비밀값 없는지 (local.yml 제외)

### 2. SQL Injection (CRITICAL)

```java
// ❌ 금지: 문자열 연결 쿼리
String query = "SELECT * FROM users WHERE email = '" + email + "'";

// ✅ 파라미터 바인딩 (JPA 기본 보장)
@Query("SELECT u FROM User u WHERE u.email = :email")
Optional<User> findByEmail(@Param("email") String email);
```

- [ ] Native 쿼리에서 사용자 입력 직접 연결 없는지
- [ ] JPQL 파라미터 바인딩 사용하는지

### 3. XSS (Cross-Site Scripting)

```typescript
// ❌ 금지 (Next.js)
<div dangerouslySetInnerHTML={{ __html: userInput }} />

// ✅ 일반 텍스트 렌더링
<div>{userInput}</div>
```

- [ ] `dangerouslySetInnerHTML` 사용 없는지
- [ ] 사용자 입력이 HTML로 렌더링되지 않는지

### 4. CSRF

Spring Boot REST API (stateless):
- JWT 사용 시 CSRF 비활성화 가능 (stateless 세션)
- [ ] `csrf().disable()` 적용 여부 확인 (stateless API는 OK)

### 5. 인증/인가 (CRITICAL)

```java
// ✅ 리소스 소유자 검증
public TimetableResponse get(Long id, Long requestUserId) {
    Timetable timetable = findById(id);
    if (!timetable.getUserId().equals(requestUserId)) {
        throw new ForbiddenException("접근 권한이 없습니다.");
    }
    return TimetableResponse.from(timetable);
}
```

- [ ] 타인 리소스 접근 방지 로직 있는지
- [ ] `X-User-Id` 헤더로만 userId 결정하는지 (요청 바디에서 받지 않는지)
- [ ] 인증 불필요 경로가 CLAUDE.md 정의와 일치하는지

### 6. Rate Limiting

```java
// Bucket4j 기반 Rate Limiting (Gateway 레벨)
@RateLimiter(name = "default", fallbackMethod = "rateLimitFallback")
public ResponseEntity<...> endpoint(...) { ... }
```

- [ ] 공개 엔드포인트에 Rate Limiting 적용 여부
- [ ] 로그인 엔드포인트 brute-force 방지

### 7. 민감 정보 노출

```java
// ❌ 금지
log.debug("User password: {}", user.getPassword());
log.info("JWT token: {}", token);

// ✅ 민감 정보 마스킹
log.debug("User authenticated: {}", userId);
```

- [ ] 로그에 비밀번호, 토큰, 개인정보 출력 없는지
- [ ] 에러 응답에 스택트레이스 노출 없는지
- [ ] 500 에러 응답에 내부 구현 정보 없는지

### 8. 의존성 취약점

```bash
# OWASP Dependency Check (verification-loop Phase 4)
./gradlew dependencyCheckAnalyze
```

- [ ] CRITICAL/HIGH CVE 없는지
- [ ] 최신 보안 패치 버전 사용하는지

### 9. 입력 검증 (Bean Validation)

구현 패턴은 **springboot-security skill** 참조.

- [ ] Controller에 `@Valid` 적용
- [ ] DTO에 적절한 제약 조건 (`@NotBlank`, `@Size`, `@Email`)
- [ ] 검증 실패 시 422 반환

### 10. 데이터 노출 최소화

- [ ] Response DTO에 불필요한 필드 없는지 (비밀번호, 내부 ID 등)
- [ ] CORS 설정이 특정 도메인만 허용하는지 (전체 허용 `*` 금지)

## Pre-deployment 체크리스트

- [ ] 모든 CRITICAL 이슈 해결
- [ ] 의존성 CVE 스캔 통과
- [ ] 하드코딩 시크릿 없음
- [ ] 로그에 민감 정보 없음
- [ ] 인증/인가 로직 검증 완료
