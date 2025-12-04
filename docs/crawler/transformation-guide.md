# 데이터 변환 가이드

## 개요

**크롤러에서 변환을 완료**하고, **catalog-service는 단순 import만** 합니다.

## 3-Step 독립 워크플로우

```
Step 1: Metadata 크롤링 (매우 빠름, ~1초)
   python crawl_metadata.py --year 2025 --semester 1
   ↓ metadata_2025_1.json
   - colleges (50개 대학)
   - departments (431개 학과)
   - courseTypes (16개 이수구분, 하드코딩 제거!)

Step 2: Courses 크롤링 (느림, ~4분, 1회만!)
   python run_crawler.py --year 2025 --semester 1
   ↓ courses_raw_2025_1.json
   - Raw API 응답 그대로
   - 각 course의 class_cd로 학과 참조

Step 3: 변환 (빠름, ~1초, 반복 가능!)
   python transformer.py \
     --metadata output/metadata_2025_1.json \
     --courses output/courses_raw_2025_1.json
   ↓ transformed_2025_1.json
   - catalog-service 형식
   - metadata와 courses 조인
```

### 왜 이렇게 설계했나?

1. **Metadata 분리**: 하드코딩 제거, 이수구분 코드 자동 추출
2. **Crawling 1회**: 시간/서버 부담 최소화 (약 4분 → 1회만!)
3. **변환 반복**: 로컬에서 즉시 테스트 (data_parser.py 수정 → 재실행)
4. **서비스 단순**: catalog-service는 변환 로직 불필요 (재배포 불필요)
5. **디버깅 용이**: 각 단계 독립적으로 검증 가능

---

## Metadata 구조

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

**자동 추출**:
- `colleges`: daehak_202510에서 추출
- `departments`: major_202510에서 추출 (collegeCode 포함!)
- `courseTypes`: gradIsuCd_2025에서 추출 (하드코딩 제거!)

---

## Raw 데이터 구조 (courses_raw)

```json
{
  "year": 2025,
  "semester": 1,
  "crawled_at": "2025-10-24T00:39:35",
  "total_courses": 5000,
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
      "bigo": " ",
      "lecture_cd": "CSE30202",
      "lecture_cd_disp": "CSE302-02",
      "all_apply": 58,
      "remain": 2,
      "comm_limit": 60,
      "eng_yn_nm": ""
    }
  ]
}
```

---

## 변환 로직 (transformer.py)

### 1. 기본 필드 매핑 (코드 기반, DB 정규화)

| catalog-service | Raw 필드 | 변환 로직 |
|-----------------|----------|-----------|
| `openingYear` | `metadata.year` | 그대로 사용 |
| `semester` | `metadata.semester` | 1→"1학기", 2→"2학기" |
| `courseCode` | `subjt_cd` | 그대로 사용 |
| `courseName` | `subjt_name` | 그대로 사용 |
| `professor` | `teach_na` | 그대로 사용 |
| `credits` | `unit_num` | `trim()` 후 int 변환 |
| `targetGrade` | `lect_grade` | String 변환 |
| `courseTypeCode` | `field_gb` | **코드 직접 사용 (metadata FK)** |
| `campus` | `campus_nm` | 그대로 사용 |
| `departmentCode` | `class_cd` | **코드 직접 사용 (metadata FK)** |
| `notes` | `bigo` | `trim()` |

### 2. classTime 파싱 (중요! DB 친화적!)

**Raw 데이터 예시**:
```
"화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"
"화 09:00-11:45 (구(한110))"
"월 13:00-14:50 (전205)<BR>수 13:00-14:50 (전205)"
```

**변환 로직**:

```python
def parse_class_time(timetable: str) -> list:
    """
    "화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"
    →
    [
      {"day": "화", "startTime": "15:00", "endTime": "16:15"},
      {"day": "목", "startTime": "15:00", "endTime": "16:15"}
    ]
    """
    time_slots = timetable.split('<BR>')
    parsed_times = []

    for slot in time_slots:
        # 강의실 정보 제거
        slot = re.sub(r'\s*\([^)]+\)', '', slot).strip()

        # 패턴: "화 15:00-16:15"
        match = re.match(r'([가-힣]+)\s*(\d{2}:\d{2})-(\d{2}:\d{2})', slot)
        if match:
            day, start_time, end_time = match.groups()
            parsed_times.append({
                "day": day,
                "startTime": start_time,
                "endTime": end_time
            })

    return parsed_times
```

**변환 결과**:

```json
{
  "classTime": [
    {"day": "화", "startTime": "15:00", "endTime": "16:15"},
    {"day": "목", "startTime": "15:00", "endTime": "16:15"}
  ]
}
```

**장점**:
- ✅ DB에 저장하기 쉬움 (별도 테이블 또는 JSON)
- ✅ 요일별/시간대별 검색 용이
- ✅ 시간표 시각화 쉬움

### 3. classroom 파싱

**Raw 데이터**:
```
"화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"
"화 09:00-11:45 (구(한110))"
```

**변환 로직**:
```python
def extract_classroom(timetable: str) -> str:
    """
    첫 번째 강의실 추출
    "화 15:00-16:15 (전211-1)<BR>..." → "전211-1"
    "화 09:00-11:45 (구(한110))" → "구(한110)"  # 괄호 안 괄호 보존!
    """
    match = re.search(r'\(([^)]+)\)', timetable)
    if match:
        return match.group(1).strip()
    return ""
```

