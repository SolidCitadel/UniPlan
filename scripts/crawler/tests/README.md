# 크롤러 테스트 파일

## 테스트 파일 목록

### test_quick.py
**목적**: data_js_parser의 기본 동작 테스트
**기능**:
- data_2025.js에서 학과 목록 파싱 테스트
- 2025년 1학기 기준으로 빠른 검증
- 431개 학과가 제대로 파싱되는지 확인

**사용법**:
```bash
python tests/test_quick.py
```

**예상 결과**:
```
Departments found: 431
Sample departments (first 5):
  A00422: 정경대학
  ...
```

---

### test_regex.py
**목적**: data.js 파일의 정규표현식 패턴 디버깅
**기능**:
- data_2025.js 파일 구조 분석
- 여러 정규표현식 패턴 테스트
- nm/cd 필드 순서 확인

**사용법**:
```bash
python tests/test_regex.py
```

**용도**: 정규표현식 패턴 수정 시 디버깅용

---

### test_full_crawler.py
**목적**: 전체 크롤러 워크플로우 단일 학과 테스트
**기능**:
1. 학과 목록 가져오기
2. 첫 번째 학과로 강의 목록 API 호출
3. 강의 데이터 파싱 (KHUDataParser 사용)
4. 최종 JSON 출력

**사용법**:
```bash
python tests/test_full_crawler.py
```

**예상 결과**:
```json
Parsed course:
{
  "openingYear": 2025,
  "semester": "1학기",
  "courseCode": "CSE302",
  ...
}
```

---

### test_multiple_depts.py
**목적**: 여러 학과를 순회하며 강의가 있는 학과 찾기
**기능**:
- 처음 10개 학과를 순차적으로 테스트
- 각 학과의 강의 개수 확인
- 강의가 있는 첫 번째 학과에서 중단

**사용법**:
```bash
python tests/test_multiple_depts.py
```

**용도**:
- 학과별로 강의가 있는지 확인
- API 응답 검증

---

### test_single_dept.py
**목적**: 특정 학과 코드로 직접 테스트
**기능**:
- 하드코딩된 학과 코드로 즉시 테스트
- 빠른 검증용

**사용법**:
```bash
python tests/test_single_dept.py
```

---

## 권장 테스트 순서

1. **test_quick.py** - 학과 목록 파싱 확인
2. **test_multiple_depts.py** - API 호출 및 강의 데이터 확인
3. **test_full_crawler.py** - 전체 파싱 워크플로우 확인

## 주요 크롤러 실행

전체 크롤러 실행 (모든 학과):
```bash
python crawler/khu_crawler.py
```

또는 메인 스크립트에서:
```python
from crawler.khu_crawler import KHUCrawler

crawler = KHUCrawler()
all_courses = crawler.fetch_all_departments(year=2025, semester=1)
crawler.close()
```

## 디버깅

- **test_regex.py**: 정규표현식 패턴이 안 맞을 때
- **test_quick.py**: 학기 코드 매핑 문제 확인
- **test_multiple_depts.py**: 특정 학과에서 API 응답이 이상할 때
