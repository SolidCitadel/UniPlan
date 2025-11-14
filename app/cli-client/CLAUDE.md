# CLI Client

Dart-based CLI for testing backend APIs before frontend completion.

**Development Order**: Backend → CLI Client → Frontend

## Tech Stack

- Language: Dart
- HTTP: `package:http`
- Args: `package:args`
- Token Storage: `~/.uniplan/token.json`

## Project Structure

```
app/cli-client/
├── bin/
│   └── uniplan.dart          # Main entry
├── lib/
│   ├── commands/             # Command implementations
│   │   ├── auth_command.dart
│   │   ├── courses_command.dart
│   │   ├── user_command.dart
│   │   ├── wishlist_command.dart
│   │   ├── timetable_command.dart
│   │   ├── scenario_command.dart
│   │   └── registration_command.dart
│   ├── api/
│   │   ├── api_client.dart   # HTTP client with logging
│   │   └── endpoints.dart    # API endpoint constants
│   ├── utils/
│   │   ├── token_manager.dart        # JWT storage
│   │   ├── output_formatter.dart     # Output formatting
│   │   └── terminal_utils.dart       # Terminal control
│   └── config.dart
└── pubspec.yaml
```

## Key Features

- **Interactive Mode**: Shell-like continuous command execution
- **Authentication**: Login, signup, token refresh, logout
- **Course Management**: List, search, details, import from JSON
- **User Management**: Profile
- **Wishlist**: Add/remove courses with priority
- **Timetable**: Create, manage, link courses
- **Scenarios**: Build decision trees for alternatives
- **Registration**: Real-time simulation with mark-and-submit workflow
  - Mark course results (SUCCESS/FAILED/CANCELED) locally
  - Resume sessions after CLI restart
  - Automatic navigation to alternatives
- **Debugging**: `--details` flag shows full request/response
- **Terminal Control**: `--clear` flag clears screen
- **Token Management**: Automatic JWT injection

## Usage

```bash
cd app/cli-client && dart pub get

# Auth
dart run bin/uniplan.dart auth login test@test.com password123
dart run bin/uniplan.dart auth signup new@test.com pass123 "Name"

# Courses
dart run bin/uniplan.dart courses list --details
dart run bin/uniplan.dart courses search "컴퓨터" --clear
dart run bin/uniplan.dart courses import output/transformed_2025_1.json

# User
dart run bin/uniplan.dart user profile

# Wishlist
dart run bin/uniplan.dart wishlist add COURSE123 --priority HIGH
dart run bin/uniplan.dart wishlist list

# Timetable
dart run bin/uniplan.dart timetable create "Plan A"
dart run bin/uniplan.dart timetable add-course 1 COURSE123

# Scenarios
dart run bin/uniplan.dart scenario create 1 "CS101 fails"
dart run bin/uniplan.dart scenario link 1 COURSE123 2

# Registration
dart run bin/uniplan.dart registration start 1
dart run bin/uniplan.dart registration mark COURSE123 SUCCESS
dart run bin/uniplan.dart registration submit

# Compile (optional)
dart compile exe bin/uniplan.dart -o uniplan
```

## Token Storage

Tokens stored at `~/.uniplan/token.json`, auto-injected in authenticated requests.

## Reference Docs

- README: `README.md`
- Usage Guide: `USAGE_GUIDE.md`
