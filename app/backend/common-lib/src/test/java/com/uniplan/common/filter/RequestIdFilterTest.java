package com.uniplan.common.filter;

import com.uniplan.common.header.SecurityHeaderConstants;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.slf4j.MDC;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("RequestIdFilter 테스트")
class RequestIdFilterTest {

    private RequestIdFilter filter;

    @BeforeEach
    void setUp() {
        filter = new RequestIdFilter();
        MDC.clear();
    }

    @Test
    @DisplayName("X-Request-Id 헤더가 있으면 MDC에 해당 값을 설정")
    void testWithRequestIdHeader_ShouldSetMdc() throws Exception {
        String requestId = "test-request-id-12345";
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(SecurityHeaderConstants.X_REQUEST_ID, requestId);
        MockHttpServletResponse response = new MockHttpServletResponse();

        MockFilterChain chain = new MockFilterChain() {
            @Override
            public void doFilter(jakarta.servlet.ServletRequest req, jakarta.servlet.ServletResponse res)
                    throws java.io.IOException, jakarta.servlet.ServletException {
                assertThat(MDC.get(RequestIdFilter.MDC_REQUEST_ID_KEY)).isEqualTo(requestId);
                super.doFilter(req, res);
            }
        };

        filter.doFilterInternal(request, response, chain);
    }

    @Test
    @DisplayName("X-Request-Id 헤더가 없으면 UUID를 생성하여 MDC에 설정")
    void testWithoutRequestIdHeader_ShouldGenerateUuid() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        final String[] capturedRequestId = new String[1];
        MockFilterChain chain = new MockFilterChain() {
            @Override
            public void doFilter(jakarta.servlet.ServletRequest req, jakarta.servlet.ServletResponse res)
                    throws java.io.IOException, jakarta.servlet.ServletException {
                capturedRequestId[0] = MDC.get(RequestIdFilter.MDC_REQUEST_ID_KEY);
                assertThat(capturedRequestId[0]).isNotNull().isNotBlank();
                super.doFilter(req, res);
            }
        };

        filter.doFilterInternal(request, response, chain);

        // UUID 형식 검증 (8-4-4-4-12)
        assertThat(capturedRequestId[0]).matches(
                "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
        );
    }

    @Test
    @DisplayName("빈 문자열 X-Request-Id 헤더는 UUID를 생성하여 MDC에 설정")
    void testWithBlankRequestIdHeader_ShouldGenerateUuid() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.addHeader(SecurityHeaderConstants.X_REQUEST_ID, "");
        MockHttpServletResponse response = new MockHttpServletResponse();

        MockFilterChain chain = new MockFilterChain() {
            @Override
            public void doFilter(jakarta.servlet.ServletRequest req, jakarta.servlet.ServletResponse res)
                    throws java.io.IOException, jakarta.servlet.ServletException {
                String mdcValue = MDC.get(RequestIdFilter.MDC_REQUEST_ID_KEY);
                assertThat(mdcValue).isNotNull().isNotBlank();
                super.doFilter(req, res);
            }
        };

        filter.doFilterInternal(request, response, chain);
    }

    @Test
    @DisplayName("필터 체인 완료 후 MDC에서 requestId가 제거됨")
    void testMdcCleanupAfterFilterChain() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        filter.doFilterInternal(request, response, chain);

        assertThat(MDC.get(RequestIdFilter.MDC_REQUEST_ID_KEY)).isNull();
    }

    @Test
    @DisplayName("필터 체인에서 예외가 발생해도 MDC가 정리됨")
    void testMdcCleanupOnException() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();

        MockFilterChain chain = new MockFilterChain() {
            @Override
            public void doFilter(jakarta.servlet.ServletRequest req, jakarta.servlet.ServletResponse res)
                    throws java.io.IOException, jakarta.servlet.ServletException {
                throw new jakarta.servlet.ServletException("downstream error");
            }
        };

        assertThatThrownBy(() -> filter.doFilterInternal(request, response, chain))
                .isInstanceOf(jakarta.servlet.ServletException.class);

        assertThat(MDC.get(RequestIdFilter.MDC_REQUEST_ID_KEY)).isNull();
    }
}
