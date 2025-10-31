# UniPlan CLI - Complete User Scenario Guide

This guide walks through the complete user journey from login to course registration simulation.

## Prerequisites

1. Backend services must be running:
   ```bash
   cd app/backend
   ./gradlew :api-gateway:bootRun
   ./gradlew :user-service:bootRun
   ./gradlew :catalog-service:bootRun
   ./gradlew :planner-service:bootRun
   ```

2. Install CLI dependencies:
   ```bash
   cd app/cli-client
   dart pub get
   ```

## Complete User Scenario

### Step 1: Authentication

#### 1.1 Create Account
```bash
dart run bin/uniplan.dart auth signup student@test.com password123 "Student Name"
```

**Expected Output:**
```
Account created successfully!
Email: student@test.com
Name: Student Name
```

#### 1.2 Login (if already have account)
```bash
dart run bin/uniplan.dart auth login student@test.com password123
```

**Expected Output:**
```
Successfully logged in!
Email: student@test.com
```

The JWT tokens are now stored in `~/.uniplan/token.json` and will be automatically used for subsequent requests.

---

### Step 2: Browse Courses

#### 2.1 List All Courses
```bash
dart run bin/uniplan.dart courses list
```

**Expected Output:**
```
Courses (N)
===========
Code    | Name              | Professor | Credits | Department
-----------------------------------------------------------
CSE101  | 프로그래밍 기초   | 김철수    | 3       | A10627
CSE102  | 자료구조          | 이영희    | 3       | A10627
...
```

#### 2.2 Search for Specific Courses
```bash
dart run bin/uniplan.dart courses search "컴퓨터"
```

**Expected Output:**
```
Search Results (5)
==================
Code    | Name              | Professor | Credits
-----------------------------------------------
CSE302  | 컴퓨터네트워크     | 이성원    | 3
...
```

#### 2.3 Get Detailed Course Information
```bash
dart run bin/uniplan.dart courses get CSE302
```

**Expected Output:**
```
Course Details
==============
Course Code: CSE302
Course Name: 컴퓨터네트워크
Professor: 이성원
Credits: 3
...
```

---

### Step 3: Add Courses to Wishlist

Add courses you're interested in to your wishlist:

```bash
# Assuming course IDs are 1, 2, 3, 4, 5
dart run bin/uniplan.dart wishlist add 1
dart run bin/uniplan.dart wishlist add 2
dart run bin/uniplan.dart wishlist add 3
```

**Expected Output (for each):**
```
Course added to wishlist!
Course ID: 1
```

#### 3.1 View Your Wishlist
```bash
dart run bin/uniplan.dart wishlist list
```

**Expected Output:**
```
My Wishlist (3)
===============
ID | Course ID | Added At
---------------------------
1  | 1         | 2025-01-15T10:30:00Z
2  | 2         | 2025-01-15T10:31:00Z
3  | 3         | 2025-01-15T10:32:00Z
```

---

### Step 4: Create Timetables

#### 4.1 Create Base Timetable (Plan A)
```bash
dart run bin/uniplan.dart timetable create "Plan A - 기본 시간표" 2025 "1학기"
```

**Expected Output:**
```
Timetable created successfully!
ID: 1
Name: Plan A - 기본 시간표
Opening Year: 2025
Semester: 1학기
```

**Note the Timetable ID (1 in this example)**

#### 4.2 Add Courses to Timetable
```bash
# Add courses from your wishlist to the timetable
dart run bin/uniplan.dart timetable add-course 1 1
dart run bin/uniplan.dart timetable add-course 1 2
dart run bin/uniplan.dart timetable add-course 1 3
```

**Expected Output (for each):**
```
Course added to timetable!
Item ID: 1
Course ID: 1
```

#### 4.3 View Timetable
```bash
dart run bin/uniplan.dart timetable get 1
```

**Expected Output:**
```
Timetable Details
=================
ID: 1
Name: Plan A - 기본 시간표
Opening Year: 2025
Semester: 1학기

Courses (3):
  - Course ID: 1
  - Course ID: 2
  - Course ID: 3
```

#### 4.4 Create Alternative Timetables (Plan B, C)

Create alternative timetables for when courses fail:

```bash
# Plan B: If course 1 fails, take course 4 instead
dart run bin/uniplan.dart timetable create "Plan B - Course 1 fails" 2025 "1학기"
# Assuming this creates timetable ID 2
dart run bin/uniplan.dart timetable add-course 2 4
dart run bin/uniplan.dart timetable add-course 2 2
dart run bin/uniplan.dart timetable add-course 2 3

# Plan C: If course 2 fails, take course 5 instead
dart run bin/uniplan.dart timetable create "Plan C - Course 2 fails" 2025 "1학기"
# Assuming this creates timetable ID 3
dart run bin/uniplan.dart timetable add-course 3 1
dart run bin/uniplan.dart timetable add-course 3 5
dart run bin/uniplan.dart timetable add-course 3 3
```

