# UniPlan Frontend Agent Guide

This document provides guidelines for AI agents (and humans) working on the UniPlan Flutter Frontend (`app/frontend`).

## ⚡ Common Commands

-   **Run App (Web)**: `flutter run -d chrome`
-   **Code Generation**: `flutter pub run build_runner build --delete-conflicting-outputs`
    -   *Run this after modifying any file with `@freezed` or `@JsonSerializable`.*
-   **Get Dependencies**: `flutter pub get`
-   **Run Tests**: `flutter test`
-   **Analyze Code**: `flutter analyze`

## 🚨 CRITICAL: Backend-First API Integration

**BEFORE** implementing any API integration:

1. **MANDATORY**: Check backend controller in `app/backend/*/src/main/java/**/controller/`
2. **VERIFY**: Request DTO fields (e.g., `CourseSearchRequest.java`)
3. **VERIFY**: Response format (`Page<T>` vs `List<T>`)
4. **IMPLEMENT**: Match parameter names EXACTLY

### API Integration Checklist

- [ ] Located backend controller
- [ ] Reviewed request DTO structure
- [ ] Verified response format
- [ ] Matched parameter names exactly
- [ ] Tested with actual backend

**Example Mistake**: 
```dart
// ❌ WRONG - Assumed parameters
getCourses(search: query, department: dept)

// ✅ CORRECT - Verified from CourseSearchRequest.java
getCourses(courseName: query, professor: query, departmentCode: dept, campus: campus)
```

## 🏗️ Architecture

We follow **Clean Architecture** with **Riverpod** for state management.

### Layers (`lib/`)
1.  **`domain/`** (Pure Dart)
    -   **Entities**: Immutable data classes using `freezed`.
    -   **Repositories**: Abstract interfaces defining data operations.
    -   *Rule*: No Flutter UI dependencies. No `data` layer dependencies.
2.  **`data/`** (Implementation)
    -   **Data Sources**: Handle API calls (Dio) or local storage.
    -   **Repositories**: Implement domain interfaces.
    -   *Rule*: Depends on `domain`.
3.  **`presentation/`** (UI)
    -   **Screens**: UI Widgets (ConsumerWidget/ConsumerStatefulWidget).
    -   **ViewModels**: `StateNotifier` managing state.
    -   *Rule*: Depends on `domain` and `data` (via providers).
4.  **`core/`**
    -   Shared utilities, constants, theme, and router.
    -   **`network/dio_provider.dart`**: Centralized HTTP client with auth interceptor

## 🧩 Coding Standards

-   **State Management**: Use `flutter_riverpod`. Prefer `StateNotifierProvider` for complex state, `Provider` for dependencies.
-   **Navigation**: Use `GoRouter`. Define routes in `lib/core/router/app_router.dart`.
-   **Styling**: Use `Theme.of(context)` and `flex_color_scheme`. Avoid hardcoded colors.
-   **Imports**: Use relative imports for files within the same feature/layer. Use package imports for core/shared.
-   **Async**: Handle `AsyncValue` (data, loading, error) in UI for async operations.
-   **HTTP**: Use shared `dioProvider` from `core/network/dio_provider.dart` (handles auth automatically)

## 📝 New Feature Workflow

1.  **Backend First**: Verify backend controller and DTOs
2.  **Domain**: Define `Entity` (freezed) and `Repository` interface.
3.  **Data**: Implement `RemoteDataSource` and `RepositoryImpl`.
4.  **DI**: Create a Provider for the Repository in the Impl file.
5.  **Presentation**:
    -   Create `ViewModel` (StateNotifier) and its Provider.
    -   Create `Screen` (UI) consuming the provider.
6.  **Router**: Add the new route to `app_router.dart`.
7.  **Gen**: Run code generation command.
8.  **Verify**: Test with actual backend

## 📂 Directory Structure

```
lib/
├── core/
│   ├── constants/      # api_constants.dart
│   ├── network/        # dio_provider.dart (HTTP client)
│   ├── storage/        # token_storage.dart
│   ├── router/         # app_router.dart
│   └── theme/          # app_theme.dart
├── data/
│   ├── datasources/    # *_remote_data_source.dart
│   └── repositories/   # *_repository_impl.dart
├── domain/
│   ├── entities/       # *.dart (freezed)
│   └── repositories/   # *_repository.dart (abstract)
└── presentation/
    ├── auth/           # Login, Signup
    ├── main_layout/    # Shell, NavigationRail
    ├── course_list/    # Catalog feature
    ├── wishlist/       # Wishlist feature
    └── timetable/      # Planner feature
```
