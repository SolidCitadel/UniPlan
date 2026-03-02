package com.uniplan.gateway.filter;

import com.uniplan.common.header.SecurityHeaderConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.UUID;

/**
 * Correlation ID 전파 필터 (WebFlux GlobalFilter)
 *
 * 모든 요청에 X-Request-Id 헤더를 부여하여 서비스 간 요청 추적을 가능하게 합니다.
 * - 클라이언트가 헤더를 제공하면 그대로 사용
 * - 없으면 UUID를 생성하여 부여
 *
 * [WebFlux MDC 제약] Gateway는 Reactor 기반이므로 MDC.put()으로 requestId를 설정해도
 * 스레드 공유 특성상 Gateway 자체 로그에는 requestId가 포함되지 않습니다.
 * 다운스트림 MVC 서비스의 RequestIdFilter에서 MDC를 통해 로그에 포함됩니다.
 * Phase 3 (OTel + Micrometer Tracing)에서 Reactor Context 기반 전파로 해결될 예정입니다.
 */
@Component
public class CorrelationIdFilter implements GlobalFilter, Ordered {

    private static final Logger log = LoggerFactory.getLogger(CorrelationIdFilter.class);
    private static final String REQUEST_ID_HEADER = SecurityHeaderConstants.X_REQUEST_ID;

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String requestId = exchange.getRequest().getHeaders().getFirst(REQUEST_ID_HEADER);
        if (requestId == null || requestId.isBlank()) {
            requestId = UUID.randomUUID().toString();
        }

        final String finalRequestId = requestId;
        log.debug("Request-Id: {}", finalRequestId);

        ServerHttpRequest mutatedRequest = exchange.getRequest().mutate()
                .header(REQUEST_ID_HEADER, finalRequestId)
                .build();

        return chain.filter(exchange.mutate().request(mutatedRequest).build());
    }

    @Override
    public int getOrder() {
        // AuthenticationHeaderFilter보다 먼저 실행 (GlobalFilter이므로 GatewayFilter보다 우선)
        return Ordered.HIGHEST_PRECEDENCE;
    }
}
