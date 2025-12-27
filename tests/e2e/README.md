# UniPlan E2E Tests

pytest 기반의 E2E 테스트입니다.

## 설치 (uv 사용)

```bash
cd tests/e2e

# uv 설치 (없는 경우)
curl -LsSf https://astral.sh/uv/install.sh | sh  # macOS/Linux
# Windows: powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# 의존성 설치
uv sync
```

## 실행

```bash
# 전체 테스트
uv run pytest

# 상세 출력
uv run pytest -v

# 특정 도메인
uv run pytest test_auth.py
uv run pytest test_timetable.py

# 병렬 실행 (dev 의존성 필요)
uv sync --group dev
uv run pytest -n auto

# HTML 리포트
uv run pytest --html=report.html
```

## 환경 변수

`.env` 파일 또는 환경 변수:

```bash
API_BASE_URL=http://localhost:8080
```

## 테스트 구조

도메인별로 파일을 분리하고, 각 파일에 Happy Path와 Edge Cases를 포함합니다.

```
tests/e2e/
├── conftest.py           # pytest fixtures
├── test_auth.py          # 인증 (회원가입, 로그인)
├── test_courses.py       # 강의 검색
├── test_wishlist.py      # 위시리스트
├── test_timetable.py     # 시간표
├── test_scenario.py      # 시나리오 트리
└── test_registration.py  # 수강신청
```

## 도메인별 테스트

| 파일 | Happy Path | Edge Cases |
|------|------------|------------|
| `test_auth.py` | 회원가입/로그인 | 중복이메일, 잘못된 비밀번호, 토큰 없음 |
| `test_courses.py` | 목록/검색 | 빈 결과, 특수문자, 페이지네이션 |
| `test_wishlist.py` | 추가/삭제/우선순위 | 중복 과목, 존재하지 않는 과목 |
| `test_timetable.py` | 생성/과목추가/대안 | 필수 필드 누락, 제외 과목 재추가 |
| `test_scenario.py` | 생성/네비게이션 | 존재하지 않는 시간표/시나리오 |
| `test_registration.py` | 시작/기록/완료 | 완료된 수강신청 재완료 |

## 테스트 레벨 (참고)

```
단위 테스트     → app/backend/**/test/  (개별 로직)
통합 테스트     → app/backend/**/test/  (단일 서비스)
E2E 테스트      → tests/e2e/            (전체 시스템)
```
