package com.uniplan.catalog.global.filter;

import com.uniplan.common.header.SecurityHeaderConstants;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.MDC;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.UUID;

/**
 * X-Request-Id 헤더를 MDC에 설정하는 필터
 *
 * Gateway의 CorrelationIdFilter가 부여한 X-Request-Id를 MDC에 설정하여
 * 모든 로그에 requestId 필드가 포함되도록 합니다.
 * Gateway를 거치지 않은 직접 요청(로컬 개발, 통합 테스트)에서는 UUID를 생성합니다.
 * Phase 3 (OTel) 도입 시 traceId/spanId로 통합될 예정입니다.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class RequestIdFilter extends OncePerRequestFilter {

    private static final String MDC_REQUEST_ID_KEY = "requestId";

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        String requestId = request.getHeader(SecurityHeaderConstants.X_REQUEST_ID);
        if (requestId == null || requestId.isBlank()) {
            requestId = UUID.randomUUID().toString();
        }
        MDC.put(MDC_REQUEST_ID_KEY, requestId);
        try {
            filterChain.doFilter(request, response);
        } finally {
            MDC.remove(MDC_REQUEST_ID_KEY);
        }
    }
}
