# UniPlan Course Crawler

대학별 수강신청 시스템에서 강의 정보를 크롤링합니다.

## 구조

```
scripts/crawler/
├── common/                 # 공유 모듈
│   ├── schema.py          # 출력 스키마 (catalog-service DTO와 일치)
│   ├── uploader.py        # catalog-service 업로드
│   └── validator.py       # 데이터 검증
│
├── universities/           # 대학별 크롤러
│   └── khu/               # 경희대학교
│       ├── config.py      # KHU 설정 (URL, 학기 코드 등)
│       ├── crawler.py     # API 크롤러
│       └── parser.py      # 데이터 파싱/변환
│
├── output/                 # 출력 파일 (gitignore)
├── run.py                  # 통합 CLI
└── README.md
```

## 사용법

### 설치

```bash
cd scripts/crawler
uv sync  # 또는 pip install -r requirements.txt
```

### 명령어

```bash
# 1. 메타데이터 크롤링 (대학, 학과, 이수구분 코드)
uv run python run.py metadata -u khu -y 2026 -s 1

# 2. 강의 크롤링 + 변환
uv run python run.py courses -u khu -y 2026 -s 1

# 3. catalog-service로 업로드
uv run python run.py upload -u khu -y 2026 -s 1

# 전체 파이프라인 (1+2+3)
uv run python run.py full -u khu -y 2026 -s 1
```

### 옵션

```bash
# 테스트용: 특정 학과만 크롤링
uv run python run.py courses -u khu -y 2026 -s 1 --limit 5
uv run python run.py courses -u khu -y 2026 -s 1 --departments A10451,A00430

# 커스텀 서버
uv run python run.py upload -u khu -y 2026 -s 1 --host localhost --port 8083
```

## 새 대학 추가

1. `universities/<code>/` 폴더 생성
2. 필수 파일 구현:
   - `config.py` - UNIVERSITY_ID, URL 등
   - `crawler.py` - 데이터 수집 로직
   - `parser.py` - 데이터 변환 (common/schema.py 형식으로)
3. `run.py`의 `get_university_module()` 수정

### 예시: 서울대 추가

```python
# universities/snu/config.py
UNIVERSITY_ID = 2
UNIVERSITY_CODE = "SNU"
BASE_URL = "https://sugang.snu.ac.kr/..."

# universities/snu/crawler.py
class SNUCrawler:
    def fetch_courses(self, year, semester): ...

# universities/snu/parser.py
class SNUParser:
    def parse_courses(self, raw_courses, year, semester): ...
```

## 출력 형식

모든 대학 크롤러는 동일한 출력 형식을 사용합니다 (catalog-service CourseImportRequest DTO):

```json
{
  "universityId": 1,
  "openingYear": 2026,
  "semester": "1",
  "courseCode": "CSE302",
  "section": "01",
  "courseName": "컴퓨터네트워크",
  "professor": "홍길동",
  "credits": 3,
  "classTime": [
    {"day": "월", "startTime": "15:00", "endTime": "16:15"}
  ],
  "classroom": "공A101",
  "courseTypeCode": "04",
  "campus": "서울",
  "departmentCodes": ["A10627"],
  "notes": ""
}
```

## 지원 대학

| 코드 | 대학명 | 상태 |
|------|--------|------|
| khu | 경희대학교 | ✅ |
| snu | 서울대학교 | 🚧 (향후) |
| yonsei | 연세대학교 | 🚧 (향후) |
