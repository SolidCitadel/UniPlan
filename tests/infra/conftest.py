"""
Infra 테스트 공통 픽스처.

Observability 스택 기동 후 실행:
  docker compose -f docker-compose.test.yml --profile observability up -d --build
  cd tests/infra && uv sync && uv run pytest -v

테스트 원칙:
- 환경변수 미설정 시 즉시 Fail (Skip 금지)
- generate_traffic: session-scoped, 전체 infra 테스트에서 1회만 실행
"""
import os
import time

import pytest
import requests


@pytest.fixture(scope="session")
def loki_url() -> str:
    return os.environ["LOKI_URL"].rstrip("/")


@pytest.fixture(scope="session")
def prometheus_url() -> str:
    return os.environ["PROMETHEUS_URL"].rstrip("/")


@pytest.fixture(scope="session")
def tempo_url() -> str:
    return os.environ["TEMPO_URL"].rstrip("/")


@pytest.fixture(scope="session")
def api_base_url() -> str:
    return os.environ["API_BASE_URL"].rstrip("/")


@pytest.fixture(scope="session")
def grafana_url() -> str:
    return os.environ["GRAFANA_URL"].rstrip("/")


@pytest.fixture(scope="session")
def grafana_auth() -> tuple[str, str]:
    return ("admin", os.environ["GRAFANA_ADMIN_PASSWORD"])


def _wait_for_ready(url: str, timeout: int = 60) -> None:
    """서비스가 /ready 엔드포인트에서 200을 반환할 때까지 대기."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            r = requests.get(url, timeout=3)
            if r.status_code == 200:
                return
        except requests.RequestException:
            pass
        time.sleep(2)
    raise RuntimeError(f"{url} did not become ready within {timeout}s")


@pytest.fixture(scope="session", autouse=True)
def generate_traffic(api_base_url: str, loki_url: str, tempo_url: str, prometheus_url: str, grafana_url: str):
    """infra 테스트 전 서비스 준비 확인 + API 트래픽 생성.

    1. Loki / Tempo / Prometheus ready 확인 (각 최대 60초 대기)
    2. API 트래픽 5회 생성
    3. Promtail 수집(5s polling) + Loki/Tempo 인덱싱 대기(20초)

    session-scoped이므로 전체 테스트 세션에서 1회만 실행.
    """
    _wait_for_ready(f"{loki_url}/ready")
    _wait_for_ready(f"{tempo_url}/ready")
    _wait_for_ready(f"{prometheus_url}/-/ready")
    _wait_for_ready(f"{grafana_url}/api/health")

    session = requests.Session()
    for _ in range(5):
        session.get(f"{api_base_url}/api/v1/universities")
    time.sleep(20)
