# ADR-003: Docker Compose 기반 인프라 운영 전략

**상태**: 수정됨
**작성일**: 2026-02-24
**수정일**: 2026-03-06

## 배경 (Context)

MSA 도입(ADR-002)으로 다수의 서비스를 관리해야 하는 상황에서, 컨테이너 오케스트레이션 도구 선택이 필요함. 본 프로젝트는 학습/포트폴리오 목적과 실용적 운영을 동시에 고려하며, 단일 호스트 환경에서의 운영을 전제로 함.

## 고려한 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 |
|------|------|------|
| **Docker Compose (선택)** | 단순한 설정, 로컬 개발과 동일한 배포 구조, 학습 곡선 낮음 | 단일 호스트 한정, 오토스케일링 불가 |
| Kubernetes (K8s) | 오토스케일링, 롤링 배포, 셀프힐링, 멀티호스트 | 인프라 복잡도 급증, 1인 개발에 과도한 운영 부담 |
| Docker Swarm | Compose와 유사한 문법, 멀티호스트 가능 | 사실상 deprecated, 생태계 축소 |

## 결정 (Decision)

**Docker Compose**를 개발 및 운영 환경의 오케스트레이션 도구로 채택함. Kubernetes 및 Terraform은 도입하지 않음.

### 구성

base + override 패턴을 채택하여 환경별 차이점만 override 파일에 선언한다.

| 용도 | 파일 조합 | 명령어 |
|------|-----------|--------|
| 개발 | `docker-compose.yml` + `docker-compose.override.yml` (자동) | `docker compose up` |
| 통합 테스트 | `docker-compose.yml` + `docker-compose.test.yml` | `docker compose -f docker-compose.yml -f docker-compose.test.yml up` |
| 프로덕션 (계획) | `docker-compose.yml` + `docker-compose.prod.yml` | `docker compose -f docker-compose.yml -f docker-compose.prod.yml up` |

**파일별 역할:**
- `docker-compose.yml`: 모든 환경 공통 서비스 정의. 환경변수는 `${VAR:?error}` 참조만 포함하며, 실제 값은 `.env`에서 주입
- `docker-compose.override.yml`: dev 전용 additions (named volumes, 포트 노출, container_name)
- `docker-compose.test.yml`: test 전용 override (tmpfs)
- `docker-compose.prod.yml`: prod 전용 override (resource limits 등, 미구현)

> 모든 환경변수 값은 프로젝트 루트의 `.env` 파일에서 관리한다. Docker Compose 실행 전 `cp .env.example .env`가 필수 선행 조건이다.

## 근거 (Rationale)

- **K8s 미도입**: 오토스케일링, 롤링 배포, 셀프힐링은 단일 호스트/소규모 트래픽에서 불필요함. K8s 학습 자체는 가치 있으나, 이 프로젝트의 범위(MSA 구조 학습)와 별개의 인프라 운영 영역이며, 도입 시 핵심 비즈니스 로직 개발 시간이 인프라 설정에 소비됨
- **Terraform 미도입**: 클라우드 인프라(VPC, RDS, LB 등)를 코드로 관리하는 도구이나, 단일 호스트 + Docker Compose 환경에서는 관리 대상 인프라가 존재하지 않음
- **Docker Compose 선택**: MSA를 채택한 이상 다수 서비스의 로컬 기동/테스트 환경 구성이 필수이며, Compose가 이 목적에 가장 단순하고 충분한 도구임
- **학습 가치**: 컨테이너 네트워킹, 서비스 디스커버리(Compose DNS), 환경 변수 관리, 볼륨/네트워크 설정 등 컨테이너 기반 운영의 기초를 경험 가능

## 영향 (Consequences)

### 긍정적 영향
- 개발 환경과 배포 환경의 구성이 동일하여 "내 로컬에서는 됐는데" 문제 최소화
- 신규 개발자 온보딩 시 `cp .env.example .env && docker compose up` 두 단계로 전체 환경 구성 가능
- 테스트 환경 격리가 용이 (별도 Compose 파일)

### 부정적 영향 / 트레이드오프
- 멀티호스트 배포 불가 → 트래픽 급증 시 수직 스케일링만 가능
- 프로덕션 수준의 모니터링, 로깅, 헬스체크는 별도 구성 필요
- 오토스케일링, 무중단 배포 등 프로덕션 운영 기법은 학습 범위 밖

## 관련 문서 (References)
- 관련 ADR: [ADR-002 MSA & DDD](./002-msa-ddd-strategy.md)
- 반영된 문서: [deployment.md](../guides/deployment.md)