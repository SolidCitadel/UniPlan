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
│   ├── frontend/          # Flutter web (planned)
│   └── cli-client/        # Dart CLI → See app/cli-client/CLAUDE.md
├── scripts/
│   └── crawler/           # Python course crawler → See scripts/crawler/CLAUDE.md
└── docs/
```

## Module Documentation

- **Backend (MSA)**: `app/backend/CLAUDE.md`
- **Course Crawler**: `scripts/crawler/CLAUDE.md`
- **CLI Client**: `app/cli-client/CLAUDE.md`

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
