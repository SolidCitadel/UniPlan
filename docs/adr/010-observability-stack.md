# ADR-010: Observability 스택 도입

**상태**: 승인됨
**작성일**: 2026-03-02

## 배경 (Context)

ADR-003에서 "프로덕션 수준의 모니터링, 로깅, 헬스체크는 별도 구성 필요"로 명시하였으나 미구현 상태였다.
현재 Spring Boot Actuator는 api-gateway에만 적용되어 있고, 로그는 구조화되지 않은 텍스트 포맷이며,
서비스 간 요청 흐름을 추적할 수단이 없다.

MSA 환경에서는 단일 요청이 Gateway → Planner → Catalog 등 여러 서비스를 거치므로,
개별 서비스 로그만으로는 장애 원인 파악이 어렵다. 이를 해결하기 위해 Observability 기반을 구축한다.

## 고려한 대안 (Alternatives Considered)

### 로그 집계

| 대안 | 장점 | 단점 |
|------|------|------|
| **Grafana Loki (선택)** | 경량(레이블 기반 인덱싱), Grafana와 통합, 낮은 운영 비용 | ELK 대비 검색 기능 제한적 |
| ELK Stack | 전문 검색 강력, 레퍼런스 풍부 | Elasticsearch가 메모리 집약적(1GB+), 운영 복잡 |
| 파일 로그만 유지 | 추가 인프라 없음 | 여러 서비스 로그 통합 불가 |

### 메트릭

| 대안 | 장점 | 단점 |
|------|------|------|
| **Prometheus + Grafana (선택)** | 업계 표준, Spring Actuator 직접 연동 | - |
| Datadog / New Relic | 풍부한 기능, SaaS | 유료, 벤더 종속 |

### 분산 트레이싱 (완료)

| 대안 | 장점 | 단점 |
|------|------|------|
| **Grafana Tempo + OTel (선택)** | Grafana 통합, OTel 표준, 벤더 중립 | - |
| Zipkin | 단순한 설정, 널리 사용됨 | Grafana와 별도 UI, OTel 표준 아님 |
| Jaeger | 강력한 기능 | Grafana와 별도 UI |

## 결정 (Decision)

**Grafana 통합 스택**을 단계적으로 도입한다. UI를 Grafana 하나로 통합하여 로그, 메트릭, 트레이스를 연계 조회할 수 있도록 한다.

### 4단계 로드맵

**Phase 1 (완료): Observability 기반**
- Spring Boot Actuator 전 서비스 적용 (`/actuator/health`, `/actuator/metrics` 등)
- Structured Logging: `logstash-logback-encoder`로 JSON 포맷 출력, MDC 기반 `requestId` 전파
- Correlation ID: Gateway의 `CorrelationIdFilter`가 `X-Request-Id`를 생성/전파, 각 서비스의 `RequestIdFilter`가 MDC에 설정
- Docker Compose health check: actuator health 엔드포인트 기반으로 개선

**Phase 2 (완료): 메트릭 시각화**
- `micrometer-registry-prometheus` 의존성으로 `/actuator/prometheus` 엔드포인트 노출
- `management.metrics.tags.application`으로 서비스별 레이블 자동 부여
- `docker-compose.yml` / `docker-compose.test.yml`의 `observability` 프로파일로 선택적 기동 (`--profile observability`)
- `docker/prometheus/prometheus.yml`: 4개 서비스 scrape 설정
- `docker/grafana/provisioning/`: Prometheus 데이터소스 자동 등록

**Phase 3 (완료): 분산 트레이싱**
- `micrometer-tracing-bridge-otel` + `opentelemetry-exporter-otlp` 의존성으로 OTel 브릿지 활성화
- `management.tracing.sampling.probability: 1.0` + `management.otlp.tracing.endpoint`로 Tempo 연동
- Grafana Tempo(`grafana/tempo:2.7.2`) 컨테이너: OTLP HTTP(4318) 수신, API(3200) 노출
- `docker/grafana/provisioning/datasources/tempo.yml`: Grafana에 Tempo 데이터소스 자동 등록
- MDC의 `traceId`/`spanId`가 JSON 로그에 자동 포함 (Micrometer Tracing → Reactor Context 전파)
- Phase 1 제약 해소: Gateway WebFlux 로그에 traceId/spanId가 Reactor Context 기반으로 포함됨

**Phase 4 (완료): 로그 집계**
- `grafana/loki:3.3.2` + `grafana/promtail:3.3.2` 도입
- Promtail: Docker 소켓 기반 컨테이너 자동 발견, JSON 파싱 후 `level` 레이블 + `traceId`/`requestId` structured_metadata 추출
- `docker/grafana/provisioning/datasources/loki.yml`: Grafana Loki 데이터소스 자동 등록
- `tempo.yml` 업데이트: `tracesToLogs` 추가로 트레이스 → 로그 연계
- `loki.yml` `derivedFields`: 로그 → 트레이스 연계 (traceId 클릭 → Tempo)
- Phase 1~4 완성으로 메트릭/로그/트레이스 Grafana 통합 완료

