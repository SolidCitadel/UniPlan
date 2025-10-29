# catalog-service

## 1. 개요

`catalog-service`는 UniPlan 프로젝트의 마이크로서비스 중 하나로, 대학 강의 정보(Course Catalog)를 관리하고 다른 서비스에 API 형태로 제공하는 역할을 담당합니다.

주요 기능은 외부에서 생성된 강의 정보 파일(JSON)을 데이터베이스에 저장하고, 사용자가 시간표를 계획하는 데 필요한 강의 정보를 조회할 수 있는 API를 제공하는 것입니다.

## 2. 주요 기능

- **강의 데이터 일괄 등록**: 관리자가 제공하는 JSON 파일을 통해 대량의 강의 정보를 DB에 등록합니다.
- **강의 정보 조회 API**: 저장된 강의 정보를 조건별로 검색하고 조회하는 REST API를 제공합니다.
- **강의 데이터 관리**: 데이터베이스의 강의 정보를 관리합니다.

## 3. 데이터 모델 (Course Entity)

`catalog-service`에서 관리하는 핵심 데이터 모델은 `Course`입니다.

### 3.1 Course (강의)

| 필드명          | 데이터 타입           | 설명                               | 예시                               |
| --------------- | --------------------- | ---------------------------------- | ---------------------------------- |
| `id`            | `Long`                | PK                                 | `1`                                |
| `openingYear`   | `Integer`             | 개설년도                           | `2024`                             |
| `semester`      | `String`              | 개설학기                           | `"1학기"`, `"여름학기"`            |
| `targetGrade`   | `Integer`             | 대상학년                           | `3`                                |
| `courseCode`    | `String`              | 강좌코드 (학수번호)                | `"CSE1234"`                        |
| `section`       | `String`              | 분반번호                           | `"01"`, `"02"`                     |
| `courseName`    | `String`              | 강좌명                             | `"자료구조"`                       |
| `professor`     | `String`              | 교수명                             | `"홍길동"`                         |
| `credits`       | `Integer`             | 학점                               | `3`                                |
| `classTimes`    | `List<ClassTime>`     | 강의시간 (외래키: ClassTime)       | -                                  |
| `classroom`     | `String`              | 강의실                             | `"6호관 201호"`                    |
| `courseType`    | `CourseType`          | 이수구분 (외래키: CourseType)      | -                                  |
| `campus`        | `String`              | 캠퍼스                             | `"용현"`, `"국제"`                 |
| `department`    | `Department`          | 개설학과 (외래키: Department)      | -                                  |
| `notes`         | `String`              | 특이사항 (비고)                    | `"팀 프로젝트 포함"`               |

### 3.2 ClassTime (강의시간)

| 필드명          | 데이터 타입    | 설명                               | 예시                               |
| --------------- | -------------- | ---------------------------------- | ---------------------------------- |
| `id`            | `Long`         | PK                                 | `1`                                |
| `course`        | `Course`       | 강의 (외래키: Course)              | -                                  |
| `day`           | `String`       | 요일                               | `"월"`, `"화"`, `"수"`             |
| `startTime`     | `LocalTime`    | 시작시간                           | `15:00`                            |
| `endTime`       | `LocalTime`    | 종료시간                           | `16:15`                            |

### 3.3 Department (학과)

| 필드명          | 데이터 타입    | 설명                               | 예시                               |
| --------------- | -------------- | ---------------------------------- | ---------------------------------- |
| `id`            | `Long`         | PK                                 | `1`                                |
| `code`          | `String`       | 학과코드 (고유)                    | `"A10627"`                         |
| `name`          | `String`       | 학과명 (한글)                      | `"컴퓨터공학과"`                   |
| `nameEn`        | `String`       | 학과명 (영문)                      | `"Computer Science and Engineering"` |
| `college`       | `College`      | 단과대학 (외래키: College)         | -                                  |
| `level`         | `String`       | 레벨 (학부/대학원)                 | `"1"`, `"2"`                       |

### 3.4 College (단과대학)

| 필드명          | 데이터 타입    | 설명                               | 예시                               |
| --------------- | -------------- | ---------------------------------- | ---------------------------------- |
| `id`            | `Long`         | PK                                 | `1`                                |
| `code`          | `String`       | 단과대학코드 (고유)                | `"B01"`                            |
| `name`          | `String`       | 단과대학명 (한글)                  | `"공과대학"`                       |
| `nameEn`        | `String`       | 단과대학명 (영문)                  | `"College of Engineering"`         |

### 3.5 CourseType (이수구분)

| 필드명          | 데이터 타입    | 설명                               | 예시                               |
| --------------- | -------------- | ---------------------------------- | ---------------------------------- |
| `id`            | `Long`         | PK                                 | `1`                                |
| `code`          | `String`       | 이수구분코드 (고유)                | `"01"`, `"04"`                     |
| `nameKr`        | `String`       | 이수구분명 (한글)                  | `"전공필수"`, `"교양"`             |
| `nameEn`        | `String`       | 이수구분명 (영문)                  | `"Major Required"`, `"Liberal Arts"` |

## 4. API 명세

### `POST /api/v1/metadata/import`

