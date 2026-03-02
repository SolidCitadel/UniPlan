package com.uniplan.gateway.unit.filter;

import com.uniplan.common.header.SecurityHeaderConstants;
import com.uniplan.gateway.filter.CorrelationIdFilter;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.core.Ordered;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@DisplayName("CorrelationIdFilter 테스트")
class CorrelationIdFilterTest {

    private CorrelationIdFilter filter;
    private GatewayFilterChain mockChain;

    @BeforeEach
    void setUp() {
        filter = new CorrelationIdFilter();
        mockChain = mock(GatewayFilterChain.class);
    }

    @Test
    @DisplayName("X-Request-Id 헤더가 없으면 UUID를 생성하여 요청 헤더에 추가")
    void testWithoutRequestId_ShouldGenerateUuid() {
        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/test").build();
        ServerWebExchange exchange = MockServerWebExchange.from(request);

        when(mockChain.filter(any())).thenAnswer(invocation -> {
            ServerWebExchange modified = invocation.getArgument(0);
            String requestId = modified.getRequest().getHeaders()
                    .getFirst(SecurityHeaderConstants.X_REQUEST_ID);
            assertThat(requestId).isNotNull().isNotBlank();
            assertThat(requestId).matches(
                    "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
            );
            return Mono.empty();
        });

        StepVerifier.create(filter.filter(exchange, mockChain))
                .verifyComplete();
    }

    @Test
    @DisplayName("클라이언트가 X-Request-Id를 제공하면 그대로 다운스트림으로 전달")
    void testWithExistingRequestId_ShouldPassThrough() {
        String existingRequestId = "client-provided-request-id";
        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/test")
                .header(SecurityHeaderConstants.X_REQUEST_ID, existingRequestId)
                .build();
        ServerWebExchange exchange = MockServerWebExchange.from(request);

        when(mockChain.filter(any())).thenAnswer(invocation -> {
            ServerWebExchange modified = invocation.getArgument(0);
            String requestId = modified.getRequest().getHeaders()
                    .getFirst(SecurityHeaderConstants.X_REQUEST_ID);
            assertThat(requestId).isEqualTo(existingRequestId);
            return Mono.empty();
        });

        StepVerifier.create(filter.filter(exchange, mockChain))
                .verifyComplete();
    }

    @Test
    @DisplayName("응답 헤더에 X-Request-Id가 포함됨")
    void testResponseHeader_ShouldContainRequestId() {
        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/test").build();
        ServerWebExchange exchange = MockServerWebExchange.from(request);

        when(mockChain.filter(any())).thenReturn(Mono.empty());

        StepVerifier.create(filter.filter(exchange, mockChain))
                .verifyComplete();

        String responseRequestId = exchange.getResponse().getHeaders()
                .getFirst(SecurityHeaderConstants.X_REQUEST_ID);
        assertThat(responseRequestId).isNotNull().isNotBlank();
    }

    @Test
    @DisplayName("요청 헤더와 응답 헤더의 X-Request-Id가 동일")
    void testRequestAndResponseRequestIdMatch() {
        String clientRequestId = "correlation-test-id";
        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/test")
                .header(SecurityHeaderConstants.X_REQUEST_ID, clientRequestId)
                .build();
        ServerWebExchange exchange = MockServerWebExchange.from(request);

        when(mockChain.filter(any())).thenReturn(Mono.empty());

        StepVerifier.create(filter.filter(exchange, mockChain))
                .verifyComplete();

        String responseRequestId = exchange.getResponse().getHeaders()
                .getFirst(SecurityHeaderConstants.X_REQUEST_ID);
        assertThat(responseRequestId).isEqualTo(clientRequestId);
    }

    @Test
    @DisplayName("빈 문자열 X-Request-Id 헤더는 UUID를 생성하여 사용")
    void testWithBlankRequestId_ShouldGenerateUuid() {
        MockServerHttpRequest request = MockServerHttpRequest.get("/api/v1/test")
                .header(SecurityHeaderConstants.X_REQUEST_ID, "")
                .build();
        ServerWebExchange exchange = MockServerWebExchange.from(request);

        when(mockChain.filter(any())).thenAnswer(invocation -> {
            ServerWebExchange modified = invocation.getArgument(0);
            String requestId = modified.getRequest().getHeaders()
                    .getFirst(SecurityHeaderConstants.X_REQUEST_ID);
            assertThat(requestId).isNotNull().isNotBlank();
            return Mono.empty();
        });

        StepVerifier.create(filter.filter(exchange, mockChain))
                .verifyComplete();
    }

    @Test
    @DisplayName("getOrder()는 HIGHEST_PRECEDENCE를 반환")
    void testOrder_ShouldBeHighestPrecedence() {
        assertThat(filter.getOrder()).isEqualTo(Ordered.HIGHEST_PRECEDENCE);
    }
}
