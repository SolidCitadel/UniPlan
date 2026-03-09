# Spring Boot 보안 패턴 (UniPlan)

UniPlan Spring Boot 서비스의 보안 구현 패턴 및 가이드.

## JWT 인증 (Gateway 레벨)

UniPlan은 Gateway에서 JWT를 검증하고 내부 서비스에 헤더로 전달:

```java
// Gateway: JWT 검증 후 헤더 주입
// X-User-Id: {userId}
// X-User-Email: {userEmail}

// 내부 서비스: 헤더로 userId 수신 (재검증 불필요)
@GetMapping("/timetables")
public List<TimetableResponse> list(
    @RequestHeader("X-User-Id") Long userId
) { ... }
```

**패턴:**
- `OncePerRequestFilter` 로 JWT 검증 (Gateway 내)
- 내부 서비스는 `X-User-Id` 헤더만 신뢰
- stateless 세션: `SessionCreationPolicy.STATELESS`

## Security Config (내부 서비스)

```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            // stateless API → CSRF 불필요
            .csrf(csrf -> csrf.disable())
            // CORS: 특정 도메인만 허용
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            // 세션 미사용
            .sessionManagement(sm -> sm.sessionCreationPolicy(STATELESS))
            // deny by default: 명시적 허용만 통과
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/health").permitAll()
                .anyRequest().authenticated()
            )
            .build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowedOrigins(List.of("http://localhost:3000")); // 환경변수로 관리
        config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH"));
        config.setAllowedHeaders(List.of("*"));
        // ❌ config.setAllowedOrigins(List.of("*")); // 전체 허용 금지
        ...
    }
}
```

## 비밀번호 해시 (BCrypt)

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder(12); // cost factor 12
}

// 회원가입
String hashedPassword = passwordEncoder.encode(rawPassword);

// 로그인 검증
boolean matches = passwordEncoder.matches(rawPassword, hashedPassword);
```

**규칙:**
- BCrypt cost factor: 12 (보안과 성능 균형)
- 평문 비밀번호 저장 절대 금지
- 비밀번호 로그 출력 금지

## @PreAuthorize (메서드 레벨 인가)

```java
@Service
public class TimetableService {

    // 소유자만 접근 가능
    public TimetableResponse update(Long id, Long requestUserId, UpdateRequest request) {
        Timetable timetable = timetableRepository.findById(id)
            .orElseThrow(() -> new TimetableNotFoundException(id));

        if (!timetable.getUserId().equals(requestUserId)) {
            throw new ForbiddenException("수정 권한이 없습니다.");
        }

        timetable.update(request.name());
        return TimetableResponse.from(timetable);
    }
}
```

## Bean Validation

```java
public record CreateTimetableRequest(
    @NotBlank(message = "시간표 이름은 필수입니다")
    @Size(max = 100, message = "시간표 이름은 100자 이하여야 합니다")
    String name,

    @Email(message = "올바른 이메일 형식이 아닙니다")
    String email
) {}

@RestController
public class TimetableController {
    @PostMapping("/timetables")
    public ResponseEntity<TimetableResponse> create(
        @Valid @RequestBody CreateTimetableRequest request  // @Valid 필수
    ) { ... }
}
```

## Rate Limiting (Bucket4j)

```java
// Gateway 또는 서비스 레벨
@Bean
public Bucket loginBucket() {
    return Bucket.builder()
        .addLimit(Bandwidth.classic(5, Refill.greedy(5, Duration.ofMinutes(1))))
        .build();
}

// 로그인 엔드포인트에 적용 (brute-force 방지)
```

## Deny by Default 원칙

```java
// ✅ 명시적 허용만 통과
.authorizeHttpRequests(auth -> auth
    .requestMatchers("/api/v1/auth/**").permitAll()
    .requestMatchers("/api/v1/universities/**").permitAll()
    .anyRequest().authenticated()  // 나머지는 인증 필요
)

// ❌ 금지: 전체 허용 후 일부 차단
.authorizeHttpRequests(auth -> auth
    .anyRequest().permitAll()  // 위험
)
```

## 보안 Pre-release 체크리스트

- [ ] 모든 환경변수 `.env`에서 관리 (하드코딩 없음)
- [ ] CORS 특정 도메인만 허용
- [ ] BCrypt(12) 비밀번호 해시 적용
- [ ] 인증 필요 엔드포인트 `authenticated()` 설정
- [ ] 소유자 검증 로직 존재
- [ ] `@Valid` 입력 검증 적용
- [ ] 로그에 민감 정보 없음
- [ ] OWASP 의존성 스캔 통과
