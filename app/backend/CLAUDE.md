# Backend Microservices

## Architecture

```
app/backend/
├── api-gateway/        # Spring Cloud Gateway (port 8080)
├── user-service/       # Auth & user management (port 8081)
├── catalog-service/    # Course catalog & search (port 8083)
├── planner-service/    # Decision tree scenarios (port 8082, planned)
└── common-lib/         # Shared JWT utils, DTOs
```

## Key Architectural Principles

### 1. API Gateway Path Mapping

Gateway strips `/api/v1` prefix before routing:
- External: `POST /api/v1/auth/login` → Internal: `POST /auth/login`
- Services use simple paths (`/users`, `/auth`)
- Gateway handles versioning

See: `API_PATH_MAPPING.md`

### 2. JWT Authentication Flow

1. User Service issues JWT (access + refresh tokens)
2. API Gateway validates JWT, adds headers: `X-User-Id`, `X-User-Email`, `X-User-Role`
3. Downstream services trust headers (no JWT validation)
4. `JWT_SECRET` must match between Gateway and User Service
5. Common JWT utilities in `common-lib`

See: `JWT_AUTH_GUIDE.md`

### 3. Service Independence

- Each service has own Swagger (port-specific)
- Unified Swagger at Gateway: http://localhost:8080/swagger-ui.html
- No direct database access between services
- Inter-service communication via REST APIs

See: `SWAGGER_ARCHITECTURE.md`

## Domain-Driven Package Structure

```
com.uniplan.<service-name>/
├── domain/
│   ├── auth/              # Domain: Authentication
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   └── dto/
│   └── user/              # Domain: User management
│       └── (same structure)
└── global/                # Cross-cutting concerns
    ├── config/            # SecurityConfig, OpenApiConfig
    ├── exception/         # GlobalExceptionHandler
    └── util/
```

Domain cohesion > layer separation.

## Build & Run Commands

```bash
cd app/backend

# Build
./gradlew clean build                    # All services
./gradlew :user-service:build            # Specific service
./gradlew :api-gateway:build

# Run
./gradlew :user-service:bootRun
./gradlew :api-gateway:bootRun
./gradlew :catalog-service:bootRun

# Test
./gradlew test                           # All
./gradlew :user-service:test             # Service
./gradlew :user-service:test --tests "com.uniplan.user.domain.auth.service.AuthServiceTest"
```

## Service Ports

- 8080: API Gateway (main entry point)
- 8081: User Service
- 8082: Planner Service (planned)
- 8083: Catalog Service

## Swagger Docs

- Unified: http://localhost:8080/swagger-ui.html
- User Service: http://localhost:8081/swagger-ui.html
- Catalog Service: http://localhost:8083/swagger-ui.html

## Core Domain: Decision Tree

**planner-service** implements decision tree for registration scenarios:

- **Nodes**: Timetables (base + alternatives)
- **Edges**: Failure scenarios (if course X fails → alternative Y)
- **Navigation**: Real-time success/failure input → tree traversal

Example:
```
Base (CS101, CS102, CS103)
  ├─ CS101 fails → Alt 1 (CS104, CS102, CS103)
  │   └─ CS104 fails → Alt 1a (CS105, CS102, CS103)
  └─ CS102 fails → Alt 2 (CS101, CS106, CS103)
```

## Key Entities

- **User**: Email/password auth (OAuth2 ready)
- **Course**: Code, name, professor, time, credits, department
- **Timetable**: Collection of courses
- **Scenario**: Decision tree node linking timetables

## Adding New Service

1. Add to `settings.gradle.kts`: `include("new-service")`
2. Create `build.gradle.kts` with Spring Boot plugin
3. Add Swagger: `implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")`
4. Create packages: `domain/<domain>/{controller,service,repository,entity,dto}`
5. Add `OpenApiConfig.java` in `global/config/`
6. Update Gateway routes in `application-local.yml`
7. Add GroupedOpenApi bean in Gateway's `OpenApiConfig.java`

## Reference Docs

- Requirements: `../../요구사항명세서.md`
- API Path Mapping: `API_PATH_MAPPING.md`
- JWT Authentication: `JWT_AUTH_GUIDE.md`
- Swagger Architecture: `SWAGGER_ARCHITECTURE.md`
- User Service: `user-service/README.md`
- Catalog Service: `catalog-service/README.md`
