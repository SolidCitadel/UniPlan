# UniPlan Frontend

The Flutter-based web frontend for **UniPlan**, a scenario-based university course registration planner.

## 🚀 Overview

UniPlan helps students manage the uncertainty of course registration by allowing them to build decision-tree based timetables (Plan A, Plan B, etc.) and provides real-time navigation during the actual registration process.

This project is the **Web Client** built with Flutter.

## 🛠️ Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/) (Web Target)
-   **Language**: Dart
-   **Architecture**: Clean Architecture (Presentation, Domain, Data)
-   **State Management**: [Riverpod](https://riverpod.dev/) (Hooks Riverpod)
-   **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
-   **Networking**: [Dio](https://pub.dev/packages/dio)
-   **Code Generation**: [Freezed](https://pub.dev/packages/freezed), [JSON Serializable](https://pub.dev/packages/json_serializable)
-   **UI Components**: Material 3

## 📂 Project Structure

```
lib/
├── core/           # Global utilities, constants, theme, router
├── data/           # Data layer (Repositories impl, Data Sources, DTOs)
├── domain/         # Domain layer (Entities, Repository interfaces, UseCases)
├── presentation/   # UI layer (Screens, Widgets, ViewModels)
└── main.dart       # Entry point
```

## ⚡ Setup & Running

### Prerequisites
-   Flutter SDK (Latest Stable)
-   Dart SDK

### Installation

1.  **Clone the repository** (if you haven't already):
    ```bash
    git clone https://github.com/yourusername/UniPlan.git
    cd UniPlan/app/frontend
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run Code Generation** (required for Freezed/JSON Serializable):
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

### Running the App

To run the app in Chrome:

```bash
flutter run -d chrome
```

## 🌟 Features

-   **Authentication**: Login and Signup (integrated with User Service).
-   **Course Catalog**: Browse and search courses (integrated with Catalog Service).
-   **Wishlist**: Add courses to your wishlist.
-   **Timetable Planner**: Create multiple timetable scenarios (Plan A, B...) and check for conflicts.
-   **Responsive Design**: Optimized for Web Desktop usage.

## 🤝 Contributing

Please follow the Clean Architecture pattern when adding new features. Ensure you run `build_runner` after modifying entities or state classes.
