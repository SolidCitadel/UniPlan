package com.uniplan.catalog.global.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI catalogServiceOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Catalog Service API")
                .description("Course catalog management and import APIs")
                .version("1.0.0"));
    }
}
