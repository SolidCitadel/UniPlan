# Swagger 아키텍처 설계 문서

## 결론: 모듈별 적용 ✅

UniPlan MSA 프로젝트에서는 **각 마이크로서비스별로 개별 Swagger를 적용**하고, **API Gateway에서 통합 문서**를 제공하는 하이브리드 방식을 채택했습니다.

## 📊 적용된 구조

```
backend/
├── api-gateway/              ← Swagger (통합) ✅
│   ├── Port: 8080
│   ├── 역할: 모든 서비스 API 통합 문서
│   └── URL: http://localhost:8080/swagger-ui.html
│
├── user-service/             ← Swagger (독립) ✅
│   ├── Port: 8081
│   ├── 역할: 사용자 인증/계정 API
│   └── URL: http://localhost:8081/swagger-ui.html
│
├── planner-service/          ← Swagger (독립) [향후 추가]
│   ├── Port: 8082
│   ├── 역할: 시나리오/플랜 API
│   └── URL: http://localhost:8082/swagger-ui.html
│
└── catalog-service/          ← Swagger (독립) [향후 추가]
    ├── Port: 8083
    ├── 역할: 강의 목록/검색 API
    └── URL: http://localhost:8083/swagger-ui.html
```

## 🎯 각 Swagger의 역할

### 1. API Gateway Swagger (통합 문서)
**목적**: Flutter 클라이언트 개발자를 위한 원스톱 문서

**특징:**
- 📚 **서비스별 그룹화**: User/Planner/Catalog를 탭으로 구분
- 🔀 **라우팅 기반**: Gateway를 통해 실제 API 호출 가능
- 🌐 **통합 뷰**: 모든 API를 한 곳에서 확인
- 🔐 **JWT 인증**: 통합된 Bearer Token 테스트

**사용 시나리오:**
```
프론트엔드 개발자
  → API Gateway Swagger UI 접속
  → 모든 서비스 API 확인
  → "Try it out"으로 직접 테스트
  → JWT 토큰 한 번만 입력하면 모든 API 테스트 가능
```

**설정 파일:** `api-gateway/global/config/OpenApiConfig.java`
```java
@Bean
public GroupedOpenApi userServiceApi() {
    return GroupedOpenApi.builder()
            .group("1. User Service")
            .pathsToMatch("/api/v1/auth/**", "/api/v1/users/**")
            .build();
}

@Bean
public GroupedOpenApi plannerServiceApi() {
    return GroupedOpenApi.builder()
            .group("2. Planner Service")
            .pathsToMatch("/api/v1/planner/**", "/api/v1/timetables/**")
            .build();
}
```

### 2. 개별 서비스 Swagger (독립 문서)
**목적**: 백엔드 개발자를 위한 서비스별 상세 문서

**특징:**
- 🎯 **단일 책임**: 해당 서비스만 문서화
- ⚡ **빠른 로딩**: 불필요한 API 제외
- 🔧 **개발 편의**: 서비스 개발 중 즉시 확인
- 📦 **독립 배포**: 서비스 배포 시 문서도 함께 제공

**사용 시나리오:**
```
백엔드 개발자 (User Service 담당)
  → User Service Swagger UI 직접 접속
  → 해당 서비스 API만 집중 개발/테스트
  → 다른 서비스 의존성 없음
```

**설정 파일:** `user-service/global/config/OpenApiConfig.java`
```java
@Bean
public OpenAPI uniPlanOpenAPI() {
    return new OpenAPI()
            .info(new Info()
                    .title("UniPlan User Service API")
                    .description("사용자 인증 및 계정 관리 API"))
            .components(new Components()
                    .addSecuritySchemes("bearer-jwt", ...));
}
```

## 🔑 핵심 장점

### 1. 독립성 (Independence)
```
user-service 수정 → user-service Swagger만 재배포
planner-service는 영향 없음 ✅
```

### 2. 확장성 (Scalability)
```
새 서비스 추가 시:
1. 해당 서비스에 Swagger 의존성 추가
2. OpenApiConfig 클래스 생성
3. API Gateway의 GroupedOpenApi 빈 추가
→ 3단계만으로 완료!
```

### 3. 개발 효율성 (Efficiency)
```
프론트엔드: Gateway Swagger → 전체 API 한눈에 확인
백엔드: 개별 Swagger → 담당 서비스만 집중 개발
```

## 📋 의존성 차이점

