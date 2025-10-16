package com.uniplan.gateway.global.config;

import com.uniplan.gateway.filter.AuthenticationHeaderFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Spring Cloud Gateway 필터 설정
 * - YAML 설정과 함께 사용 가능
 * - 프로그래밍 방식으로 라우팅 및 필터 등록
 */
@Configuration
public class FilterConfig {

    private final AuthenticationHeaderFilter authenticationHeaderFilter;

    @Value("${services.user-service.uri}")
    private String userServiceUri;

    @Value("${services.planner-service.uri}")
    private String plannerServiceUri;

    @Value("${services.catalog-service.uri}")
    private String catalogServiceUri;

    public FilterConfig(AuthenticationHeaderFilter authenticationHeaderFilter) {
        this.authenticationHeaderFilter = authenticationHeaderFilter;
    }

    /**
     * 프로그래밍 방식으로 라우팅 및 필터 설정
     * (필요시 YAML 설정 대신 또는 함께 사용)
     */
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // OAuth2 경로 라우팅 (Spring Security 자동 경로)
                .route("user-service-oauth2", r -> r
                        .path("/oauth2/**", "/login/oauth2/**")
                        .uri(userServiceUri))

                // 인증이 필요 없는 Auth 라우트
                .route("user-service-auth", r -> r
                        .path("/api/v1/auth/**")
                        .filters(f -> f
                                .rewritePath("/api/v1/(?<segment>.*)", "/${segment}"))
                        .uri(userServiceUri))

                // 인증이 필요한 User Service 라우트
                .route("user-service-protected", r -> r
                        .path("/api/v1/users/**")
                        .filters(f -> f
                                .filter(authenticationHeaderFilter.apply(new AuthenticationHeaderFilter.Config()))
                                .rewritePath("/api/v1/(?<segment>.*)", "/${segment}"))
                        .uri(userServiceUri))

                // Planner Service - 인증 필요
                .route("planner-service", r -> r
                        .path("/api/v1/planner/**", "/api/v1/timetables/**", "/api/v1/scenarios/**")
                        .filters(f -> f
                                .filter(authenticationHeaderFilter.apply(new AuthenticationHeaderFilter.Config()))
                                .rewritePath("/api/v1/(?<segment>.*)", "/${segment}"))
                        .uri(plannerServiceUri))

                // Catalog Service - 인증 필요
                .route("catalog-service", r -> r
                        .path("/api/v1/courses/**", "/api/v1/catalog/**")
                        .filters(f -> f
                                .filter(authenticationHeaderFilter.apply(new AuthenticationHeaderFilter.Config()))
                                .rewritePath("/api/v1/(?<segment>.*)", "/${segment}"))
                        .uri(catalogServiceUri))

                .build();
    }
}
