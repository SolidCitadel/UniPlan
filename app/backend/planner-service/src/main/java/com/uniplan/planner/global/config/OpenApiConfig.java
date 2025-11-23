package com.uniplan.planner.global.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI plannerServiceOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Planner Service API")
                .description("""
                    시간표 및 희망과목 관리 API

                    ## Gateway를 통한 접근
                    - Gateway(8080)를 통해 접근 시 `/api/v1` prefix가 자동으로 제거됩니다.
                    - 예: `GET /api/v1/timetables` → `GET /timetables`

                    ## 인증
                    - 모든 API는 JWT 토큰 인증이 필요합니다.
                    - Authorization 헤더에 `Bearer {token}` 형식으로 전달하세요.
                    """)
                .version("1.0.0")
                .contact(new Contact()
                    .name("UniPlan Team")
                    .email("support@uniplan.com")))
            .servers(List.of(
                new Server().url("http://localhost:8080/api/v1").description("API Gateway (로컬)"),
                new Server().url("http://localhost:8082").description("Direct Access (로컬)")
            ))
            .components(new Components()
                .addSecuritySchemes("bearer-jwt", new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT")
                    .description("JWT 토큰을 입력하세요 (Bearer 접두사 제외)")))
            .addSecurityItem(new SecurityRequirement().addList("bearer-jwt"));
    }
}