#### 4.5 List All Your Timetables
```bash
dart run bin/uniplan.dart timetable list
```

**Expected Output:**
```
My Timetables (3)
=================
ID | Name                     | Year | Semester | Courses
-----------------------------------------------------------
1  | Plan A - 기본 시간표      | 2025 | 1학기     | 3
2  | Plan B - Course 1 fails  | 2025 | 1학기     | 3
3  | Plan C - Course 2 fails  | 2025 | 1학기     | 3
```

---

### Step 5: Create Decision Tree (Scenarios)

#### 5.1 Create Root Scenario (Plan A)
```bash
dart run bin/uniplan.dart scenario create "Plan A" 1
```

**Expected Output:**
```
Root scenario created successfully!
ID: 1
Name: Plan A
Timetable: Plan A - 기본 시간표
```

**Note the Scenario ID (1 in this example)**

#### 5.2 Create Alternative Scenarios

Create alternatives for when specific courses fail:

```bash
# If course 1 fails in scenario 1, go to Plan B (timetable 2)
dart run bin/uniplan.dart scenario alternative 1 "Plan B - Course 1 fails" 1 2

# If course 2 fails in scenario 1, go to Plan C (timetable 3)
dart run bin/uniplan.dart scenario alternative 1 "Plan C - Course 2 fails" 2 3
```

**Expected Output (for each):**
```
Alternative scenario created successfully!
ID: 2
Name: Plan B - Course 1 fails
Failed Course ID: 1
Timetable: Plan B - Course 1 fails
```

#### 5.3 View Scenario Tree
```bash
dart run bin/uniplan.dart scenario tree 1
```

**Expected Output:**
```
Scenario Tree
=============
Plan A (ID: 1)
  └─ Plan B - Course 1 fails (Course 1 fails) (ID: 2)
  └─ Plan C - Course 2 fails (Course 2 fails) (ID: 3)
```

#### 5.4 Test Navigation
```bash
# Simulate: If course 1 fails, which scenario should I use?
dart run bin/uniplan.dart scenario navigate 1 1
```

**Expected Output:**
```
Next scenario found!

Next Scenario
=============
ID: 2
Name: Plan B - Course 1 fails
Failed Course ID: 1
Timetable: Plan B - Course 1 fails
```

---

### Step 6: Real-time Registration Simulation

Now simulate the actual course registration with real-time navigation:

#### 6.1 Start Registration Session
```bash
dart run bin/uniplan.dart registration start 1
```

**Expected Output:**
```
Registration started!
ID: 1
Status: IN_PROGRESS
Start Scenario: Plan A

Current Scenario:
ID: 1
Name: Plan A

Current Timetable:
Name: Plan A - 기본 시간표

Courses in Current Timetable:
  - Course ID: 1
  - Course ID: 2
  - Course ID: 3
```

**Note the Registration ID (1 in this example)**

#### 6.2 Register Courses with Success/Failure

Simulate registering for courses one by one:

```bash
# Try to register for course 1 - SUCCESS
dart run bin/uniplan.dart registration step 1 1 SUCCESS
```

**Expected Output:**
```
Course 1 registered successfully!

Current Scenario:
ID: 1
Name: Plan A

Successfully Registered Courses:
  - Course ID: 1
```

```bash
# Try to register for course 2 - FAILED (out of seats)
dart run bin/uniplan.dart registration step 1 2 FAILED
```

**Expected Output:**
```
Course 2 registration failed!

Current Scenario:
ID: 3
Name: Plan C - Course 2 fails

Successfully Registered Courses:
  - Course ID: 1
```

**Note:** The system automatically navigated to Plan C because course 2 failed!

The current scenario is now Plan C, which has courses [1, 5, 3].

```bash
# Continue with Plan C - Register course 5
dart run bin/uniplan.dart registration step 1 5 SUCCESS
```

**Expected Output:**
```
Course 5 registered successfully!

Current Scenario:
ID: 3
Name: Plan C - Course 2 fails

Successfully Registered Courses:
  - Course ID: 1
  - Course ID: 5
```

```bash
# Register course 3
dart run bin/uniplan.dart registration step 1 3 SUCCESS
```

**Expected Output:**
```
Course 3 registered successfully!

Current Scenario:
ID: 3
Name: Plan C - Course 2 fails

Successfully Registered Courses:
  - Course ID: 1
  - Course ID: 5
  - Course ID: 3
```

