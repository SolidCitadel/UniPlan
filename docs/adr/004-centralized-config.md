# ADR-004: 중앙집중식 설정 관리 (Centralized Configuration)

**상태**: 승인됨  
**작성일**: 2026-01-20

## 배경 (Context)

MSA 환경에서 각 서비스(user-service, catalog-service, planner-service, api-gateway)마다 환경별 설정 파일(`application-dev.yml`, `application-prod.yml` 등)을 두면:

1. **설정 분산**: 환경이 바뀔 때 4개 서비스 × N개 환경 = 4N개 파일 수정 필요
2. **불일치 위험**: 서비스 간 설정(JWT 시크릿, DB 연결정보 등)이 달라질 수 있음
3. **시크릿 관리 어려움**: 각 서비스에 시크릿이 흩어져 있으면 관리 포인트 증가

## 고려한 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 |
|------|------|------|
| Spring Profile 분리 (dev/prod) | Spring 표준 | 서비스 수 × 환경 수만큼 파일 관리 |
| Spring Cloud Config | 중앙 관리, 동적 갱신 | 추가 인프라 필요 |
| **Docker Compose 환경변수 (선택)** | 단순함, 단일 변경점 | Docker 의존, 로컬 실행 시 별도 설정 필요 |

## 결정 (Decision)

**Spring 내부에서는 프로파일 분리를 하지 않고(local 제외), Docker Compose에서 중앙집중적으로 환경변수를 관리한다.**

### 설정 구조

| 파일 | 용도 |
|------|------|
| `application.yml` | 플레이스홀더만 포함 (`${DB_URL}`, `${JWT_SECRET}` 등) |
| `application-local.yml` | 로컬 개별 실행용 (`bootRun`, IDE) |
| `docker-compose.yml` | 개발 환경 - 환경변수 주입 |
| `docker-compose.test.yml` | 테스트 환경 |
| `docker-compose.prod.yml` | 운영 환경 - `.env`에서 시크릿 로드 |

### 환경변수 주입 흐름

```
docker-compose.*.yml (environment 섹션)
    ↓
application.yml (플레이스홀더 ${VAR})
    ↓
Spring Boot 실행
```

## 근거 (Rationale)

- **12-Factor App 원칙**: 설정을 코드와 분리하고 환경변수로 주입
- **단일 변경점**: 환경이 바뀌면 해당 docker-compose 파일 하나만 수정
- **Spring Cloud Config 없이 충분**: 현재 규모에서 추가 인프라 불필요

## 영향 (Consequences)

### 긍정적 영향
- 환경별 설정 파일 관리 부담 감소
- 서비스 간 설정 불일치 방지
- 시크릿이 `.env` 파일에만 존재하여 git에서 제외 가능

### 부정적 영향 / 트레이드오프
- Docker 없이 개별 서비스 실행 시 `application-local.yml` 필요
- IDE에서 실행할 때 `-Dspring.profiles.active=local` 필요

## 관련 문서 (References)
- 반영된 문서: [architecture.md](../architecture.md#설정-아키텍처-configuration-architecture)
- 외부 참고: [12-Factor App: Config](https://12factor.net/config)
