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

| 필드명          | 데이터 타입    | 설명                               | 예시                               |
| --------------- | -------------- | ---------------------------------- | ---------------------------------- |
| `id`            | `Long`         | PK                                 | `1`                                |
| `openingYear`   | `Int`          | 개설년도                           | `2024`                             |
| `semester`      | `String`       | 개설학기                           | `"1학기"`, `"여름학기"`            |
| `targetGrade`   | `String`       | 대상학년                           | `"3학년"`                          |
| `courseCode`    | `String`       | 강좌코드 (학수번호)                | `"CSE1234"`                        |
| `courseName`    | `String`       | 강좌명                             | `"자료구조"`                       |
| `professor`     | `String`       | 교수명                             | `"홍길동"`                         |
| `credits`       | `Int`          | 학점                               | `3`                                |
| `classTime`     | `String`       | 강의시간                           | `"월1,수2"`                        |
| `classroom`     | `String`       | 강의실                             | `"6호관 201호"`                    |
| `courseType`    | `String`       | 이수구분                           | `"전공필수"`, `"교양"`             |
| `campus`        | `String`       | 캠퍼스                             | `"용현캠퍼스"`                     |
| `college`       | `String`       | 개설 단과대학                      | `"공과대학"`                       |
| `department`    | `String`       | 개설학과                           | `"컴퓨터공학과"`                   |
| `notes`         | `String`       | 특이사항 (비고)                    | `"팀 프로젝트 포함"`               |

## 4. API 명세

### `POST /api/v1/admin/courses/upload`

- **설명**: 관리자가 크롤링된 강의 정보가 담긴 `JSON` 파일을 업로드하여 DB에 저장합니다. (관리자 전용 API)
- **요청**: `multipart/form-data` 형식으로 `JSON` 파일 전송
- **성공 응답 (200 OK)**:
  ```json
  {
    "message": "JSON 파일이 성공적으로 처리되었습니다.",
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
        "targetGrade": "3",
        "courseCode": "CSE1234",
        "courseName": "자료구조",
        "professor": "홍길동",
        "credits": 3,
        "classTime": "월1,수2",
        "classroom": "6-201",
        "courseType": "전공필수",
        "campus": "용현",
        "college": "공과대학",
        "department": "컴퓨터공학과",
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
    "targetGrade": "3",
    "courseCode": "CSE1234",
    "courseName": "자료구조",
    "professor": "홍길동",
    "credits": 3,
    "classTime": "월1,수2",
    "classroom": "6-201",
    "courseType": "전공필수",
    "campus": "용현",
    "college": "공과대학",
    "department": "컴퓨터공학과",
    "notes": ""
  }
  ```

## 5. 기술 스택

- **Language**: Kotlin
- **Framework**: Spring Boot 3.x
- **Build Tool**: Gradle (Kotlin DSL)
- **Database**: MySQL
