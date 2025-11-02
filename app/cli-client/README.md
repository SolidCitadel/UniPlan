# UniPlan CLI Client

A command-line interface for testing UniPlan backend APIs.

## Prerequisites

- Dart SDK 3.0.0 or higher
- UniPlan backend services running (default: http://localhost:8080)

## Installation

```bash
# Install dependencies
dart pub get

# Run in interactive mode (recommended)
dart run bin/uniplan.dart

# Or run one-shot commands
dart run bin/uniplan.dart <command> [arguments] [options]

# Or compile to executable
dart compile exe bin/uniplan.dart -o uniplan
./uniplan
```

## Usage Modes

### Interactive Mode (Recommended)

The CLI now supports interactive mode for a better user experience. Simply run without arguments:

```bash
dart run bin/uniplan.dart
```

You'll enter an interactive shell where you can type commands directly:

```
============================================================
  UniPlan CLI - Interactive Mode
============================================================

Type help for available commands
Type exit or quit to exit

uniplan> auth login test@test.com password123
uniplan> wishlist add 123
uniplan> timetable create "Plan A" 2025 "1학기"
uniplan> help
uniplan> exit
```

Interactive mode features:
- **Simplified commands**: Just type `auth login email password` instead of `dart run bin/uniplan.dart auth login email password`
- **Built-in help**: Type `help` or `?` to see all available commands
- **Clear screen**: Type `clear` or `cls` to clear the terminal
- **Details toggle**: Type `details on` to enable HTTP request/response logging, `details off` to disable
- **Exit**: Type `exit` or `quit` to exit
- **Persistent session**: Tokens are automatically saved and reused across sessions
- **Color-coded output**: Enhanced readability with colors
- **UTF-8 support**: Properly displays Korean and other Unicode characters

### One-Shot Mode

You can still run individual commands directly from the command line:

```bash
dart run bin/uniplan.dart auth login test@test.com password123
dart run bin/uniplan.dart courses list
```

## Commands

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
# Add course to wishlist with priority (1-5)
dart run bin/uniplan.dart wishlist add <courseId> <priority>

# Examples
dart run bin/uniplan.dart wishlist add 123 1    # Highest priority
dart run bin/uniplan.dart wishlist add 456 3    # Medium priority

# View your wishlist
dart run bin/uniplan.dart wishlist list

# Remove course from wishlist
dart run bin/uniplan.dart wishlist remove <courseId>

# Check if course is in wishlist
dart run bin/uniplan.dart wishlist check <courseId>
```

**Priority Levels:**
- `1` - Highest priority (must-have course)
- `2` - High priority
- `3` - Medium priority
- `4` - Low priority
- `5` - Lowest priority (backup option)

### Timetable (시간표)

```bash
# Create new timetable
dart run bin/uniplan.dart timetable create <name> <year> <semester>

# Create alternative timetable (copy with excluded courses)
dart run bin/uniplan.dart timetable alternative <baseTimetableId> <name> <excludedCourseId1> [excludedCourseId2...]

# Examples
dart run bin/uniplan.dart timetable alternative 1 "Plan B - CS101 failed" 101
dart run bin/uniplan.dart timetable alternative 1 "Plan C - Multiple failed" 101 102

# List all your timetables
dart run bin/uniplan.dart timetable list

# Get timetable details (shows excludedCourseIds if any)
dart run bin/uniplan.dart timetable get <timetableId>

# Add course to timetable (validates against excludedCourseIds)
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

### Korean Character Display (한글 표시)

If Korean characters appear garbled in PowerShell/CMD:

**PowerShell:**
```powershell
# Set UTF-8 encoding for current session
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Or permanently in PowerShell profile ($PROFILE)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

**CMD:**
```cmd
chcp 65001
```

**Recommended**: Use **Windows Terminal** or **PowerShell 7+** for the best Unicode support.

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
