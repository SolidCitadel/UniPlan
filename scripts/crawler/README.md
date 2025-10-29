# Course Crawler

## 1. 개요

경희대학교 수강신청 시스템에서 강의 정보를 크롤링하여 catalog-service에서 사용할 수 있는 형식으로 변환합니다.

### 핵심 설계 철학: 5-Step 독립 워크플로우

크롤링은 시간이 오래 걸리고 서버에 부담을 주므로, **각 단계를 독립적으로 반복 가능**하게 설계했습니다.
**모든 raw 데이터를 보존**하여 언제든 재가공할 수 있습니다.

```
Step 1: Metadata 크롤링 및 저장 (매우 빠름, ~1초)
  python crawl_metadata.py --year 2025 --semester 1
  ↓ 1-1. data_js_raw_2025_1.js (221KB)
      - data.js 파일 원본 그대로 저장
  ↓ 1-2. metadata_2025_1.json (119KB)
      - 49개 대학 (colleges)
      - 437개 학과 (departments)
      - 20개 이수구분 코드 (courseTypes)

Step 2: Courses 크롤링 및 저장 (느림, ~4분, 1회만!)
  python run_crawler.py --year 2025 --semester 1
  - 저장된 metadata에서 학과 목록 로드 ✅
  - 학과별로 API 크롤링 (2차 크롤링)
  ↓ courses_raw_2025_1.json
      - Raw API 응답 그대로 저장
      - 학과 코드별로 그룹화된 구조
      - departments: { "A10451": { "name": "...", "courses": [...] } }

Step 3: Courses 변환 (빠름, ~1초, 반복 가능! ⭐)
  python transformer.py \
    --metadata output/metadata_2025_1.json \
    --courses output/courses_raw_2025_1.json
  ↓ transformed_2025_1.json
      - catalog-service 형식으로 변환
      - metadata와 courses 조인
      - 같은 강의 중복 제거 (여러 학과에 속한 과목 처리)
      - 결과 확인 → 만족할 때까지 반복!

Step 4: 서버 업로드
  python upload_to_service.py --year 2025 --semester 1
  - catalog-service에 직접 전송
  - 중복 자동 스킵
```

**장점**:
1. **Raw 데이터 보존**: data.js 원본과 API 응답을 모두 저장
2. **재가공 가능**: 파서 수정 후 raw 데이터로 재변환 가능
3. **Metadata 1회**: 하드코딩 제거, 이수구분 코드 자동 추출
4. **2단계 크롤링**: 1차 metadata → 2차 courses (저장된 metadata 활용)
5. **학과별 그룹화**: 학과 코드별로 데이터 구조화 및 저장
6. **Crawling 1회**: 시간/서버 부담 최소화 (약 4분 → 1회만!)
7. **변환 반복**: 로컬에서 즉시 테스트 (data_parser.py 수정 → 재실행)
8. **서비스 단순**: catalog-service는 단순 import만 (재배포 불필요)
9. **중복 자동 처리**: 여러 학과에 속한 강의 자동 병합

## 2. 주요 기능

### Metadata 크롤링 (crawl_metadata.py)
- data_YYYY.js 파일에서 메타데이터 추출
- **colleges**: 대학 목록 (코드, 한글명, 영문명)
- **departments**: 학과 목록 (코드, 한글명, 영문명, 소속 대학)
- **courseTypes**: 이수구분 코드 (gradIsuCd_YYYY에서 자동 추출)

### Courses 크롤링 (run_crawler.py)
- API 기반 크롤링 (Selenium 불필요)
- **저장된 metadata에서 학과 목록 로드** (다시 크롤링하지 않음!)
- 학과별로 순차 크롤링 (2차 크롤링)
- 선택적 크롤링 지원:
  - `--limit N`: 처음 N개 학과만
  - `--departments A10451,A00430`: 특정 학과만
- **학과 코드별로 그룹화하여 저장** (departments: {...})

### 변환 (transformer.py)
- metadata + courses_raw 조인
- catalog-service 형식으로 변환
- **하드코딩 제거**: 모든 매핑이 metadata 기반
- **DB 정규화 구조** (코드 기반):
  - classTime: List[{day, startTime, endTime}]
  - departmentCode: 학과 코드 (metadata의 departments FK)
  - courseTypeCode: 이수구분 코드 (metadata의 courseTypes FK)
  - 이름 중복 제거, DB join으로 이름 조회

## 3. 빠른 시작

### 설치

```bash
cd scripts/crawler

# 가상환경 생성 (최초 1회만)
python -m venv venv

# 가상환경 활성화
# Windows
venv\Scripts\activate
# Mac/Linux
source venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
```

### 실행 (전체 워크플로우)

