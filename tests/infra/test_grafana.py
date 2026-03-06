"""
Grafana 프로비저닝 인프라 테스트.

검증 계층:
  Level 1 - 서비스 헬스: /api/health
  Level 2 - 데이터소스 프로비저닝: 3개 데이터소스 모두 존재 및 올바른 URL 설정
  Level 3 - 크로스 데이터소스 UID 일관성: Tempo tracesToLogs/tracesToMetrics 참조 검증

실행:
  docker compose -f docker-compose.yml -f docker-compose.test.yml --profile observability up -d --build
  cd tests/infra && uv run pytest test_grafana.py -v
"""
import requests


EXPECTED_DATASOURCE_UIDS = {"loki", "tempo", "prometheus"}


class TestGrafana:
    """Grafana 프로비저닝 인프라 테스트"""

    # ──────────────────────────────────────────────────────────────────────────
    # Level 1: 서비스 헬스
    # ──────────────────────────────────────────────────────────────────────────

    def test_grafana_health(self, grafana_url: str, grafana_auth: tuple[str, str]):
        """Grafana가 정상 기동됐는지 검증 (/api/health)."""
        response = requests.get(f"{grafana_url}/api/health", auth=grafana_auth, timeout=10)

        assert response.status_code == 200, \
            f"Grafana /api/health should return 200 (Got {response.status_code})"

        data = response.json()
        assert data.get("database") == "ok", \
            f"Grafana database should be 'ok', got: {data.get('database')}"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 2: 데이터소스 프로비저닝
    # ──────────────────────────────────────────────────────────────────────────

    def test_grafana_all_datasources_provisioned(self, grafana_url: str, grafana_auth: tuple[str, str]):
        """3개 데이터소스(Loki, Tempo, Prometheus)가 모두 프로비저닝됐는지 검증."""
        response = requests.get(f"{grafana_url}/api/datasources", auth=grafana_auth, timeout=10)

        assert response.status_code == 200, \
            f"Grafana /api/datasources should return 200 (Got {response.status_code})"

        datasources = response.json()
        provisioned_uids = {ds["uid"] for ds in datasources}
        missing = EXPECTED_DATASOURCE_UIDS - provisioned_uids
        assert not missing, \
            f"다음 데이터소스가 Grafana에 프로비저닝되지 않았습니다: {missing}. " \
            f"실제 프로비저닝된 UIDs: {provisioned_uids}"

    def test_grafana_datasource_urls_correct(self, grafana_url: str, grafana_auth: tuple[str, str]):
        """각 데이터소스가 올바른 내부 서비스 URL을 가리키는지 검증."""
        expected_urls = {
            "loki": "http://loki:3100",
            "prometheus": "http://prometheus:9090",
            "tempo": "http://tempo:3200",
        }

        response = requests.get(f"{grafana_url}/api/datasources", auth=grafana_auth, timeout=10)
        assert response.status_code == 200

        datasources = {ds["uid"]: ds for ds in response.json()}
        for uid, expected_url in expected_urls.items():
            assert uid in datasources, f"Datasource '{uid}' not found"
            actual_url = datasources[uid].get("url", "")
            assert actual_url == expected_url, \
                f"Datasource '{uid}' URL mismatch: expected '{expected_url}', got '{actual_url}'"

    # ──────────────────────────────────────────────────────────────────────────
    # Level 3: 크로스 데이터소스 UID 일관성
    # ──────────────────────────────────────────────────────────────────────────

    def test_grafana_tempo_traces_to_logs_uid_matches_loki(self, grafana_url: str, grafana_auth: tuple[str, str]):
        """Tempo의 tracesToLogs.datasourceUid가 실제 Loki 데이터소스 UID와 일치하는지 검증.

        tempo.yml의 tracesToLogs.datasourceUid: loki 설정이
        Grafana에 실제 프로비저닝된 Loki 데이터소스 uid와 일치해야
        Tempo → Loki 로그 연계가 정상 동작함.
        """
        response = requests.get(f"{grafana_url}/api/datasources", auth=grafana_auth, timeout=10)
        assert response.status_code == 200

        datasources = {ds["uid"]: ds for ds in response.json()}

        assert "tempo" in datasources, "Tempo datasource not provisioned"
        assert "loki" in datasources, "Loki datasource not provisioned"

        tempo_ds = datasources["tempo"]
        traces_to_logs_uid = (
            tempo_ds.get("jsonData", {})
            .get("tracesToLogs", {})
            .get("datasourceUid")
        )
        loki_uid = datasources["loki"]["uid"]

        assert traces_to_logs_uid == loki_uid, \
            f"Tempo tracesToLogs.datasourceUid='{traces_to_logs_uid}'이 " \
            f"실제 Loki UID='{loki_uid}'와 일치하지 않습니다. " \
            f"Tempo→Loki 로그 연계가 Grafana에서 동작하지 않을 수 있습니다."

    def test_grafana_tempo_traces_to_metrics_uid_matches_prometheus(self, grafana_url: str, grafana_auth: tuple[str, str]):
        """Tempo의 tracesToMetrics.datasourceUid가 실제 Prometheus 데이터소스 UID와 일치하는지 검증.

        tempo.yml의 tracesToMetrics.datasourceUid: prometheus 설정이
        Grafana에 실제 프로비저닝된 Prometheus 데이터소스 uid와 일치해야
        Tempo → Prometheus 메트릭 연계가 정상 동작함.
        """
        response = requests.get(f"{grafana_url}/api/datasources", auth=grafana_auth, timeout=10)
        assert response.status_code == 200

        datasources = {ds["uid"]: ds for ds in response.json()}

        assert "tempo" in datasources, "Tempo datasource not provisioned"
        assert "prometheus" in datasources, "Prometheus datasource not provisioned"

        tempo_ds = datasources["tempo"]
        traces_to_metrics_uid = (
            tempo_ds.get("jsonData", {})
            .get("tracesToMetrics", {})
            .get("datasourceUid")
        )
        prometheus_uid = datasources["prometheus"]["uid"]

        assert traces_to_metrics_uid == prometheus_uid, \
            f"Tempo tracesToMetrics.datasourceUid='{traces_to_metrics_uid}'이 " \
            f"실제 Prometheus UID='{prometheus_uid}'와 일치하지 않습니다. " \
            f"Tempo→Prometheus 메트릭 연계가 Grafana에서 동작하지 않을 수 있습니다."
