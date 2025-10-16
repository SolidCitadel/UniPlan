# Course Crawler

## 1. 개요

이 스크립트는 각 대학교의 수강편람 웹사이트에서 강의 정보를 크롤링하여 `catalog-service`에서 사용할 수 있는 표준 형식의 `JSON` 파일로 저장하는 역할을 합니다.

이 크롤러는 `catalog-service`와 독립적으로 실행되며, 데이터베이스에 직접 접근하지 않습니다.

## 2. 주요 기능

- 지정된 대학교의 강의 정보 페이지에서 데이터를 수집합니다.
- 수집된 데이터를 `catalog-service`의 데이터 모델에 맞는 `JSON` 형식으로 변환합니다.
- 변환된 데이터를 `.json` 파일로 저장합니다.

## 3. 실행 방법

1.  **의존성 설치**:
    ```bash
    pip install -r requirements.txt
    ```

2.  **크롤러 실행** (예시):
    ```bash
    python crawl_courses.py --school INHA_UNIVERSITY --year 2024 --semester FIRST
    ```
    - 실행 결과로 `output/courses_inha_2024_first.json`과 같은 파일이 생성됩니다.

## 4. JSON 출력 형식

생성되는 JSON 파일은 `Course` 객체의 리스트 형태이며, 각 객체의 구조는 다음과 같습니다. `catalog-service`의 `Course` 엔티티와 일치해야 합니다.

```json
[
  {
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
  },
  {
    "openingYear": 2024,
    "semester": "1학기",
    "targetGrade": "2",
    "courseCode": "ARC1010",
    "courseName": "건축학개론",
    "professor": "이순신",
    "credits": 3,
    "classTime": "화3,목4",
    "classroom": "8-101",
    "courseType": "전공기초",
    "campus": "용현",
    "college": "건축대학",
    "department": "건축학과",
    "notes": "실습 포함"
  }
]
```

## 5. 기술 스택

- **Language**: Python
- **Crawling Libraries**: BeautifulSoup, requests (또는 Scrapy)
- **의존성 관리**: `requirements.txt`