```bash
# Step 1: Metadata 크롤링 (~1초)
# → data_js_raw_2025_1.js + metadata_2025_1.json 생성
python crawl_metadata.py --year 2025 --semester 1

# Step 2: Courses 크롤링 (테스트: 처음 5개 학과)
# → metadata_2025_1.json에서 학과 목록 로드 후 크롤링
python run_crawler.py --year 2025 --semester 1 --limit 5

# Step 3: 변환
# → 학과별 그룹화된 데이터를 하나의 리스트로 변환
python transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json

# 결과 확인
cat output/transformed_2025_1.json | head -100

# 만족스럽지 않으면?
# → data_parser.py 수정
# → Step 3만 다시 실행!
```

### 전체 크롤링 (실전)

```bash
# Step 1: Metadata 크롤링 (1차)
python crawl_metadata.py --year 2025 --semester 1

# Step 2: 전체 437개 학과 크롤링 (~4분, 2차)
# → metadata_2025_1.json에서 학과 목록 자동 로드
python run_crawler.py --year 2025 --semester 1

# Step 3: 변환
# → 학과별 그룹 데이터를 통합하여 변환
python transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json

# Step 4: catalog-service로 업로드 (간편 모드 - 권장!)
python upload_to_service.py --year 2025 --semester 1

# 또는 파일 경로 직접 지정
python upload_to_service.py --file output/transformed_2025_1.json

# 또는 curl 사용 (직접 연결)
curl -X POST http://localhost:8083/courses/import \
  -H "Content-Type: application/json" \
  -d @output/transformed_2025_1.json
```

## 4. 출력 형식

### Metadata (metadata_2025_1.json)

```json
{
  "year": 2025,
  "semester": 1,
  "crawled_at": "2025-10-24T00:51:07",
  "colleges": {
    "A00422": {
      "name": "정경대학",
      "nameEn": "College of Politics & Economics",
      "code": "A00422"
    }
  },
  "departments": {
    "A10451": {
      "name": "정경대학 국제통상·금융투자학부",
      "nameEn": "College of Politics & Economics School of...",
      "code": "A10451",
      "collegeCode": "A00422",
      "level": "20"
    }
  },
  "courseTypes": {
    "04": {
      "nameKr": "전공필수",
      "nameEn": "Essential Major Studies",
      "code": "04"
    }
  }
}
```

### Raw Courses (courses_raw_2025_1.json)

**학과 코드별로 그룹화된 구조**:

```json
{
  "year": 2025,
  "semester": 1,
  "crawled_at": "2025-10-24T00:39:35",
  "total_courses": 5000,
  "total_departments": 437,
  "departments": {
    "A10627": {
      "name": "소프트웨어융합학과",
      "course_count": 45,
      "courses": [
        {
          "subjt_cd": "CSE302",
          "subjt_name": "컴퓨터네트워크",
          "teach_na": "이성원",
          "unit_num": "  3.0",
          "timetable": "월 15:00-16:15 (B01)<BR>수 15:00-16:15 (B01)",
          "campus_nm": "국제",
          "lect_grade": 3,
          "field_gb": "04",
          "class_cd": "A10627",
          "bigo": " "
        }
      ]
    },
    "A10451": {
      "name": "정경대학 국제통상·금융투자학부",
      "course_count": 32,
      "courses": [...]
    }
  }
}
```

### Transformed (transformed_2025_1.json)

```json
[
  {
    "openingYear": 2025,
    "semester": "1학기",
    "targetGrade": "3",
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
    "campus": "국제",
    "departmentCodes": ["A10627"],
    "notes": ""
  }
]
```

**주요 변환 (코드 기반, DB 정규화)** 🔥:
- `classTime`: 문자열 → **List[{day, startTime, endTime}]** (DB 친화적!)
- `departmentCodes`: **List[String]** - 여러 학과에 속한 강의 지원 (Many-to-Many)
- `courseTypeCode`: field_gb 직접 사용 (metadata의 courseTypes 참조)
- `semester`: 1 → "1학기", 2 → "2학기"
- `section`: 분반 번호 추가
- **DB 정규화**: 이름 대신 코드 사용으로 중복 제거 및 join 가능
- **중복 자동 병합**: 같은 강의가 여러 학과 API에 나오면 departmentCodes에 모두 추가

## 5. 프로젝트 구조

