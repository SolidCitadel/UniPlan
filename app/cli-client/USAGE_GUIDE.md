# UniPlan CLI Usage Guide

This guide provides detailed instructions and examples for using the UniPlan CLI client.

## Installation

### Prerequisites

1. Install Dart SDK (3.0.0 or higher)
   - Download from: https://dart.dev/get-dart
   - Verify installation: `dart --version`

2. Ensure UniPlan backend services are running
   - Default API URL: http://localhost:8080
   - See backend documentation for setup instructions

### Setup

```bash
cd app/cli-client

# Install dependencies
dart pub get

# Verify installation
dart run bin/uniplan.dart --help
```

### Compile to Executable (Optional)

For faster execution, compile the CLI to a native executable:

```bash
# Compile
dart compile exe bin/uniplan.dart -o uniplan

# Run
./uniplan --help  # Unix/Mac
uniplan.exe --help  # Windows
```

## Basic Usage

### Command Structure

```
uniplan <command> <subcommand> [arguments] [options]
```

### Global Options

These options can be used with any command:

- `--details` : Show detailed HTTP request/response logs
- `--clear` : Clear terminal screen before displaying output
- `--api-url <url>` : Override the default API base URL
- `--help` or `-h` : Show help message

## Authentication Commands

### Login

Login with your email and password to obtain access tokens.

```bash
dart run bin/uniplan.dart auth login <email> <password>
```

**Example:**
```bash
dart run bin/uniplan.dart auth login test@example.com mypassword123
```

**Output:**
```
Successfully logged in!
Email: test@example.com
```

**With details:**
```bash
dart run bin/uniplan.dart auth login test@example.com mypassword123 --details
```

This will show the full HTTP request and response:
```
HTTP REQUEST
Method: POST
URL: http://localhost:8080/api/v1/auth/login

Body:
{
  "email": "test@example.com",
  "password": "mypassword123"
}

HTTP RESPONSE
Status: 200

Body:
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIs..."
}

Successfully logged in!
Email: test@example.com
```

### Signup

Create a new account.

```bash
dart run bin/uniplan.dart auth signup <email> <password> <name>
```

**Example:**
```bash
dart run bin/uniplan.dart auth signup newuser@example.com password123 "John Doe"
```

**Output:**
```
Account created successfully!
Email: newuser@example.com
Name: John Doe
```

### Refresh Token

Refresh your access token using the stored refresh token.

```bash
dart run bin/uniplan.dart auth refresh
```

**Output:**
```
Access token refreshed successfully!
```

### Logout

Logout and clear stored tokens.

```bash
dart run bin/uniplan.dart auth logout
```

**Output:**
```
Logged out successfully!
```

## Course Commands

### List Courses

List all available courses.

```bash
dart run bin/uniplan.dart courses list
```

**With filters:**
```bash
# Filter by department
dart run bin/uniplan.dart courses list --department=A10627

# Multiple filters
dart run bin/uniplan.dart courses list --department=A10627 --semester=1
```

**Output:**
```
Courses (150)
===============
Code    | Name              | Professor | Credits | Department
-----------------------------------------------------------
CSE101  | 프로그래밍 기초   | 김철수    | 3       | A10627
CSE102  | 자료구조          | 이영희    | 3       | A10627
...
```

**Clear screen before output:**
```bash
dart run bin/uniplan.dart courses list --clear
```

### Search Courses

Search for courses by keyword.

```bash
dart run bin/uniplan.dart courses search <keyword>
```

**Examples:**
```bash
# Search in Korean
dart run bin/uniplan.dart courses search "컴퓨터"

# Search in English
dart run bin/uniplan.dart courses search "Computer"

# Search with details
dart run bin/uniplan.dart courses search "네트워크" --details
```

**Output:**
```
Search Results (5)
==================
Code    | Name              | Professor | Credits
-----------------------------------------------
CSE302  | 컴퓨터네트워크     | 이성원    | 3
CSE401  | 네트워크보안       | 박민수    | 3
...
```

### Get Course Details

Get detailed information about a specific course.

```bash
dart run bin/uniplan.dart courses get <course-code>
```

**Example:**
```bash
dart run bin/uniplan.dart courses get CSE302
```

**Output:**
```
Course Details
==============
Course Code: CSE302
Course Name: 컴퓨터네트워크
Professor: 이성원
Credits: 3
Opening Year: 2025
Semester: 1학기
Department Code: A10627
Course Type Code: 04
Campus: 국제
Classroom: B01

Class Time:
  월 15:00-16:15
  수 15:00-16:15
```

