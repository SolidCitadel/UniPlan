package com.uniplan.gateway.unit.filter;

import com.uniplan.common.header.SecurityHeaderConstants;
import com.uniplan.common.jwt.JwtClaims;
import com.uniplan.common.jwt.JwtConstants;
import com.uniplan.common.jwt.JwtTokenUtil;
import com.uniplan.gateway.filter.AuthenticationHeaderFilter;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * AuthenticationHeaderFilter 단위 테스트
 * - JWT 토큰 검증
 * - 사용자 정보 헤더 추가
 * - 에러 처리
 */
@DisplayName("AuthenticationHeaderFilter 테스트")
class AuthenticationHeaderFilterTest {

    private AuthenticationHeaderFilter filter;
    private JwtTokenUtil jwtTokenUtil;
    private GatewayFilterChain mockChain;

    private static final String JWT_SECRET = "test-jwt-secret-key-minimum-256-bits-for-testing-purposes-only";
    private static final Long TEST_USER_ID = 1L;
    private static final String TEST_EMAIL = "test@example.com";
    private static final String TEST_ROLE = "USER";

    @BeforeEach
    void setUp() {
        filter = new AuthenticationHeaderFilter(JWT_SECRET);
        jwtTokenUtil = new JwtTokenUtil(JWT_SECRET);
        mockChain = mock(GatewayFilterChain.class);
    }

    @Test
    @DisplayName("유효한 JWT 토큰으로 요청 시 사용자 헤더 추가 성공")
    void testValidJwtToken_ShouldAddUserHeaders() {
        // Given: 유효한 JWT 토큰 생성
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + validToken)
                .build();

        ServerWebExchange exchange = MockServerWebExchange.from(request);

        // Mock chain to capture modified exchange
        when(mockChain.filter(any())).thenAnswer(invocation -> {
            ServerWebExchange modifiedExchange = invocation.getArgument(0);

            // Then: X-User-* 헤더가 추가되었는지 확인
            String userId = modifiedExchange.getRequest().getHeaders()
                    .getFirst(SecurityHeaderConstants.X_USER_ID);
            String email = modifiedExchange.getRequest().getHeaders()
                    .getFirst(SecurityHeaderConstants.X_USER_EMAIL);
            String role = modifiedExchange.getRequest().getHeaders()
                    .getFirst(SecurityHeaderConstants.X_USER_ROLE);

            assertThat(userId).isEqualTo(String.valueOf(TEST_USER_ID));
            assertThat(email).isEqualTo(TEST_EMAIL);
            assertThat(role).isEqualTo(TEST_ROLE);

            return Mono.empty();
        });

        // When: 필터 실행
        GatewayFilter gatewayFilter = filter.apply(new AuthenticationHeaderFilter.Config());
        Mono<Void> result = gatewayFilter.filter(exchange, mockChain);

        // Then: 성공적으로 완료
        StepVerifier.create(result)
                .verifyComplete();
    }

    @Test
    @DisplayName("Authorization 헤더가 없으면 401 Unauthorized")
    void testMissingAuthorizationHeader_ShouldReturn401() {
        // Given: Authorization 헤더 없는 요청
        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/users/me").build();
        ServerWebExchange exchange = MockServerWebExchange.from(request);

        // When: 필터 실행
        GatewayFilter gatewayFilter = filter.apply(new AuthenticationHeaderFilter.Config());
        Mono<Void> result = gatewayFilter.filter(exchange, mockChain);

        // Then: 401 Unauthorized
        StepVerifier.create(result)
                .verifyComplete();

        assertThat(exchange.getResponse().getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    @DisplayName("Bearer prefix가 없으면 401 Unauthorized")
    void testInvalidAuthorizationFormat_ShouldReturn401() {
        // Given: Bearer prefix 없는 토큰
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String validToken = jwtTokenUtil.createAccessToken(claims, 3600000L);

        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, validToken) // Bearer prefix 없음
                .build();

        ServerWebExchange exchange = MockServerWebExchange.from(request);

        // When: 필터 실행
        GatewayFilter gatewayFilter = filter.apply(new AuthenticationHeaderFilter.Config());
        Mono<Void> result = gatewayFilter.filter(exchange, mockChain);

        // Then: 401 Unauthorized
        StepVerifier.create(result)
                .verifyComplete();

        assertThat(exchange.getResponse().getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    @DisplayName("유효하지 않은 JWT 토큰으로 요청 시 401 Unauthorized")
    void testInvalidJwtToken_ShouldReturn401() {
        // Given: 유효하지 않은 JWT 토큰
        String invalidToken = "invalid.jwt.token";

        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + invalidToken)
                .build();

        ServerWebExchange exchange = MockServerWebExchange.from(request);

        // When: 필터 실행
        GatewayFilter gatewayFilter = filter.apply(new AuthenticationHeaderFilter.Config());
        Mono<Void> result = gatewayFilter.filter(exchange, mockChain);

        // Then: 401 Unauthorized
        StepVerifier.create(result)
                .verifyComplete();

        assertThat(exchange.getResponse().getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    @DisplayName("만료된 JWT 토큰으로 요청 시 401 Unauthorized")
    void testExpiredJwtToken_ShouldReturn401() {
        // Given: 만료된 JWT 토큰 생성 (만료 시간 -1초)
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String expiredToken = jwtTokenUtil.createAccessToken(claims, -1000L);

        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + expiredToken)
                .build();

        ServerWebExchange exchange = MockServerWebExchange.from(request);

        // When: 필터 실행
        GatewayFilter gatewayFilter = filter.apply(new AuthenticationHeaderFilter.Config());
        Mono<Void> result = gatewayFilter.filter(exchange, mockChain);

        // Then: 401 Unauthorized
        StepVerifier.create(result)
                .verifyComplete();

        assertThat(exchange.getResponse().getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    @DisplayName("잘못된 시크릿으로 생성된 JWT 토큰으로 요청 시 401 Unauthorized")
    void testWrongSecretJwtToken_ShouldReturn401() {
        // Given: 다른 시크릿으로 생성된 JWT 토큰
        JwtTokenUtil wrongJwtUtil = new JwtTokenUtil("wrong-secret-key-minimum-256-bits-for-testing-purposes-only");
        JwtClaims claims = JwtClaims.builder()
                .userId(TEST_USER_ID)
                .email(TEST_EMAIL)
                .role(TEST_ROLE)
                .build();
        String wrongToken = wrongJwtUtil.createAccessToken(claims, 3600000L);

        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/users/me")
                .header(HttpHeaders.AUTHORIZATION, JwtConstants.BEARER_PREFIX + wrongToken)
                .build();

        ServerWebExchange exchange = MockServerWebExchange.from(request);

        // When: 필터 실행
        GatewayFilter gatewayFilter = filter.apply(new AuthenticationHeaderFilter.Config());
        Mono<Void> result = gatewayFilter.filter(exchange, mockChain);

        // Then: 401 Unauthorized
        StepVerifier.create(result)
                .verifyComplete();

        assertThat(exchange.getResponse().getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }
}