#### 6.3 View Registration Progress
```bash
dart run bin/uniplan.dart registration get 1
```

**Expected Output:**
```
Registration Details
====================
ID: 1
Status: IN_PROGRESS
Start Scenario: Plan A

Current Scenario:
ID: 3
Name: Plan C - Course 2 fails

Current Timetable:
Name: Plan C - Course 2 fails

Courses in Current Timetable:
  - Course ID: 1
  - Course ID: 5
  - Course ID: 3

Successfully Registered Courses:
  - Course ID: 1
  - Course ID: 5
  - Course ID: 3

Registration Steps (4):
  1. Course 1: SUCCESS
  2. Course 2: FAILED
  3. Course 5: SUCCESS
  4. Course 3: SUCCESS
```

#### 6.4 Complete Registration
```bash
dart run bin/uniplan.dart registration complete 1
```

**Expected Output:**
```
Registration completed!
ID: 1
Status: COMPLETED
Start Scenario: Plan A
Succeeded Courses: 3
```

#### 6.5 View All Registrations
```bash
dart run bin/uniplan.dart registration list
```

**Expected Output:**
```
My Registrations (1)
====================
ID | Status    | Scenario | Succeeded
--------------------------------------
1  | COMPLETED | Plan A   | 3
```

---

## Summary of Complete Workflow

```bash
# 1. Authentication
dart run bin/uniplan.dart auth login student@test.com password123

# 2. Browse courses
dart run bin/uniplan.dart courses list
dart run bin/uniplan.dart courses search "컴퓨터"

# 3. Add to wishlist
dart run bin/uniplan.dart wishlist add 1
dart run bin/uniplan.dart wishlist add 2
dart run bin/uniplan.dart wishlist add 3
dart run bin/uniplan.dart wishlist list

# 4. Create timetables
dart run bin/uniplan.dart timetable create "Plan A" 2025 "1학기"
dart run bin/uniplan.dart timetable add-course 1 1
dart run bin/uniplan.dart timetable add-course 1 2
dart run bin/uniplan.dart timetable add-course 1 3

dart run bin/uniplan.dart timetable create "Plan B" 2025 "1학기"
dart run bin/uniplan.dart timetable add-course 2 4
dart run bin/uniplan.dart timetable add-course 2 2
dart run bin/uniplan.dart timetable add-course 2 3

# 5. Create decision tree
dart run bin/uniplan.dart scenario create "Plan A" 1
dart run bin/uniplan.dart scenario alternative 1 "Plan B - Course 1 fails" 1 2
dart run bin/uniplan.dart scenario tree 1

# 6. Simulate registration
dart run bin/uniplan.dart registration start 1
dart run bin/uniplan.dart registration step 1 1 SUCCESS
dart run bin/uniplan.dart registration step 1 2 FAILED  # Auto-navigates to Plan B
dart run bin/uniplan.dart registration step 1 4 SUCCESS
dart run bin/uniplan.dart registration step 1 3 SUCCESS
dart run bin/uniplan.dart registration complete 1
```

---

## Using with --details Flag

To see full HTTP request/response for debugging:

```bash
dart run bin/uniplan.dart courses list --details
```

This will show:
- HTTP method and URL
- Request headers (with masked tokens)
- Request body (if any)
- Response status code
- Response headers
- Response body

---

## Using with --clear Flag

To clear the terminal before output:

```bash
dart run bin/uniplan.dart scenario tree 1 --clear
```

This provides a cleaner view, especially useful for tree/table outputs.

---

## Tips

1. **Note IDs**: Always note the IDs returned when creating resources (timetables, scenarios, registrations). You'll need them for subsequent commands.

2. **Plan Ahead**: Create all timetables first, then create scenarios referencing those timetables.

3. **Test Navigation**: Use `scenario navigate` to test your decision tree before actual registration.

4. **Review Progress**: Use `registration get <id>` frequently to see the current state and next steps.

5. **Combine Flags**: You can combine `--details` and `--clear` for debugging complex scenarios:
   ```bash
   dart run bin/uniplan.dart registration step 1 2 FAILED --details --clear
   ```

---

## Troubleshooting

### "Not logged in"
Run `dart run bin/uniplan.dart auth login <email> <password>` first.

### "Invalid timetable ID"
Make sure the timetable exists and you're using the correct ID from the creation response.

### "Navigation failed: No alternative scenario found"
Create an alternative scenario for that failed course using `scenario alternative`.

### Backend connection errors
Ensure all backend services are running on their respective ports (8080, 8081, 8082, 8083).
