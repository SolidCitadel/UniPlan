# ADR-005: 중앙집중식 설정 관리 (Centralized Configuration)

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
| `docker-compose.yml` | 모든 환경 공통 — `${VAR:?error}` 참조만 포함 |
| `docker-compose.override.yml` | dev 전용 인프라 additions (container_name, ports, volumes) |
| `docker-compose.test.yml` | test 전용 인프라 override (tmpfs, ports) |
| `docker-compose.prod.yml` | prod 전용 인프라 override (resource limits 등, 미구현) |
| `.env` | **환경변수 값의 유일한 출처** — git 제외, `.env.example`로부터 복사 |

### 환경변수 주입 흐름

```
.env (모든 환경변수 값)
    ↓ Docker Compose 자동 로드
docker-compose.yml (${VAR:?error} 치환)
    ↓
application.yml (플레이스홀더 ${VAR})
    ↓
Spring Boot 실행
```

### Docker Compose 자격증명 전략

`docker-compose.yml` base 파일은 값을 갖지 않고 `${VAR:?error}` 참조만 선언한다. 값은 전부 `.env` 파일에서 관리한다.

- **시크릿** (DB 패스워드, JWT_SECRET 등): `.env`에서만 관리, compose 파일에 하드코딩 금지
- **인프라 상수** (Docker 내부 서비스 URL, 포트): compose 파일에 직접 정의 (환경 무관 고정값)
- **override 파일** (override.yml, test.yml, prod.yml): 인프라 구조 차이만 정의, 환경변수 값 없음

온보딩: `cp .env.example .env` 후 `docker compose up` 실행.
CI (GitHub Actions): `cp .env.example .env` 스텝으로 더미 값 주입. 실제 시크릿이 필요한 경우 GitHub Secrets에서 `echo "VAR=${{ secrets.VAR }}" >> .env` 패턴으로 덮어쓴다.

## 근거 (Rationale)

- **12-Factor App 원칙**: 설정을 코드와 분리하고 환경변수로 주입
- **단일 변경점**: 환경이 바뀌면 `.env` 파일 하나만 수정 (compose 파일 수정 불필요)
- **AWS Secrets Manager 호환**: 프로덕션에서 시크릿 매니저가 env var를 주입하는 방식과 동일한 인터페이스
- **Fail Fast**: `${VAR:?error}` 구문으로 변수 누락 시 컨테이너 시작 전 즉시 실패
- **Spring Cloud Config 없이 충분**: 현재 규모에서 추가 인프라 불필요

## 영향 (Consequences)

### 긍정적 영향
- 환경별 설정 파일 관리 부담 감소
- 서비스 간 설정 불일치 방지
- 모든 환경변수 값이 `.env` 파일 하나에 집중되어 파악이 쉬움
- compose 파일을 건드리지 않고 `.env`만 교체하면 환경 전환 가능
- 시크릿이 `.env` 파일에만 존재하여 git에서 제외 가능

### 부정적 영향 / 트레이드오프
- Docker 없이 개별 서비스 실행 시 `application-local.yml` 필요
- IDE에서 실행할 때 `-Dspring.profiles.active=local` 필요
- `profiles: [observability]` 서비스의 `${VAR:?error}`도 Compose 파싱 시점에 평가됨 → `--profile observability` 없이 실행해도 `GRAFANA_ADMIN_PASSWORD`가 `.env`에 없으면 실패. `.env.example`에 해당 값이 포함되어 있어 온보딩 절차(`cp .env.example .env`)를 따르면 문제없음
- dev/test가 동일한 `.env`의 `JWT_SECRET`을 공유 — 개발 중 dev, 검증 시 test로 전환하는 구조이므로 동시에 실행할 이유가 없어 실질적 보안 위험 없음 (의도적 설계)

## 환경변수 기본값 원칙

12-Factor App Config 원칙에 따라 **환경변수는 기본값을 두지 않는다.**

| 위치 | 규칙 |
|------|------|
| `application.yml` (비로컬) | `${VAR}` — 기본값 없음. 누락 시 Spring 기동 실패 |
| `application-local.yml` (로컬 전용) | 값을 직접 하드코딩. `${VAR:default}` 플레이스홀더 사용 금지 |
| 프론트엔드 / 테스트 코드 | 기본값 없음. 미설정 시 명확한 에러 메시지와 함께 즉시 실패 |

**이유**: 기본값이 있으면 환경변수가 누락되어도 앱이 "일단 동작"하는 상태가 되어, 예상하지 못한 환경에서 디버깅하기 어려운 버그가 발생한다.

신규 기여자 온보딩 시 `.env.example` 복사가 필수 절차임을 각 디렉터리의 README 또는 이 원칙으로 명시한다.

## 관련 문서 (References)
- 관련 ADR: [ADR-003 Docker Compose 인프라](./003-docker-compose-infra.md)
- 반영된 문서: [architecture.md](../architecture.md#설정-아키텍처-configuration-architecture)
- 외부 참고: [12-Factor App: Config](https://12factor.net/config)