- **설명**: 크롤러에서 수집한 메타데이터(단과대학, 학과, 이수구분)를 일괄 등록합니다.
- **요청**: `application/json` 형식
- **요청 본문**:
  ```json
  {
    "year": 2025,
    "semester": "1학기",
    "colleges": [
      {
        "code": "B01",
        "name": "공과대학",
        "nameEn": "College of Engineering"
      }
    ],
    "departments": [
      {
        "code": "A10627",
        "name": "컴퓨터공학과",
        "nameEn": "Computer Science and Engineering",
        "collegeCode": "B01",
        "level": "1"
      }
    ],
    "courseTypes": [
      {
        "code": "04",
        "nameKr": "전공필수",
        "nameEn": "Major Required"
      }
    ]
  }
  ```
- **성공 응답 (200 OK)**:
  ```json
  {
    "message": "Import completed successfully",
    "totalCount": 150,
    "successCount": 150,
    "failureCount": 0
  }
  ```

### `POST /api/v1/courses/import`

- **설명**: 크롤러에서 변환한 강의 정보를 일괄 등록합니다.
- **요청**: `application/json` 형식 (List<CourseImportRequest>)
- **요청 본문**:
  ```json
  [
    {
      "openingYear": 2025,
      "semester": "1학기",
      "targetGrade": 3,
      "courseCode": "CSE302",
      "section": "01",
      "courseName": "컴퓨터네트워크",
      "professor": "이성원",
      "credits": 3,
      "classTime": [
        {
          "day": "월",
          "startTime": "15:00",
          "endTime": "16:15"
        },
        {
          "day": "수",
          "startTime": "15:00",
          "endTime": "16:15"
        }
      ],
      "classroom": "B01",
      "courseTypeCode": "04",
      "departmentCode": "A10627",
      "campus": "국제"
    }
  ]
  ```
- **성공 응답 (200 OK)**:
  ```json
  {
    "message": "Import completed successfully",
    "totalCount": 1520,
    "successCount": 1520,
    "failureCount": 0
  }
  ```

### `GET /api/v1/courses`

- **설명**: 조건에 맞는 강의 목록을 검색하고 페이징하여 반환합니다.
- **쿼리 파라미터**:
  - `page`: 페이지 번호 (기본값: `0`)
  - `size`: 페이지 크기 (기본값: `20`)
  - `courseName`: 강좌명 (부분 일치 검색)
  - `courseCode`: 강좌코드
  - `professor`: 교수명
  - `department`: 개설학과
  - `courseType`: 이수구분
- **성공 응답 (200 OK)**:
  ```json
  {
    "content": [
      {
        "id": 1,
        "openingYear": 2024,
        "semester": "1학기",
        "targetGrade": 3,
        "courseCode": "CSE1234",
        "section": "01",
        "courseName": "자료구조",
        "professor": "홍길동",
        "credits": 3,
        "classTimes": [
          {
            "id": 1,
            "day": "월",
            "startTime": "15:00:00",
            "endTime": "16:15:00"
          },
          {
            "id": 2,
            "day": "수",
            "startTime": "15:00:00",
            "endTime": "16:15:00"
          }
        ],
        "classroom": "6-201",
        "courseType": {
          "id": 1,
          "code": "04",
          "nameKr": "전공필수",
          "nameEn": "Major Required"
        },
        "campus": "용현",
        "department": {
          "id": 1,
          "code": "A10627",
          "name": "컴퓨터공학과",
          "nameEn": "Computer Science and Engineering",
          "college": {
            "id": 1,
            "code": "B01",
            "name": "공과대학",
            "nameEn": "College of Engineering"
          },
          "level": "1"
        },
        "notes": ""
      }
    ],
    "pageable": {
      "pageNumber": 0,
      "pageSize": 20,
      "offset": 0,
      "paged": true,
      "unpaged": false
    },
    "totalPages": 10,
    "totalElements": 198
  }
  ```

### `GET /api/v1/courses/{id}`

- **설명**: 특정 ID를 가진 강의의 상세 정보를 조회합니다.
- **성공 응답 (200 OK)**:
  ```json
  {
    "id": 1,
    "openingYear": 2024,
    "semester": "1학기",
    "targetGrade": 3,
    "courseCode": "CSE1234",
    "section": "01",
    "courseName": "자료구조",
    "professor": "홍길동",
    "credits": 3,
    "classTimes": [
      {
        "id": 1,
        "day": "월",
        "startTime": "15:00:00",
        "endTime": "16:15:00"
      },
      {
        "id": 2,
        "day": "수",
        "startTime": "15:00:00",
        "endTime": "16:15:00"
      }
    ],
    "classroom": "6-201",
    "courseType": {
      "id": 1,
      "code": "04",
      "nameKr": "전공필수",
      "nameEn": "Major Required"
    },
    "campus": "용현",
    "department": {
      "id": 1,
      "code": "A10627",
      "name": "컴퓨터공학과",
      "nameEn": "Computer Science and Engineering",
      "college": {
        "id": 1,
        "code": "B01",
        "name": "공과대학",
        "nameEn": "College of Engineering"
      },
      "level": "1"
    },
    "notes": ""
  }
  ```

## 5. 기술 스택

- **Language**: Java 21
- **Framework**: Spring Boot 3.x
- **Build Tool**: Gradle (Kotlin DSL)
- **Database**: MySQL (production), H2 (development/testing)
