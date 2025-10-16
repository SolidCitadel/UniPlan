# Swagger 구성 가이드

## ✅ 최종 선택: 드롭다운 방식 (각 서비스 독립 문서화)

UniPlan 프로젝트는 **각 마이크로서비스별 독립 Swagger + API Gateway 드롭다운 통합 UI** 방식을 채택했습니다.

## 📊 구조

```
각 서비스 독립 문서화:
├── user-service (8081)      → http://localhost:8081/swagger-ui.html
├── planner-service (8082)   → http://localhost:8082/swagger-ui.html (향후)
└── catalog-service (8083)   → http://localhost:8083/swagger-ui.html (향후)

API Gateway 통합 뷰:
└── api-gateway (8080)       → http://localhost:8080/swagger-ui.html
    └── 드롭다운에서 서비스 선택
        ├── User Service
        ├── Planner Service
        ├── Catalog Service
        └── Gateway (Actuator)
```

## 🎯 사용 방법

### 개발자용 (백엔드)
각 서비스 개발 시 해당 서비스의 Swagger UI 직접 사용:
```
http://localhost:8081/swagger-ui.html  # User Service
http://localhost:8082/swagger-ui.html  # Planner Service
http://localhost:8083/swagger-ui.html  # Catalog Service
```

### 통합 뷰 (프론트엔드, QA)
API Gateway에서 드롭다운으로 모든 서비스 API 확인:
```
http://localhost:8080/swagger-ui.html

→ 상단 드롭다운에서 서비스 선택:
  - User Service
  - Planner Service
  - Catalog Service
```

### 외부 도구 (Postman, 클라이언트 생성기)
각 서비스의 OpenAPI 스펙을 개별 import:
```
User Service:    http://localhost:8081/v3/api-docs
Planner Service: http://localhost:8082/v3/api-docs
Catalog Service: http://localhost:8083/v3/api-docs
```

## 🔧 설정 상세

### API Gateway (application-local.yml)
```yaml
springdoc:
  swagger-ui:
    urls:
      - name: "User Service"
        url: /user-service/v3/api-docs
      - name: "Planner Service"
        url: /planner-service/v3/api-docs
      - name: "Catalog Service"
        url: /catalog-service/v3/api-docs
    urls-primary-name: "User Service"
```

### 라우팅 설정
```yaml
spring:
  cloud:
    gateway:
      routes:
        # User Service Swagger Docs
        - id: user-service-docs
          uri: http://localhost:8081
          predicates:
            - Path=/user-service/v3/api-docs
          filters:
            - RewritePath=/user-service/v3/api-docs, /v3/api-docs
```

## ✅ 장점

1. **간단함**: 복잡한 통합 로직 불필요
2. **독립성**: 각 서비스 독립 개발/배포
3. **표준**: 업계 대부분의 MSA 프로젝트가 사용하는 방식
4. **유지보수**: 각 서비스가 자신의 문서만 관리
5. **명확성**: 서비스 경계가 문서에도 반영

## 📌 다음 서비스 추가 시

새 서비스(예: planner-service) 추가 시 3단계:

1. **서비스에 Swagger 추가** (build.gradle.kts):
```kotlin
implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")
```

2. **OpenApiConfig 생성**:
```java
@Configuration
public class OpenApiConfig {
    @Bean
    public OpenAPI plannerOpenAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("UniPlan Planner Service API")
                .description("시나리오 플랜 및 시간표 관리 API"));
    }
}
```

3. **Gateway에 라우팅 추가** (application-local.yml):
```yaml
# 이미 준비되어 있음!
- id: planner-service-docs
  uri: http://localhost:8082
  predicates:
    - Path=/planner-service/v3/api-docs
  filters:
    - RewritePath=/planner-service/v3/api-docs, /v3/api-docs
```

## 🚫 거부한 방법: 통합 OpenAPI 스펙 생성

**거부 이유:**
- 복잡한 경로 변환 로직 필요
- 각 서비스의 OpenAPI 스펙을 실시간 수집/병합
- 유지보수 어려움
- 실질적 이점 적음 (대부분의 도구가 멀티 스펙 import 지원)

**대신:**
- Swagger UI 드롭다운으로 충분
- 외부 도구는 서비스별 스펙 개별 import
- 간단하고 명확한 아키텍처 유지

## 📖 참고

대형 MSA 프로젝트 사례:
- **Netflix**: 각 서비스 독립 문서화
- **Amazon**: API Gateway에서 드롭다운 제공
- **Uber**: 서비스별 Swagger UI 운영

→ 모두 우리와 동일한 방식 사용 ✅

## 🎉 결론

**현재 방식(드롭다운)이 MSA에서 가장 실용적이고 표준적인 방법입니다!**