### Import Courses

Import courses from a JSON file to the backend.

```bash
dart run bin/uniplan.dart courses import <file-path>
```

**Example:**
```bash
dart run bin/uniplan.dart courses import scripts/crawler/output/transformed_2025_1.json
```

**Output:**
```
Reading file scripts/crawler/output/transformed_2025_1.json...
Importing courses to server...
Import completed!
Imported: 1523
Failed: 0
```

## User Commands

### Get Profile

Get your user profile information.

```bash
dart run bin/uniplan.dart user profile
```

**Output:**
```
User Profile
============
User ID: 1
Email: test@example.com
Name: John Doe
Role: STUDENT
Created At: 2025-01-15T10:30:00Z
Updated At: 2025-01-15T10:30:00Z
```

## Advanced Usage

### Using Custom API URL

If your backend is running on a different host/port:

```bash
dart run bin/uniplan.dart auth login test@test.com password --api-url http://192.168.1.100:8080
```

### Combining Options

You can combine multiple global options:

```bash
dart run bin/uniplan.dart courses search "알고리즘" --clear --details
```

This will:
1. Clear the terminal screen
2. Search for courses containing "알고리즘"
3. Show detailed HTTP request/response logs

### Debugging

For debugging API issues, always use the `--details` flag:

```bash
dart run bin/uniplan.dart courses list --details
```

This will show:
- Full HTTP request (method, URL, headers, body)
- Full HTTP response (status, headers, body)
- Any error messages from the server

### Token Storage

Tokens are stored in `~/.uniplan/token.json`:

**Windows:** `C:\Users\<username>\.uniplan\token.json`
**Mac/Linux:** `/home/<username>/.uniplan/token.json`

You can manually delete this file to clear your session:

```bash
# Unix/Mac
rm ~/.uniplan/token.json

# Windows PowerShell
Remove-Item ~\.uniplan\token.json
```

## Troubleshooting

### "Not logged in" Error

If you see this error, you need to login first:

```bash
dart run bin/uniplan.dart auth login <email> <password>
```

### "Network error" or "Connection refused"

Make sure the backend services are running:

```bash
# In the backend directory
cd app/backend
./gradlew :api-gateway:bootRun
```

### "HTTP 401: Unauthorized"

Your access token may have expired. Refresh it:

```bash
dart run bin/uniplan.dart auth refresh
```

If that fails, login again:

```bash
dart run bin/uniplan.dart auth login <email> <password>
```

### "HTTP 404: Not Found"

The requested resource doesn't exist. Check:
- Course code is correct
- API endpoints match backend implementation
- Backend services are properly configured

## Examples Workflow

### Complete Authentication Flow

```bash
# 1. Create account
dart run bin/uniplan.dart auth signup student@example.com pass123 "Student Name"

# 2. Login (if already have account)
dart run bin/uniplan.dart auth login student@example.com pass123

# 3. Check profile
dart run bin/uniplan.dart user profile

# 4. Logout when done
dart run bin/uniplan.dart auth logout
```

### Complete Course Management Flow

```bash
# 1. Login
dart run bin/uniplan.dart auth login admin@example.com adminpass

# 2. Import courses from crawler
dart run bin/uniplan.dart courses import scripts/crawler/output/transformed_2025_1.json

# 3. List all courses
dart run bin/uniplan.dart courses list

# 4. Search for specific courses
dart run bin/uniplan.dart courses search "프로그래밍"

# 5. Get details of a specific course
dart run bin/uniplan.dart courses get CSE101
```

## Tips

1. **Use tab completion**: If you compile to an executable and add it to your PATH, you can use shell tab completion.

2. **Alias for convenience**: Add an alias to your shell profile:
   ```bash
   # In .bashrc or .zshrc
   alias up='dart run bin/uniplan.dart'

   # Then use:
   up courses list
   up auth login test@test.com password
   ```

3. **Save credentials**: For testing, you can create a shell script:
   ```bash
   #!/bin/bash
   EMAIL="test@example.com"
   PASSWORD="testpass123"
   dart run bin/uniplan.dart auth login $EMAIL $PASSWORD
   ```

4. **Pipe output**: You can pipe the output to other tools:
   ```bash
   dart run bin/uniplan.dart courses list | grep "CSE"
   dart run bin/uniplan.dart user profile | tee profile.txt
   ```
