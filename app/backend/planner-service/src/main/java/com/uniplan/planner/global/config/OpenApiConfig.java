package com.uniplan.planner.global.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI plannerServiceOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("Planner Service API")
                .description("Timetable and decision tree management APIs")
                .version("1.0.0"));
    }
}