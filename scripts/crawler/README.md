# UniPlan Course Crawler

대학별 수강신청 시스템에서 강의 정보를 크롤링합니다.

## 워크플로우

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  metadata   │ → │   courses   │ → │  transform  │ → │   upload    │
│  (크롤링)   │    │  (크롤링)   │    │   (변환)    │    │  (업로드)   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
       ↓                  ↓                  ↓
  metadata.json    courses_raw.json   transformed.json
```

> 💡 `courses`는 네트워크 비용이 높아 **한 번만** 실행하고, `transform`은 로직 수정 후 **여러 번** 재실행 가능!

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
│       ├── README.md      # KHU 전용 문서 (필드 명세 등)
│       ├── config.py      # 설정 (URL, 학기 코드 등)
│       ├── crawler.py     # API 크롤러
│       └── parser.py      # 데이터 파싱/변환
│
├── tests/                  # 유닛 테스트
│   └── test_khu_parser.py # KHU 파서 테스트
│
├── output/                 # 출력 파일 (gitignore)
├── run.py                  # 통합 CLI
└── README.md
```

## 사용법

### 설치

```bash
cd scripts/crawler
uv sync
```

### 명령어

```bash
# 1. 메타데이터 크롤링 (대학, 학과, 이수구분 코드)
uv run python run.py metadata -u khu -y 2026 -s 1

# 2. 강의 크롤링 (raw 데이터 저장)
uv run python run.py courses -u khu -y 2026 -s 1

# 3. 변환 (raw → catalog-service 형식)
uv run python run.py transform -u khu -y 2026 -s 1

# 4. catalog-service로 업로드
uv run python run.py upload -u khu -y 2026 -s 1

# 전체 파이프라인 (1+2+3+4)
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

## 출력 파일

| 파일 | 설명 | 생성 커맨드 |
|------|------|-------------|
| `metadata_*.json` | 대학/학과/이수구분 코드 | `metadata` |
| `courses_raw_*.json` | 크롤링한 원본 강의 데이터 | `courses` |
| `transformed_*.json` | catalog-service 형식 강의 데이터 | `transform` |

## 새 대학 추가

1. `universities/<code>/` 폴더 생성
2. 필수 파일 구현:
   - `config.py` - UNIVERSITY_ID, URL 등
   - `crawler.py` - 데이터 수집 로직
   - `parser.py` - 데이터 변환
   - `README.md` - 대학별 필드 명세
3. `run.py`의 `get_university_module()` 수정

## 지원 대학

| 코드 | 대학명 | 상태 |
|------|--------|------|
| khu | 경희대학교 | ✅ |

## 테스트

```bash
# 테스트 실행
uv run pytest tests/ -v

# 특정 테스트만 실행
uv run pytest tests/test_khu_parser.py -v
```

새 대학 추가 시 `tests/test_<code>_parser.py` 테스트도 추가해야 합니다.
