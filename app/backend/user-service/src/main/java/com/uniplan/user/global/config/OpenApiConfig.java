package com.uniplan.user.global.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
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
    public OpenAPI uniPlanOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("UniPlan User Service API")
                        .description("사용자 인증 및 계정 관리 API - Google OAuth2 기반 소셜 로그인 및 JWT 토큰 발급")
                        .version("v1.0.0")
                        .contact(new Contact()
                                .name("UniPlan Team")
                                .email("support@uniplan.com"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://opensource.org/licenses/MIT")))
                .servers(List.of(
                        new Server().url("http://localhost:8081").description("로컬 개발 서버"),
                        new Server().url("http://localhost:8080").description("API Gateway (로컬)"),
                        new Server().url("https://api.uniplan.com").description("운영 서버")
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