### API Gateway (WebFlux 기반)
```kotlin
// build.gradle.kts (Gradle Kotlin DSL 설정 파일)
implementation("org.springdoc:springdoc-openapi-starter-webflux-ui:2.3.0")
```
→ Gateway는 **WebFlux**(Reactive) 기반이므로 `-webflux-ui` 사용

### 일반 서비스 (WebMVC 기반)
```kotlin
// build.gradle.kts (Gradle Kotlin DSL 설정 파일)
implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")
```
→ User/Planner/Catalog는 **WebMVC** 기반이므로 `-webmvc-ui` 사용

## 🚀 실제 사용 흐름

### 개발 단계
```
백엔드 개발자
  └─→ http://localhost:8081/swagger-ui.html (User Service)
      └─→ 인증 API 개발 및 테스트

  └─→ http://localhost:8082/swagger-ui.html (Planner Service)
      └─→ 시나리오 API 개발 및 테스트
```

### 통합 테스트 단계
```
프론트엔드 개발자
  └─→ http://localhost:8080/swagger-ui.html (API Gateway)
      ├─→ [1. User Service] 탭: 로그인/회원가입
      ├─→ [2. Planner Service] 탭: 시간표/플랜
      └─→ [3. Catalog Service] 탭: 강의 검색
```

### 운영 단계
```
외부 개발자 (공개 API 사용)
  └─→ https://api.uniplan.com/swagger-ui.html
      └─→ 공개된 API만 문서화 (내부 API 숨김)
```

## ❌ Root 프로젝트 적용 방식 (채택 안 함)

만약 Root에 적용했다면:
```
backend/
├── build.gradle.kts  ← 여기에 Swagger 추가
└── src/
    └── SwaggerConfig.java  ← 모든 서비스 통합

문제점:
❌ 모든 서비스가 하나의 문서에 결합
❌ 서비스 독립 배포 불가능
❌ 문서 로딩 느림 (모든 API 한 번에 로드)
❌ MSA 철학 위배
```

## ✅ 현재 구조의 우수성

### 마이크로서비스 원칙 준수
- ✅ **단일 책임**: 각 서비스가 자신의 API만 문서화
- ✅ **독립 배포**: 서비스별 Swagger도 함께 배포
- ✅ **느슨한 결합**: 다른 서비스 문서에 의존하지 않음

### 개발 편의성
- ✅ **빠른 개발**: 담당 서비스만 보면 됨
- ✅ **명확한 책임**: 서비스 경계가 문서에도 반영
- ✅ **협업 용이**: 팀별로 독립적 작업 가능

### 사용자 경험
- ✅ **통합 뷰**: API Gateway에서 전체 확인 가능
- ✅ **상세 뷰**: 개별 서비스에서 깊이 있는 문서
- ✅ **선택권**: 필요에 따라 Gateway/개별 선택

## 📌 향후 추가 작업 (Planner/Catalog 서비스)

각 서비스 생성 시 체크리스트:

### 1. Swagger 의존성 추가
```kotlin
// planner-service/build.gradle.kts (Gradle Kotlin DSL 설정 파일)
dependencies {
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")
}
```

### 2. OpenApiConfig 생성
```java
// planner-service/global/config/OpenApiConfig.java
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

### 3. application.yml 설정
```yaml
# planner-service/application.yml
springdoc:
  api-docs:
    path: /v3/api-docs
  swagger-ui:
    path: /swagger-ui.html
```

### 4. API Gateway에 그룹 추가 (이미 완료!)
```java
// api-gateway/global/config/OpenApiConfig.java
@Bean
public GroupedOpenApi plannerServiceApi() {
    return GroupedOpenApi.builder()
            .group("2. Planner Service")
            .pathsToMatch("/api/v1/planner/**", "/api/v1/timetables/**")
            .build();
}
```

## 🎉 결론

**답변: 모듈 단위로 적용하는 것이 압도적으로 유리합니다!**

현재 UniPlan 프로젝트는 **하이브리드 방식**을 채택했습니다:
- ✅ 각 마이크로서비스: 독립적인 Swagger
- ✅ API Gateway: 통합 Swagger (모든 서비스 통합 뷰)

이 구조는:
- 🎯 MSA 철학 준수
- 🚀 개발/배포 독립성 보장
- 📚 사용자에게 통합 문서 제공
- 🔧 백엔드 개발자에게 편의성 제공

→ **Best of Both Worlds!** 🌟

