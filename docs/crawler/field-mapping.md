# 경희대 API 필드 매핑

## 1. 학과 목록 API (data_YYYY.js)

### 실제 구조 (학기별 변수)
```javascript
// data_2025.js 파일에 모든 학기 포함
var major_202510 = {  // 2025년 1학기
    "rows": [
        {
            "id": 1,
            "cd": "A10627",           // 학과 코드
            "nm": "컴퓨터공학과",      // 학과명
            "enm": "Computer Science",
            "dh": "A10627",           // 상위 코드
            "gb": "H"                 // 구분
        },
        ...
    ]
}

var major_202520 = { ... }  // 2025년 2학기
var major_202515 = { ... }  // 2025년 여름학기
var major_202525 = { ... }  // 2025년 겨울학기
```

### 학기 코드 형식
- `YYYYMM` 형식
- `202510`: 2025년 1학기 (10 → 정규학기 1학기)
- `202520`: 2025년 2학기 (20 → 정규학기 2학기)
- `202515`: 2025년 여름학기 (15)
- `202525`: 2025년 겨울학기 (25)

### 사용 필드
- `cd`: 학과 코드 → API 요청의 `p_major` 파라미터로 사용
- `nm`: 학과명 → 로그 출력용

**중요**: 학기마다 개설되는 학과가 다를 수 있으므로, 크롤링할 학기에 맞는 변수를 파싱해야 함!

## 2. 강의 목록 API 응답

### 실제 응답 구조
```json
{
    "rows": [
        {
            "subjt_cd": "CSE302",                                      // 과목 코드
            "subjt_name": "컴퓨터네트워크",                             // 과목명
            "teach_na": "이성원",                                       // 교수명
            "unit_num": "  3.0",                                       // 학점 (문자열)
            "timetable": "월 15:00-16:15 (B01)<BR>수 15:00-16:15 (B01)", // 강의시간+강의실
            "campus_nm": "국제",                                        // 캠퍼스
            "lect_grade": 3,                                           // 대상학년 (int)
            "field_gb": "04",                                          // 이수구분 코드
            "class_cd": "A10627",                                      // 학과 코드
            "bigo": " ",                                               // 비고
            "lecture_cd": "CSE30202",                                  // 강좌 코드
            "lecture_cd_disp": "CSE302-02",                           // 표시용 강좌 코드
            "all_apply": 58,                                           // 신청 인원
            "remain": 2,                                               // 잔여 인원
            "comm_limit": 60,                                          // 정원
            "eng_yn_nm": ""                                            // 영어 강의 여부
        }
    ]
}
```

## 3. catalog-service 형식으로 변환

### 필드 매핑

| catalog-service | 경희대 API | 변환 로직 |
|-----------------|-----------|-----------|
| `openingYear` | (파라미터) | 년도 입력값 사용 |
| `semester` | (파라미터) | 학기 코드 → "1학기", "2학기" 변환 |
| `targetGrade` | `lect_grade` | int → string 변환 |
| `courseCode` | `subjt_cd` | 그대로 사용 |
| `courseName` | `subjt_name` | 그대로 사용 |
| `professor` | `teach_na` | 그대로 사용 |
| `credits` | `unit_num` | "  3.0" → 3 (int) 변환 |
| `classTime` | `timetable` | HTML 제거, 강의실 제거 |
| `classroom` | `timetable` | 괄호 안 강의실만 추출 |
| `courseType` | `field_gb` | 코드 → 이수구분명 변환 |
| `campus` | `campus_nm` | 그대로 사용 |
| `college` | - | 빈 문자열 (API 응답 없음) |
| `department` | - | 빈 문자열 (API 응답 없음) |
| `notes` | `bigo` | trim 후 사용 |

## 4. 이수구분 코드 매핑 (gradIsuCd_2025)

| field_gb | 의미 (nmk) |
|----------|-----------|
| "00" | 구분없음 |
| "04" | 전공필수 |
| "05" | 전공선택 |
| "06" | 교직 |
| "08" | 일반선택 |
| "10" | 공통과목 |
| "11" | 전공기초 |
| "12" | 전공공통 |
| "13" | 공통필수 |
| "20" | 교직전선 |
| "41" | 선수과목 |
| "43" | 논문지도과목 |
| "44" | 종합시험 |
| "61" | 외국어대체 |
| "66" | 논문대체 |
| "95" | 과정구분없음 |

## 5. 학기 코드 매핑

**⚠️ 중요: API 파라미터(p_term)와 data.js 변수명의 코드가 서로 반대입니다!**

### 매핑 테이블
| semester (입력) | p_term (API) | data.js 변수명 | 변수명 끝자리 | semester (출력) |
|----------------|--------------|---------------|--------------|----------------|
| 1 | "20" | major_202510 | "10" | "1학기" |
| 2 | "10" | major_202520 | "20" | "2학기" |
| - | "15" | major_202515 | "15" | "여름학기" |
| - | "25" | major_202525 | "25" | "겨울학기" |

**주의사항**:
- **API 요청 (p_term)**: 1학기="20", 2학기="10"
- **data.js 변수명 끝자리**: 1학기="10", 2학기="20"
- 이 둘은 **정반대**이므로 혼동하지 말 것!
- data.js의 변수명은 `major_YYYYMM` 형식 (예: `major_202510`)

## 6. 강의시간 파싱 예시

### 입력 (timetable)
```
"화 15:00-16:15 (전211-1)<BR>목 15:00-16:15 (전211-1)"
```

### 출력
- **classTime**: `"화15:00-16:15,목15:00-16:15"`
- **classroom**: `"전211-1"`

### 변환 로직
1. `<BR>` → `,`
2. 괄호 안 강의실 제거 (classTime)
3. 공백 제거
4. 첫 번째 괄호 내용 추출 (classroom)

## 7. 최종 변환 결과 예시

### 입력 (API 응답)
```json
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
```

### 출력 (catalog-service 형식)
```json
{
    "openingYear": 2025,
    "semester": "1학기",
    "targetGrade": "3",
    "courseCode": "CSE302",
    "courseName": "컴퓨터네트워크",
    "professor": "이성원",
    "credits": 3,
    "classTime": "월15:00-16:15,수15:00-16:15",
    "classroom": "B01",
    "courseType": "전공필수",
    "campus": "국제",
    "college": "",
    "department": "",
    "notes": ""
}
```

## 8. 테스트 방법

```bash
# 파서 단독 테스트
python crawler/data_parser.py

# 전체 크롤러 테스트
python crawler/khu_crawler.py

# 특정 학과 테스트
python test_single_dept.py
```
