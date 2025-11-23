# CLAUDE.md

## Project Overview

**UniPlan**: Scenario-based university course registration planner with decision tree timetables (Plan A/B/C) and real-time registration navigation.

**Tech Stack**: Spring Boot 3.x (Java 21) + Flutter web + Gradle (Kotlin DSL)
**Architecture**: MSA with API Gateway
**Database**: MySQL (prod), H2 (dev/test)

## Project Structure

```
UniPlan/
├── app/
│   ├── backend/           # Spring Boot MSA → See app/backend/CLAUDE.md
│   ├── frontend/          # Flutter web → See app/frontend/CLAUDE.md
│   └── cli-client/        # Dart CLI → See app/cli-client/CLAUDE.md
├── scripts/
│   └── crawler/           # Python course crawler → See scripts/crawler/CLAUDE.md
└── docs/
```

## Module Documentation

- **Backend (MSA)**: `app/backend/CLAUDE.md`
- **Frontend (Web)**: `app/frontend/CLAUDE.md`
- **Course Crawler**: `scripts/crawler/CLAUDE.md`
- **CLI Client**: `app/cli-client/CLAUDE.md`

## ⚠️ CRITICAL DEVELOPMENT CONSTRAINTS

### 🔴 Backend-First API Development

**MANDATORY**: Before implementing ANY frontend API integration:

1. **MUST** check the actual backend controller implementation
2. **MUST** verify exact parameter names from backend DTOs (e.g., `CourseSearchRequest`)
3. **MUST** verify response format (e.g., `Page<T>` vs `List<T>`)
4. **NEVER** assume parameter names - always check backend code first

**Example**: Course search API
- ❌ WRONG: Assuming `search` and `department` parameters
- ✅ CORRECT: Check `CourseController.java` → See `CourseSearchRequest.java` → Use `courseName`, `professor`, `departmentCode`, `campus`

### Backend API Contract Verification Process

1. Locate controller: `app/backend/*/src/main/java/**/controller/*.java`
2. Find request DTO: Check `@ModelAttribute` or `@RequestBody` parameter
3. Verify DTO fields: Open the DTO class and check all field names
4. Check response type: `ResponseEntity<Page<T>>` vs `ResponseEntity<List<T>>`
5. Implement frontend to match EXACTLY

## Common Conventions

### Java Coding Style

- Package: `com.uniplan.<service-name>`
- Classes: PascalCase
- Methods/variables: camelCase
- Constants: UPPER_SNAKE_CASE
- DTOs: Lombok `@Data` or `@Value`
- Null safety: `Optional<T>`, `@NotNull`

### Database

- Tables: plural, snake_case (`users`, `courses`)
- Columns: snake_case (`user_id`, `created_at`)
- Entities: PascalCase (`User`, `Course`)

### API

- URLs: kebab-case (`/course-catalog`, `/user-info`)
- HTTP: GET, POST, PUT, PATCH, DELETE
- Status: 200, 201, 400, 401, 404, 409, 500
- **Request/Response**: Always verify backend DTO structure first

## Environment Variables

- `JWT_SECRET`: 256-bit minimum, identical across API Gateway and User Service
- DB credentials: `application-local.yml` (local) or env vars (prod)

## Testing Strategy

- Unit: Service layer with mocked repositories
- Integration: Controller layer with `@SpringBootTest` + `@AutoConfigureMockMvc`
- Test DB: H2 in-memory

## Security

- Never commit: `.env`, `application-local.yml`, credentials
- All traffic via API Gateway (port 8080)
- JWT flow: User Service issues → Gateway validates → Downstream trusts headers
- Auth headers: Centralized Dio interceptor in frontend (`dio_provider.dart`)

## Current Project Status

### Completed
- ✅ Backend MSA architecture with API Gateway
- ✅ User authentication and JWT integration
- ✅ Course catalog service with search functionality
- ✅ Timetable planning service
- ✅ Frontend auth screens (login/signup)
- ✅ Frontend course list with backend search
- ✅ Centralized HTTP auth interceptor

### In Progress
- 🔄 UI/UX refinement (theme colors, text visibility)
- 🔄 Manual verification of all screens

### Known Issues
- Theme color conflicts causing poor text visibility
- Search button and filters need UI polish
