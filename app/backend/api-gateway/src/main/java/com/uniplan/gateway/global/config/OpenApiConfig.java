package com.uniplan.gateway.global.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
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
                        .description("""
                            UniPlan 마이크로서비스 통합 API 문서

                            ## 서비스 구조
                            | 서비스 | 포트 | Gateway 경로 | 설명 |
                            |--------|------|--------------|------|
                            | User Service | 8081 | /api/v1/auth/**, /api/v1/users/** | 인증, 사용자 관리 |
                            | Planner Service | 8082 | /api/v1/timetables/**, /api/v1/wishlist/** | 시간표, 희망과목 |
                            | Catalog Service | 8083 | /api/v1/courses/**, /api/v1/catalog/** | 강좌 카탈로그 |

                            ## 경로 매핑
                            Gateway를 통해 접근 시 `/api/v1` prefix가 자동으로 제거됩니다.
                            - `GET /api/v1/courses` → Catalog Service `/courses`
                            - `GET /api/v1/timetables` → Planner Service `/timetables`

                            ## 드롭다운에서 각 서비스 선택 가능
                            우측 상단 드롭다운에서 서비스별 API 문서를 확인할 수 있습니다.
                            """)
                        .version("v1.0.0")
                        .contact(new Contact()
                                .name("UniPlan Team")
                                .email("support@uniplan.com")))
                .servers(List.of(
                        new Server().url("http://localhost:8080").description("API Gateway (로컬)")
                ));
    }
}
