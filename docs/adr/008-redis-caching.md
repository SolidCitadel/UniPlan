# ADR-008: Redis 캐싱 도입

**상태**: 승인됨
**작성일**: 2026-02-24

## 배경 (Context)

Planner Service가 시간표/시나리오/위시리스트 조회 시 매번 Catalog Service에 HTTP 요청을 보내 과목 정보를 가져옴. 과목 데이터는 학기 중 거의 불변인데도 캐싱이 전혀 없어 불필요한 네트워크 호출이 반복됨.

## 고려한 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 |
|------|------|------|
| Spring `@Cacheable` (로컬 메모리) | 설정 간단, 외부 의존성 없음 | 인스턴스 간 캐시 공유 불가, 메모리 압박 |
| **Redis** | 인스턴스 간 공유, TTL 관리, redis-cli 디버깅 | 외부 인프라 추가 필요 |
| Caffeine (로컬 캐시) | 빠른 조회 속도, 설정 간단 | 인스턴스 간 공유 불가 |

## 결정 (Decision)

Redis를 CatalogClient 파사드 내부에서 사용하여 과목 데이터(`CourseFullResponse`)를 캐싱한다.

- **캐시 키**: `course:{courseId}` — 개별 과목 단위
- **TTL**: 1시간 (학기 중 불변이나 관리자 수정 가능성 고려)
- **직렬화**: Jackson JSON (`GenericJackson2JsonRedisSerializer`)
- **장애 대응**: Redis 장애 시 try-catch로 Feign 직접 호출 폴백
- **배치 처리**: 개별 키로 캐시 확인 후 미스만 Feign batch 호출

## 근거 (Rationale)

- 향후 인스턴스 스케일아웃 시 캐시 일관성 보장 (로컬 캐시 대비)
- redis-cli로 캐시 상태를 직접 확인할 수 있어 디버깅 용이
- Docker Compose 인프라에 Redis 추가로 인프라 운영 학습 경험 확장
- 서비스 레이어 변경 없이 CatalogClient 파사드 내부에서만 캐싱 처리

## 영향 (Consequences)

### 긍정적 영향
- Catalog Service 부하 감소 (반복 조회 제거)
- Planner Service 응답 속도 향상
- 서비스 레이어 코드 변경 불필요 (파사드 패턴의 장점)

### 부정적 영향 / 트레이드오프
- Docker Compose에 Redis 컨테이너 추가 (인프라 복잡도 미세 증가)
- 과목 데이터 갱신 시 최대 1시간 지연 가능 (TTL 기반)
- Redis 장애 시 성능 저하 (폴백으로 직접 호출하므로 기능은 정상)

## 관련 문서 (References)
- 관련 ADR: [ADR-003](./003-docker-compose-infra.md) (Docker Compose 인프라)
- 반영된 문서: [architecture.md](../architecture.md#redis-캐싱)
