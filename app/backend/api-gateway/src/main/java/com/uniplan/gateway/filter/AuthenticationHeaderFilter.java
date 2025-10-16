package com.uniplan.gateway.filter;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;

/**
 * JWT 토큰 검증 및 사용자 ID 추출 필터
 * Authorization: Bearer {token} 헤더에서 JWT 추출 → 검증 → X-User-Id 헤더 추가
 */
@Component
@Slf4j
public class AuthenticationHeaderFilter extends AbstractGatewayFilterFactory<AuthenticationHeaderFilter.Config> {

    private final SecretKey secretKey;

    public AuthenticationHeaderFilter(@Value("${jwt.secret}") String secret) {
        super(Config.class);
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }

    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            // 1. Authorization 헤더 추출
            String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                log.warn("Authorization 헤더가 없거나 형식이 잘못되었습니다.");
                return onError(exchange, "Missing or invalid Authorization header", HttpStatus.UNAUTHORIZED);
            }

            // 2. Bearer 토큰 추출
            String token = authHeader.substring(7);

            try {
                // 3. JWT 검증 및 사용자 정보 추출
                Claims claims = Jwts.parser()
                        .verifyWith(secretKey)
                        .build()
                        .parseSignedClaims(token)
                        .getPayload();

                String userId = claims.getSubject();
                String email = claims.get("email", String.class);
                String role = claims.get("role", String.class);

                log.info("JWT 검증 성공 - userId: {}, email: {}, role: {}", userId, email, role);

                // 4. X-User-Id, X-User-Email, X-User-Role 헤더 추가하여 다운스트림 서비스로 전달
                ServerWebExchange modifiedExchange = exchange.mutate()
                        .request(request -> request
                                .header("X-User-Id", userId)
                                .header("X-User-Email", email != null ? email : "")
                                .header("X-User-Role", role != null ? role : "USER"))
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