### Correlation ID 흐름

```
클라이언트 요청
    → Gateway CorrelationIdFilter: X-Request-Id 생성/전달
        → 각 서비스 RequestIdFilter: MDC에 requestId 설정
            → 로그: {"requestId": "uuid", "message": "..."}
```

Phase 3 OTel 도입 후:
```
클라이언트 요청
    → OTel 자동 계측: traceId, spanId 생성/전달
        → 로그: {"traceId": "...", "spanId": "...", "requestId": "uuid", "message": "..."}
```

## 근거 (Rationale)

- **Grafana 스택**: Prometheus, Loki, Tempo 모두 Grafana 하나에서 조회 가능 → 운영 UI 단일화
- **OTel 표준**: 벤더 중립적 계측 표준. 백엔드(Tempo, Zipkin 등)를 나중에 교체해도 서비스 코드 변경 없음
- **단계적 도입**: 각 Phase를 독립 커밋으로 분리하여 동작 검증 후 다음 단계 진행
- **학습 가치**: Observability는 MSA의 핵심 운영 역량으로, 실무에서 직접 적용 가능한 기술 스택

## 영향 (Consequences)

### 긍정적 영향
- 서비스 간 요청을 requestId로 추적 가능 (Phase 1부터)
- 모든 로그가 구조화(JSON)되어 파싱/집계 용이
- actuator health check로 Docker Compose 서비스 기동 순서 안정화
- Phase 2~4 완성 시: 장애 발생 → 메트릭으로 이상 감지 → Loki 로그 조회 → Tempo 트레이스로 원인 파악 가능

### 부정적 영향 / 트레이드오프
- Docker Compose에 Prometheus, Grafana, Loki, Tempo, Promtail 추가로 메모리 사용량 증가 (Phase 2~4)
- Phase 1 JSON 로그는 개발 시 로컬에서 가독성이 떨어짐 (jq 등으로 보완 가능)
- OTel 적용 시 Spring Boot 기동 시간 소폭 증가
- **[Phase 4 보안] Promtail의 Docker 소켓 마운트**: `docker-compose.yml`과 `docker-compose.test.yml`의 `observability` 프로파일에서 Promtail이 `/var/run/docker.sock:ro`와 `/var/lib/docker/containers:ro`를 마운트한다. 로컬 개발/테스트 전용이며 프로덕션 환경에서는 Sidecar 패턴이나 Loki Docker Driver 등 대안을 검토해야 한다.
- **[Docker Compose 프로파일] Observability는 선택적 기동**: `--profile observability` 플래그로 활성화. 기본 실행(`docker compose up`)에는 포함되지 않아 메모리 사용량을 최소화할 수 있다. `docker-compose.test.yml`도 동일 패턴을 적용하여 Infra 테스트(`tests/infra/`) 실행 시 observability 프로파일 기동이 필요하다.
- **[테스트 격리] docker-compose.test.yml의 Observability tmpfs 스토리지**: 테스트 환경의 Tempo, Loki, Promtail positions, Grafana는 모두 named volume 대신 `type: tmpfs, mode: 0777` 마운트를 사용한다. 컨테이너 재시작 시 데이터가 초기화되어 테스트 실행 간 격리가 보장되며, 이전 실행의 잔류 데이터가 테스트 결과에 영향을 주지 않는다. Named volume은 `docker-compose.override.yml`(dev 전용)에만 선언된다.
- **[Integration 테스트 실행 시 OTel 경고] 정상 현상**: `--profile observability` 없이 Integration 테스트를 실행하면 Tempo 컨테이너 부재로 OTel exporter가 연결 실패 warning을 반복 출력한다. Docker Compose에서 profile 활성화 여부에 따른 env override가 네이티브로 불가능하므로 `TRACING_SAMPLING_PROBABILITY: "1.0"`을 유지한다(0.0으로 되돌리면 Infra 테스트 시 Tempo에 트레이스 전달 불가). OTel exporter는 몇 개 warning 후 exponential backoff로 전환되어 앱 동작에 영향을 주지 않으며, Integration 테스트는 해당 경고와 무관하게 정상 통과한다.
- **[Phase 1 제약 → Phase 3에서 해소] Gateway(WebFlux) 로그 traceId/spanId 포함**: Phase 1에서는 Reactor 스레드 특성으로 MDC.put()이 Gateway 로그에 반영되지 않았으나, Phase 3 OTel Micrometer Tracing 적용으로 Reactor Context 전파가 활성화되어 traceId/spanId가 Gateway 로그에도 포함됨.

## 관련 문서 (References)

- 관련 ADR: [ADR-003: Docker Compose Infrastructure](./003-docker-compose-infra.md)
- 관련 ADR: [ADR-006: Test Strategy](./006-test-strategy.md)
