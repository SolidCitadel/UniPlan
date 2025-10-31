# UniPlan CLI Client

A command-line interface for testing UniPlan backend APIs.

## Prerequisites

- Dart SDK 3.0.0 or higher
- UniPlan backend services running (default: http://localhost:8080)

## Installation

```bash
# Install dependencies
dart pub get

# Run directly
dart run bin/uniplan.dart <command> [arguments] [options]

# Or compile to executable
dart compile exe bin/uniplan.dart -o uniplan
./uniplan <command> [arguments] [options]
```

## Usage

### Authentication

```bash
# Login
dart run bin/uniplan.dart auth login <email> <password>

# Signup
dart run bin/uniplan.dart auth signup <email> <password> <name>

# Refresh token
dart run bin/uniplan.dart auth refresh

# Logout
dart run bin/uniplan.dart auth logout
```

### Courses

```bash
# List all courses
dart run bin/uniplan.dart courses list

# Search courses
dart run bin/uniplan.dart courses search <keyword>

# Get course details
dart run bin/uniplan.dart courses get <course-code>

# Import courses from JSON file (admin only)
dart run bin/uniplan.dart courses import <file-path>
```

### Wishlist (희망과목)

```bash
# Add course to wishlist
dart run bin/uniplan.dart wishlist add <courseId>

# View your wishlist
dart run bin/uniplan.dart wishlist list

# Remove course from wishlist
dart run bin/uniplan.dart wishlist remove <courseId>

# Check if course is in wishlist
dart run bin/uniplan.dart wishlist check <courseId>
```

### Timetable (시간표)

```bash
# Create new timetable
dart run bin/uniplan.dart timetable create <name> <year> <semester>

# List all your timetables
dart run bin/uniplan.dart timetable list

# Get timetable details
dart run bin/uniplan.dart timetable get <timetableId>

# Add course to timetable
dart run bin/uniplan.dart timetable add-course <timetableId> <courseId>

# Remove course from timetable
dart run bin/uniplan.dart timetable remove-course <timetableId> <courseId>

# Delete timetable
dart run bin/uniplan.dart timetable delete <timetableId>
```

### Scenario (시나리오 & 의사결정 트리)

```bash
# Create root scenario (Plan A)
dart run bin/uniplan.dart scenario create <name> <timetableId>

# Create alternative scenario (Plan B, C...)
dart run bin/uniplan.dart scenario alternative <parentId> <name> <failedCourseId> <timetableId>

# List all root scenarios
dart run bin/uniplan.dart scenario list

# Get scenario details
dart run bin/uniplan.dart scenario get <scenarioId>

# View full scenario tree
dart run bin/uniplan.dart scenario tree <scenarioId>

# Test navigation
dart run bin/uniplan.dart scenario navigate <scenarioId> <failedCourseId>

# Delete scenario
dart run bin/uniplan.dart scenario delete <scenarioId>
```

### Registration (수강신청 시뮬레이션)

```bash
# Start registration with a scenario
dart run bin/uniplan.dart registration start <scenarioId>

# Add registration step (success or failure)
dart run bin/uniplan.dart registration step <registrationId> <courseId> <SUCCESS|FAILED>

# Get registration details
dart run bin/uniplan.dart registration get <registrationId>

# List all registrations
dart run bin/uniplan.dart registration list

# Complete registration
dart run bin/uniplan.dart registration complete <registrationId>

# Cancel registration
dart run bin/uniplan.dart registration cancel <registrationId>
```

### User

```bash
# Get user profile
dart run bin/uniplan.dart user profile
```

## Global Options

- `--details` : Show HTTP request/response details
- `--clear` : Clear terminal before output
- `--api-url <url>` : Override API base URL (default: http://localhost:8080)
- `--help` : Show help message

## Examples

```bash
# Login with details
dart run bin/uniplan.dart auth login test@test.com password123 --details

# Search courses with clear screen
dart run bin/uniplan.dart courses search "컴퓨터" --clear

# List courses with custom API URL
dart run bin/uniplan.dart courses list --api-url http://api.example.com
```

## Configuration

The CLI stores configuration and tokens in `~/.uniplan/`:
- `config.json` : Configuration settings
- `token.json` : JWT access and refresh tokens

## Complete User Scenario

For a complete walkthrough of the entire user journey (from login to registration), see:
**[SCENARIO_GUIDE.md](SCENARIO_GUIDE.md)**

This guide covers:
1. Authentication
2. Course browsing
3. Wishlist management
4. Timetable creation
5. Decision tree (scenarios) setup
6. Real-time registration simulation with automatic navigation

## Development

```bash
# Run tests
dart test

# Format code
dart format .

# Analyze code
dart analyze
```