```
scripts/crawler/
├── config/
│   └── khu_config.py              # 설정 (URL, 학기 코드 매핑)
├── crawler/
│   ├── khu_crawler.py             # API 크롤러 (메인)
│   ├── data_js_parser.py          # data_YYYY.js 파서
│   ├── data_parser.py             # 데이터 변환 (핵심!)
│   └── validator.py               # 데이터 검증
├── tests/                         # 테스트 파일 모음
│   ├── README.md                  # 테스트 설명서
│   ├── test_quick.py              # 빠른 파싱 테스트
│   ├── test_multiple_depts.py     # 여러 학과 테스트
│   └── test_full_crawler.py       # 전체 워크플로우 테스트
├── output/                        # 크롤링 결과 저장
│   ├── data_js_raw_YYYY_S.js      # Raw data.js (221KB)
│   ├── metadata_YYYY_S.json       # 메타데이터 (119KB)
│   ├── courses_raw_YYYY_S.json    # Raw 강의 데이터
│   └── transformed_YYYY_S.json    # 변환 데이터 (catalog-service용)
├── crawl_metadata.py              # Step 1: Metadata 크롤러 ⭐
├── run_crawler.py                 # Step 2: Courses 크롤러 ⭐
├── transformer.py                 # Step 3: 변환 ⭐
├── upload_to_service.py           # catalog-service로 업로드 ⭐
├── requirements.txt
├── .gitignore
└── README.md
```

## 6. 기술 스택

- **Language**: Python 3.x
- **HTTP Client**: requests (Selenium 불필요!)
- **Data Parsing**: re (정규표현식), json
- **의존성 관리**: requirements.txt

## 7. 중요 사항

### API 특징
- **Referer 헤더 필수**: 없으면 404 에러 발생
- **학과별 순차 크롤링**: p_major 파라미터가 필수
- **학과 간 딜레이**: 0.5초 (서버 부하 방지)

### 학기 코드 매핑 (복잡함 주의!)
두 가지 서로 다른 매핑이 존재합니다:

1. **API 파라미터 (p_term)**:
   - 1학기 → "20"
   - 2학기 → "10"

2. **data.js 변수명 (major_YYYYMM)**:
   - 1학기 → "202510" (major_202510)
   - 2학기 → "202520" (major_202520)

config/khu_config.py에서 자동 처리합니다.

## 8. 트러블슈팅

### Metadata 파일 없음
```
ERROR: Metadata file not found: output/metadata_2025_1.json
```
→ Step 1을 먼저 실행: `python crawl_metadata.py --year 2025 --semester 1`

### 404 에러
- Referer 헤더 확인 (자동 설정됨)
- config/khu_config.py의 LOGIN_REFERER 확인

### 빈 응답 또는 0개 강의
- 년도와 학기 확인
- metadata에 해당 학과가 존재하는지 확인
- API URL 변경 여부 확인

### 변환 결과가 이상함
- data_parser.py 수정
- **Step 3만 다시 실행** (크롤링 불필요!)

## 9. 다음 단계

### catalog-service 구현

catalog-service는 **변환 로직 없이 단순 저장만** 합니다.

```java
@RestController
@RequestMapping("/api/courses")
public class CourseImportController {

    @Autowired
    private CourseRepository courseRepository;

    @PostMapping("/import")
    public ResponseEntity<?> importCourses(@RequestBody List<Course> courses) {
        // 변환 없이 바로 저장!
        courseRepository.saveAll(courses);
        return ResponseEntity.ok(Map.of("imported", courses.size()));
    }
}
```

### Course Entity (JPA)

```java
@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer openingYear;
    private String semester;
    private String targetGrade;
    private String courseCode;
    private String courseName;
    private String professor;
    private Integer credits;

    // JSON으로 저장하거나 별도 테이블로 분리
    @Column(columnDefinition = "json")
    private String classTime;  // JSON: [{"day":"월","startTime":"15:00","endTime":"16:15"}]

    private String classroom;
    private String courseTypeCode;    // FK to CourseType (metadata)
    private String campus;
    private String departmentCode;    // FK to Department (metadata)
    private String notes;
}
```

**DB 정규화**: courseTypeCode와 departmentCode는 metadata의 코드를 참조합니다.

또는 **classTime을 별도 테이블로 분리**:

```java
@Entity
public class ClassTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Course course;

    private String day;          // "월", "화", ...
    private String startTime;    // "15:00"
    private String endTime;      // "16:15"
}
```

## 10. 참고 문서

- **FIELD_MAPPING.md**: API 응답 구조 상세
- **sample_data_tiny.txt**: data_YYYY.js 샘플
- **sample_list.txt**: 강의 목록 API 응답 샘플
- **tests/README.md**: 테스트 스크립트 설명

## 11. 장점 요약

1. ✅ **하드코딩 제거**: 이수구분, 대학, 학과 모두 동적 로드
2. ✅ **크롤링 1회**: 시간/서버 부담 최소화 (~4분 → 1회만!)
3. ✅ **변환 반복**: 로컬에서 즉시 테스트 (~1초)
4. ✅ **서비스 단순**: catalog-service는 변환 로직 없음
5. ✅ **디버깅 용이**: 각 단계 독립적으로 검증
6. ✅ **DB 친화적**: classTime을 구조화된 List로 변환
7. ✅ **선택적 크롤링**: 필요한 학과만 크롤링 가능
8. ✅ **다른 학교 추가 쉬움**: metadata crawler + transformer만 추가
