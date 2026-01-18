# UniPlan Integration Tests

pytest 기반의 **통합 테스트**입니다.  
전체 시스템(docker-compose 환경)에서 서비스 간 통신과 주요 사용자 시나리오를 검증합니다.

## 테스트 레벨

| 유형 | 위치 | 설명 |
|------|------|------|
| Unit | `app/backend/**/unit/` | 단일 클래스, 모든 Mock |
| Component | `app/backend/**/component/` | 단일 서비스, TestContainers MySQL |
| Contract | `app/backend/**/contract/` | 서비스 간 API 계약 |
| **Integration** | `tests/integration/` | **전체 시스템 (여기)** |
| E2E | (향후) | 사용자 여정 + UI |

## 설치 (uv 사용)

```bash
cd tests/integration

# uv 설치 (없는 경우)
curl -LsSf https://astral.sh/uv/install.sh | sh  # macOS/Linux
# Windows: powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# 의존성 설치
uv sync
```

## 실행

```bash
# docker-compose 환경 시작
docker compose -f docker-compose.test.yml up -d --build
sleep 30

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

# 종료
docker compose -f docker-compose.test.yml down
```

## 환경 변수

`.env` 파일 또는 환경 변수:

```bash
API_BASE_URL=http://localhost:8080
```

## 테스트 구조

도메인별로 파일을 분리하고, 테스트 범위를 구분합니다:

- **도메인 테스트**: Happy Path 중심
- **인프라/보안 테스트 (`infra/`)**: Cross-Cutting Concerns (Gateway 보안, 인증 전파 등)

> **Note:** 엣지 케이스와 비즈니스 로직은 Unit/Component Test에서 검증합니다.

```
tests/integration/
├── conftest.py              # pytest fixtures
├── test_auth.py             # 인증 (회원가입, 로그인)
├── test_courses.py          # 강의 검색
├── test_wishlist.py         # 위시리스트
├── test_timetable.py        # 시간표
├── test_scenario.py         # 시나리오 트리
├── test_university.py       # 대학 정보
├── test_registration.py     # 수강신청
└── infra/                   # 인프라/보안 테스트
    └── test_gateway_security.py  # Gateway 보안
```

## 도메인별 테스트

| 파일 | Happy Path |
|------|------------|
| `test_auth.py` | 회원가입, 로그인 |
| `test_courses.py` | 목록, 검색 |
| `test_wishlist.py` | 추가, 삭제, 우선순위 |
| `test_timetable.py` | 생성, 과목추가, 대안 |
| `test_scenario.py` | 생성, 네비게이션 |
| `test_registration.py` | 시작, 기록, 완료 |
