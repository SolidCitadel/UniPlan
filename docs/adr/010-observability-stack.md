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

### 분산 트레이싱 (Phase 3에서 구현 예정)

| 대안 | 장점 | 단점 |
|------|------|------|
| **Grafana Tempo + OTel (예정)** | Grafana 통합, OTel 표준, 벤더 중립 | - |
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
- `docker-compose.observability.yml` 오버레이로 Prometheus + Grafana 선택적 기동
- `docker/prometheus/prometheus.yml`: 4개 서비스 scrape 설정
- `docker/grafana/provisioning/`: Prometheus 데이터소스 자동 등록

**Phase 3: 분산 트레이싱**
- OpenTelemetry SDK (`micrometer-tracing-bridge-otel`) 도입
- Grafana Tempo로 트레이스 수집
- MDC의 `traceId`/`spanId`가 자동으로 로그에 포함 → Loki 로그에서 traceId 클릭 시 Tempo 트레이스 연계

**Phase 4: 로그 집계**
- Grafana Loki + Promtail 도입
- Docker Compose에 서비스로 추가
- 구조화된 JSON 로그를 Loki에 수집, Grafana에서 통합 조회

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
- Docker Compose에 Prometheus, Grafana, Loki, Tempo 추가로 메모리 사용량 증가 (Phase 2~4)
- Phase 1 JSON 로그는 개발 시 로컬에서 가독성이 떨어짐 (jq 등으로 보완 가능)
- OTel 적용 시 Spring Boot 기동 시간 소폭 증가
- **[Phase 1 제약] Gateway(WebFlux) 자체 로그에는 requestId가 MDC로 포함되지 않음**: Gateway는 Reactor 기반이라 스레드 공유 특성상 `MDC.put()`이 정상 동작하지 않음. 헤더 전파(`X-Request-Id`)는 정상 동작하므로 다운스트림 MVC 서비스 로그에는 requestId가 포함됨. Phase 3 OTel Reactor Context 전파 적용 시 해결됨.

## 관련 문서 (References)

- 관련 ADR: [ADR-003: Docker Compose Infrastructure](./003-docker-compose-infra.md)
- 관련 ADR: [ADR-006: Test Strategy](./006-test-strategy.md)