**결과**:
- Input: `"화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"`
  - classroom: `"전211-1"`

- Input: `"화 09:00-11:45 (구(한110))"`
  - classroom: `"구(한110)"` ← 괄호 안 괄호 보존!

### 4. departmentCode 및 courseTypeCode 매핑 (코드 기반, DB 정규화!)

**설계 원칙**:
- **이름 대신 코드 사용**: DB 정규화, 중복 제거
- **metadata와 join**: 조회 시 이름 자동 매핑
- **catalog-service 단순화**: 코드 검증만, 이름 변환 불필요

**매핑 로직** (data_parser.py):

```python
# 코드 직접 사용
return {
    "departmentCode": raw_course.get('class_cd', ''),      # FK to metadata.departments
    "courseTypeCode": raw_course.get('field_gb', ''),      # FK to metadata.courseTypes
    # ...
}
```

**예시**:
- Raw: `class_cd = "A10451"`, `field_gb = "04"`
- Transformed: `departmentCode = "A10451"`, `courseTypeCode = "04"`
- 조회 시: metadata와 join하여 이름 표시

**DB 구조**:
```sql
-- courses 테이블
courses (
  department_code VARCHAR FK to metadata.departments(code),
  course_type_code VARCHAR FK to metadata.courseTypes(code)
)

-- 조회 시 join
SELECT c.*, d.name as department_name, ct.name_kr as course_type_name
FROM courses c
LEFT JOIN departments d ON c.department_code = d.code
LEFT JOIN course_types ct ON c.course_type_code = ct.code
```

**장점**:
- ✅ **이름 중복 제거**: "정경대학 국제통상..."을 매번 저장 안 함
- ✅ **정규화**: 학과명 변경 시 metadata만 수정
- ✅ **서비스 단순**: catalog-service는 코드 검증만

---

## catalog-service 구현 (단순 Import만!)

변환은 이미 완료되었으므로, catalog-service는 **단순히 저장만** 합니다.

### Controller

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

        return ResponseEntity.ok(Map.of(
            "imported", courses.size(),
            "message", "Successfully imported courses"
        ));
    }
}
```

### Course Entity

**방법 1: classTime을 JSON으로 저장** (간단)

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

    // JSON으로 저장
    @Column(columnDefinition = "json")
    private String classTime;  // [{"day":"월","startTime":"15:00","endTime":"16:15"}]

    private String classroom;
    private String courseTypeCode;    // FK to CourseType (metadata)
    private String campus;
    private String departmentCode;    // FK to Department (metadata)
    private String notes;

    // getters, setters
}
```

**방법 2: classTime을 별도 테이블로 분리** (정규화, 권장)

```java
@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer openingYear;
    private String semester;
    // ... other fields

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ClassTime> classTimes = new ArrayList<>();
}

@Entity
public class ClassTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_id")
    private Course course;

    private String day;          // "월", "화", "수", "목", "금", "토", "일"
    private String startTime;    // "15:00"
    private String endTime;      // "16:15"

    // getters, setters
}
```

**장점 (방법 2)**:
- ✅ 요일별 검색 쉬움: `WHERE day = '월'`
- ✅ 시간대별 검색 쉬움: `WHERE startTime >= '09:00' AND endTime <= '18:00'`
- ✅ 시간표 충돌 검사 용이

---

## 테스트

### 1. Metadata 크롤링

```bash
python crawl_metadata.py --year 2025 --semester 1
# → output/metadata_2025_1.json
```

### 2. Courses 크롤링 (테스트)

```bash
python run_crawler.py --year 2025 --semester 1 --limit 5
# → output/courses_raw_2025_1.json
```

### 3. 변환 (반복 가능!)

```bash
python transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json
# → output/transformed_2025_1.json

# 결과 확인
cat output/transformed_2025_1.json | head -100

# 만족스럽지 않으면 data_parser.py 수정 후 위 명령 다시 실행!
```

### 4. catalog-service로 업로드

```bash
curl -X POST http://localhost:8080/api/courses/import \
  -H "Content-Type: application/json" \
  -d @output/transformed_2025_1.json
```

### 5. 결과 확인

```bash
curl http://localhost:8080/api/courses?openingYear=2025&semester=1학기
```

---

## 장점 요약

1. **Metadata 분리**: 하드코딩 제거, 동적 매핑
2. **Crawling 1회**: 시간/서버 부담 최소화 (약 4분 → 1회만!)
3. **변환 반복**: 로컬에서 즉시 테스트 (data_parser.py 수정 → 재실행)
4. **서비스 단순**: catalog-service는 변환 로직 없음 (재배포 불필요)
5. **디버깅 용이**: 각 단계 독립적으로 검증
6. **DB 친화적**: classTime을 구조화된 List로 변환
7. **다른 학교 추가 쉬움**: metadata crawler + transformer만 추가

---

## 참고

- Raw 데이터 샘플: `sample_list.txt`
- Metadata 샘플: `sample_data_tiny.txt`
- 필드 매핑 상세: `FIELD_MAPPING.md`
- 크롤러 코드: `crawler/khu_crawler.py`
- 변환 코드: `crawler/data_parser.py`
