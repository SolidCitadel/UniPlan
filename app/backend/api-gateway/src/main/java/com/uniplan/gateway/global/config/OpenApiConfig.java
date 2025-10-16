package com.uniplan.gateway.global.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI apiGatewayOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("UniPlan API Gateway")
                        .description("UniPlan 마이크로서비스 통합 API 문서 - 모든 서비스의 엔드포인트를 한 곳에서 확인")
                        .version("v1.0.0")
                        .contact(new Contact()
                                .name("UniPlan Team")
                                .email("support@uniplan.com"))
                        .license(new License()
                                .name("MIT License")
                                .url("https://opensource.org/licenses/MIT")))
                .servers(List.of(
                        new Server().url("http://localhost:8080").description("API Gateway (로컬)"),
                        new Server().url("https://api.uniplan.com").description("운영 서버")
                ));
    }
}
