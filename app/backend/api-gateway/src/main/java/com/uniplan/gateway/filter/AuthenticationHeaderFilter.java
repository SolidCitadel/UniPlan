package com.uniplan.gateway.filter;

import com.uniplan.common.header.SecurityHeaderConstants;
import com.uniplan.common.jwt.JwtClaims;
import com.uniplan.common.jwt.JwtConstants;
import com.uniplan.common.jwt.JwtTokenUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * JWT 토큰 검증 및 사용자 정보 추출 필터
 * Authorization: Bearer {token} 헤더에서 JWT 추출 → 검증 → X-User-Id, X-User-Email, X-User-Role 헤더 추가
 * 
 * JWT 파싱 로직은 common-lib의 JwtTokenUtil을 사용하여 중앙화
 */
@Component
@Slf4j
public class AuthenticationHeaderFilter extends AbstractGatewayFilterFactory<AuthenticationHeaderFilter.Config> {

    private final JwtTokenUtil jwtTokenUtil;

    public AuthenticationHeaderFilter(@Value("${jwt.secret}") String secret) {
        super(Config.class);
        this.jwtTokenUtil = new JwtTokenUtil(secret);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            // 1. Authorization 헤더 추출
            String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);

            if (authHeader == null || !authHeader.startsWith(JwtConstants.BEARER_PREFIX)) {
                log.warn("Authorization 헤더가 없거나 형식이 잘못되었습니다.");
                return onError(exchange, "Missing or invalid Authorization header", HttpStatus.UNAUTHORIZED);
            }

            // 2. Bearer 토큰 추출
            String token = JwtTokenUtil.extractBearerToken(authHeader);
            
            if (token == null) {
                log.warn("Bearer 토큰 추출 실패");
                return onError(exchange, "Invalid Authorization header format", HttpStatus.UNAUTHORIZED);
            }

            try {
                // 3. JWT 검증 및 사용자 정보 추출 (common-lib 사용)
                JwtClaims jwtClaims = jwtTokenUtil.extractJwtClaims(token);

                log.info("JWT 검증 성공 - userId: {}, email: {}, role: {}", 
                        jwtClaims.getUserId(), jwtClaims.getEmail(), jwtClaims.getRole());

                // 4. X-User-Id, X-User-Email, X-User-Role 헤더 추가하여 다운스트림 서비스로 전달
                ServerWebExchange modifiedExchange = exchange.mutate()
                        .request(request -> request
                                .header(SecurityHeaderConstants.X_USER_ID, String.valueOf(jwtClaims.getUserId()))
                                .header(SecurityHeaderConstants.X_USER_EMAIL, jwtClaims.getEmailOrEmpty())
                                .header(SecurityHeaderConstants.X_USER_ROLE, jwtClaims.getRoleOrDefault()))
                        .build();

                return chain.filter(modifiedExchange);

            } catch (Exception e) {
                log.error("JWT 검증 실패: {}", e.getMessage());
                return onError(exchange, "Invalid JWT token", HttpStatus.UNAUTHORIZED);
            }
        };
    }

    /**
     * 에러 응답 생성
     */
    private Mono<Void> onError(ServerWebExchange exchange, String message, HttpStatus status) {
        exchange.getResponse().setStatusCode(status);
        return exchange.getResponse().setComplete();
    }

    public static class Config {
        // 설정이 필요한 경우 여기에 추가
    }
}
