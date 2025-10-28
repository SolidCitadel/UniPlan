package com.uniplan.gateway.integration;

import com.uniplan.common.header.SecurityHeaderConstants;
import com.uniplan.common.jwt.JwtClaims;
import com.uniplan.common.jwt.JwtConstants;
import com.uniplan.common.jwt.JwtTokenUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.cloud.contract.wiremock.AutoConfigureWireMock;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.reactive.server.WebTestClient;

import static com.github.tomakehurst.wiremock.client.WireMock.*;

/**
 * API Gateway 통합 테스트
 * - 라우팅 테스트
 * - Path Rewriting 테스트
 * - JWT 검증 통합 테스트
 * - 에러 처리 테스트
 *
 * WireMock을 사용하여 다운스트림 서비스를 모킹
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureWireMock(port = 0)
@ActiveProfiles("test")
@DisplayName("API Gateway 통합 테스트")
class GatewayIntegrationTest {

    @Autowired
    private WebTestClient webTestClient;

    @Value("${jwt.secret}")
    private String jwtSecret;

    private JwtTokenUtil jwtTokenUtil;

    private static final Long TEST_USER_ID = 1L;
    private static final String TEST_EMAIL = "test@example.com";
    private static final String TEST_ROLE = "USER";

    @BeforeEach
    void setUp() {
        jwtTokenUtil = new JwtTokenUtil(jwtSecret);
        resetAllRequests();
    }

    // ========== 라우팅 및 Path Rewriting 테스트 ==========

    @Test
    @DisplayName("인증 없는 라우트: /api/v1/auth/login → /auth/login (path rewriting)")
    void testAuthRoutePathRewriting() {
        // Given: WireMock stub 설정
        stubFor(post(urlEqualTo("/auth/login"))
                .willReturn(aResponse()
                        .withStatus(200)
                        .withHeader("Content-Type", "application/json")
                        .withBody("{\"accessToken\": \"token123\"}")));

        // When & Then: /api/v1/auth/login 요청 → /auth/login으로 rewrite
        webTestClient.post()
                .uri("/api/v1/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue("{\"email\":\"test@test.com\",\"password\":\"password\"}")
                .exchange()
                .expectStatus().isOk();

        // Verify: 다운스트림 서비스가 /auth/login으로 호출되었는지 확인
        verify(postRequestedFor(urlEqualTo("/auth/login")));
    }

    @Test
    @DisplayName("인증 필요 라우트: /api/v1/users/me → /users/me (path rewriting + JWT)")
    void testProtectedRoutePathRewriting() {
        // Given: 유효한 JWT 토큰
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        // WireMock stub 설정 - X-User-* 헤더 확인
        stubFor(get(urlEqualTo("/users/me"))
                .withHeader(SecurityHeaderConstants.X_USER_ID, equalTo(String.valueOf(TEST_USER_ID)))
                .withHeader(SecurityHeaderConstants.X_USER_EMAIL, equalTo(TEST_EMAIL))
                .withHeader(SecurityHeaderConstants.X_USER_ROLE, equalTo(TEST_ROLE))
                .willReturn(aResponse()
                        .withStatus(200)
                        .withHeader("Content-Type", "application/json")
                        .withBody("{\"id\": 1, \"email\": \"test@example.com\"}")));

        // When & Then: /api/v1/users/me 요청 → /users/me로 rewrite
        webTestClient.get()
                .uri("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .exchange()
                .expectStatus().isOk();

        // Verify: X-User-* 헤더가 추가되어 다운스트림 서비스로 전달되었는지 확인
        verify(getRequestedFor(urlEqualTo("/users/me"))
                .withHeader(SecurityHeaderConstants.X_USER_ID, equalTo(String.valueOf(TEST_USER_ID)))
                .withHeader(SecurityHeaderConstants.X_USER_EMAIL, equalTo(TEST_EMAIL))
                .withHeader(SecurityHeaderConstants.X_USER_ROLE, equalTo(TEST_ROLE)));
    }

    @Test
    @DisplayName("Catalog Service 라우팅: /api/v1/courses → /courses (path rewriting + JWT)")
    void testCatalogServiceRouting() {
        // Given: 유효한 JWT 토큰
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        // WireMock stub
        stubFor(get(urlPathMatching("/courses.*"))
                .willReturn(aResponse()
                        .withStatus(200)
                        .withHeader("Content-Type", "application/json")
                        .withBody("[]")));

        // When & Then: /api/v1/courses 요청 → /courses로 rewrite
        webTestClient.get()
                .uri("/api/v1/courses?year=2025")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .exchange()
                .expectStatus().isOk();

        // Verify
        verify(getRequestedFor(urlPathMatching("/courses.*"))
                .withQueryParam("year", equalTo("2025")));
    }

    // ========== JWT 검증 테스트 ==========

    @Test
    @DisplayName("유효한 JWT로 보호된 리소스 접근 성공")
    void testValidJwtAccessProtectedResource() {
        // Given: 유효한 JWT 토큰
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        // WireMock stub
        stubFor(get(urlEqualTo("/users/me"))
                .willReturn(aResponse().withStatus(200)));

        // When & Then: 접근 성공
        webTestClient.get()
                .uri("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .exchange()
                .expectStatus().isOk();
    }

    @Test
    @DisplayName("JWT 없이 보호된 리소스 접근 시 401 Unauthorized")
    void testNoJwtAccessProtectedResource() {
        // When & Then: 401 Unauthorized
        webTestClient.get()
                .uri("/api/v1/users/me")
                .exchange()
                .expectStatus().isUnauthorized();

        // Verify: 다운스트림 서비스가 호출되지 않았는지 확인
        verify(0, getRequestedFor(urlEqualTo("/users/me")));
    }

    @Test
    @DisplayName("유효하지 않은 JWT로 보호된 리소스 접근 시 401 Unauthorized")
    void testInvalidJwtAccessProtectedResource() {
        // Given: 유효하지 않은 JWT
        String invalidToken = "invalid.jwt.token";

        // When & Then: 401 Unauthorized
        webTestClient.get()
                .uri("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + invalidToken)
                .exchange()
                .expectStatus().isUnauthorized();

        // Verify: 다운스트림 서비스가 호출되지 않았는지 확인
        verify(0, getRequestedFor(urlEqualTo("/users/me")));
    }

    @Test
    @DisplayName("만료된 JWT로 보호된 리소스 접근 시 401 Unauthorized")
    void testExpiredJwtAccessProtectedResource() {
        // Given: 만료된 JWT (-1초)
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String expiredToken = jwtTokenUtil.createAccessToken(claims, -1000L);

        // When & Then: 401 Unauthorized
        webTestClient.get()
                .uri("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + expiredToken)
                .exchange()
                .expectStatus().isUnauthorized();
    }

    // ========== 에러 처리 테스트 ==========

    @Test
    @DisplayName("존재하지 않는 경로 접근 시 404 Not Found")
    void testNonExistentRoute() {
        // Given: 유효한 JWT
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        // When & Then: 404 Not Found
        webTestClient.get()
                .uri("/api/v1/non-existent-path")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .exchange()
                .expectStatus().isNotFound();
    }

    @Test
    @DisplayName("다운스트림 서비스 에러 시 에러 코드 전달")
    void testDownstreamServiceError() {
        // Given: 유효한 JWT
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        // WireMock stub - 다운스트림 서비스가 500 에러 반환
        stubFor(get(urlEqualTo("/users/me"))
                .willReturn(aResponse()
                        .withStatus(500)
                        .withBody("Internal Server Error")));

        // When & Then: 500 에러가 그대로 전달됨
        webTestClient.get()
                .uri("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .exchange()
                .expectStatus().is5xxServerError();
    }

    @Test
    @DisplayName("다운스트림 서비스 지연 응답 처리")
    void testDownstreamServiceDelay() {
        // Given: 유효한 JWT
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        // WireMock stub - 짧은 지연 (1초)
        stubFor(get(urlEqualTo("/users/delay"))
                .willReturn(aResponse()
                        .withStatus(200)
                        .withHeader("Content-Type", "application/json")
                        .withBody("{\"message\": \"delayed response\"}")
                        .withFixedDelay(1000))); // 1초 지연

        // When & Then: 지연되지만 정상 응답
        webTestClient.mutate()
                .responseTimeout(java.time.Duration.ofSeconds(5))
                .build()
                .get()
                .uri("/api/v1/users/delay")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .exchange()
                .expectStatus().isOk();
    }

    // ========== CORS 테스트 ==========

    @Test
    @DisplayName("CORS Preflight 요청 처리")
    void testCorsPreflight() {
        // When & Then: OPTIONS 요청
        webTestClient.options()
                .uri("/api/v1/users/me")
                .header(HttpHeaders.ORIGIN, "http://localhost:3000")
                .header(HttpHeaders.ACCESS_CONTROL_REQUEST_METHOD, "GET")
                .exchange()
                .expectStatus().isOk()
                .expectHeader().valueEquals(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "http://localhost:3000")
                .expectHeader().exists(HttpHeaders.ACCESS_CONTROL_ALLOW_METHODS);
    }
}