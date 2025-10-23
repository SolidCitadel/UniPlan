# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**UniPlan** is a scenario-based university course registration planner web application. It helps students manage uncertainty during course registration by building decision trees of alternative timetables (Plan A, B, C...) and provides real-time navigation during actual registration.

- **Tech Stack**: Spring Boot 3.x microservices (Java 21) + Flutter web client
- **Architecture**: Microservices Architecture (MSA) with API Gateway
- **Build Tool**: Gradle with Kotlin DSL
- **Database**: MySQL (production), H2 (development/testing)

## Microservices Architecture

The backend follows MSA principles with domain-driven design:

```
app/backend/
├── api-gateway/        # Spring Cloud Gateway - single entry point (port 8080)
├── user-service/       # Authentication & user management (port 8081)
├── catalog-service/    # Course catalog & search (port 8083)
├── planner-service/    # Core: decision tree scenarios (planned)
└── common-lib/         # Shared JWT utilities, DTOs, constants
```

### Key Architectural Principles

1. **Path Mapping**: API Gateway strips `/api/v1` prefix before routing to services
   - External: `POST /api/v1/auth/login` → Internal: `POST /auth/login`
   - Services use simple paths (`/users`, `/auth`), Gateway handles versioning
   - See `app/backend/API_PATH_MAPPING.md` for details

2. **JWT Authentication Flow**:
   - User Service issues JWT tokens (access + refresh)
   - API Gateway validates JWT and adds headers: `X-User-Id`, `X-User-Email`, `X-User-Role`
   - Downstream services trust these headers (no JWT validation needed)
   - JWT secret must match between Gateway and User Service
   - Common JWT utilities live in `common-lib` package

3. **Service Independence**:
   - Each service has its own Swagger documentation (port-specific)
   - API Gateway provides unified Swagger at http://localhost:8080/swagger-ui.html
   - Services must not directly access other services' databases
   - Use REST APIs for inter-service communication

## Domain-Driven Package Structure

Services follow **domain-based** organization (not layer-based):

```
com.uniplan.<service-name>/
├── domain/
│   ├── auth/              # Authentication domain
│   │   ├── controller/
│   │   ├── service/
│   │   ├── repository/
│   │   ├── entity/
│   │   └── dto/
│   └── user/              # User management domain
│       └── (same structure)
└── global/                # Cross-cutting concerns
    ├── config/            # SecurityConfig, OpenApiConfig
    ├── exception/         # GlobalExceptionHandler, custom exceptions
    └── util/
```

**Rationale**: Domain cohesion over layer separation. Related functionality stays together.

## Common Development Commands

### Build & Run

```bash
# Navigate to backend directory
cd app/backend

# Build all services
./gradlew clean build

# Build specific service
./gradlew :user-service:build
./gradlew :api-gateway:build

# Run specific service
./gradlew :user-service:bootRun
./gradlew :api-gateway:bootRun

# Run tests
./gradlew test
./gradlew :user-service:test

# Run single test class
./gradlew :user-service:test --tests "com.uniplan.user.domain.auth.service.AuthServiceTest"
```

### Service Ports

- API Gateway: 8080 (main entry point)
- User Service: 8081
- Planner Service: 8082 (planned)
- Catalog Service: 8083

### Swagger Documentation

- Unified (all services): http://localhost:8080/swagger-ui.html
- User Service only: http://localhost:8081/swagger-ui.html
- Catalog Service only: http://localhost:8083/swagger-ui.html

## Core Domain Model: Decision Tree

The **planner-service** implements a decision tree structure for course registration scenarios:

- **Nodes**: Timetables (base + alternatives)
- **Edges**: Failure scenarios (if course X fails → go to alternative timetable Y)
- **Navigation**: Real-time input of success/failure during registration → tree traversal

**Example**:
```
Base Timetable (CS101, CS102, CS103)
  ├─ CS101 fails → Alt 1 (CS104, CS102, CS103)
  │   └─ CS104 fails → Alt 1a (CS105, CS102, CS103)
  └─ CS102 fails → Alt 2 (CS101, CS106, CS103)
```

## Key Entities

- **User**: User accounts with email/password authentication (OAuth2 ready for future)
- **Course**: Course information (code, name, professor, time, credits, department, etc.)
- **Timetable**: Collection of courses for a specific plan
- **Scenario**: Decision tree node linking timetables with failure conditions

## Database Conventions

- **Table names**: Plural, snake_case (`users`, `courses`, `timetables`)
- **Column names**: snake_case (`user_id`, `course_code`, `created_at`)
- **Entity classes**: PascalCase (`User`, `Course`)
- **JPA Repositories**: Spring Data JPA with standard naming

## API Conventions

- **URL format**: kebab-case (`/course-catalog`, `/user-info`)
- **HTTP methods**: GET (read), POST (create), PUT (full update), PATCH (partial), DELETE
- **Response wrapper**: JSON with common structure (or Spring Boot defaults)
- **Status codes**: 200 (OK), 201 (Created), 400 (Bad Request), 401 (Unauthorized), 404 (Not Found), 409 (Conflict), 500 (Internal Error)

## Coding Style (Java)

- **Package naming**: `com.uniplan.<service-name>`
- **Class names**: PascalCase
- **Methods/variables**: camelCase
- **Constants**: UPPER_SNAKE_CASE
- **Immutability**: Prefer final fields, use Lombok `@Data` or `@Value` for DTOs
- **Null safety**: Use `Optional<T>` for repository queries, `@NotNull` annotations

## When Adding a New Service

1. Add module to `settings.gradle.kts`: `include("new-service")`
2. Create `build.gradle.kts` with Spring Boot plugin and dependencies
3. Add Swagger dependency: `implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")`
4. Create domain packages: `domain/<domain-name>/{controller,service,repository,entity,dto}`
5. Add `OpenApiConfig.java` in `global/config/`
6. Update API Gateway routes in `application-local.yml`
7. Add GroupedOpenApi bean in Gateway's `OpenApiConfig.java` for unified docs

## Environment Variables

- `JWT_SECRET`: JWT signing key (minimum 256 bits). Must be identical for API Gateway and User Service
- Database credentials should be in `application-local.yml` (local) or environment variables (production)

## Testing Strategy

- Unit tests: Service layer with mocked repositories
- Integration tests: Controller layer with `@SpringBootTest` and `@AutoConfigureMockMvc`
- Test DB: H2 in-memory database (configured in test resources)

## Important Notes

- **Never commit secrets**: Use `.gitignore` for `.env`, `application-local.yml`, credentials files
- **Service isolation**: Each service should be independently deployable
- **Gateway routing**: All client traffic goes through API Gateway (port 8080)
- **JWT consistency**: `common-lib` centralizes JWT logic; User Service issues tokens, Gateway validates them

## Reference Documentation

- Requirements: `요구사항명세서.md`
- API Path Mapping: `app/backend/API_PATH_MAPPING.md`
- JWT Authentication Guide: `app/backend/JWT_AUTH_GUIDE.md`
- Swagger Architecture: `app/backend/SWAGGER_ARCHITECTURE.md`
- User Service README: `app/backend/user-service/README.md`
- Catalog Service README: `app/backend/catalog-service/README.md`