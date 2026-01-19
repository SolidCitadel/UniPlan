# ADR-001: 5단계 테스트 전략 (Test Strategy)

**상태**: 승인됨  
**작성일**: 2026-01-18

## 배경 (Context)

기존 테스트 구조에서 다음 문제가 발생:

1. **E2E 테스트에서 엣지 케이스까지 테스트** - 비효율적 (느리고, 실패 원인 파악 어려움)
2. **테스트 분류가 불명확** - "통합 테스트"가 무엇을 의미하는지 혼란
3. **용어 혼용** - E2E, Integration, Component 등의 정의가 팀 내에서 일치하지 않음

## 고려한 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 |
|------|------|------|
| E2E 중심 테스트 | 사용자 관점 검증 | 느림, 실패 원인 파악 어려움 |
| Unit 중심 테스트 | 빠름, 명확한 실패 원인 | 통합 문제 발견 어려움 |
| **5단계 분류 (선택)** | 책임 분리, 균형잡힌 커버리지 | 초기 구조화 비용 |

## 결정 (Decision)

5가지 테스트 레벨을 정의하고, 각 레벨의 책임을 명확히 함:

| 유형 | 범위 | DB | 외부 서비스 | 위치 |
|------|------|-----|------------|------|
| **Unit** | 단일 클래스 | Mock | Mock | `unit/` |
| **Component** | 단일 서비스 전체 | TestContainers MySQL | Mock | `component/` |
| **Contract** | 서비스 간 API 계약 | 필요 시 TestContainers | WireMock | `contract/` |
| **Integration** | docker-compose 전체 시스템 | 실제 | 실제 | `tests/integration/` |
| **E2E** | 사용자 여정 (UI 포함) | 실제 | 실제 | (향후 Flutter) |

### 세부 결정사항

1. **Slice Test 미사용**: `@WebMvcTest`, `@DataJpaTest` 등은 Component 테스트와 중복
2. **H2 사용 금지**: MySQL과 동작 차이가 있으므로 TestContainers MySQL 사용
3. **Integration 테스트 범위**:
   - **도메인 테스트**: Happy Path 중심 (엣지 케이스는 Unit/Component에서)
   - **인프라/보안 테스트**: Cross-Cutting Concerns (Gateway 보안, 인증 전파 등)

## 근거 (Rationale)

**테스트 피라미드 원칙**을 따름:
- **빠른 피드백**: Unit/Component가 대부분의 로직 검증
- **명확한 실패 원인**: 각 레벨에서 책임 분리
- **실제 환경 검증**: Integration에서 docker-compose 설정까지 확인

**TestContainers vs H2** 선택 이유:
- H2는 MySQL과 JSON 컬럼, 인덱스 동작이 다름
- 신뢰성을 위해 TestContainers MySQL 사용

## 영향 (Consequences)

### 긍정적 영향
- 테스트 책임이 명확해짐
- 빠른 테스트(Unit)에서 대부분의 로직 검증
- 실패 원인 파악이 쉬워짐

### 부정적 영향 / 트레이드오프
- 백엔드 테스트 폴더 재구성 필요 (`unit/`, `component/`, `contract/`)
- TestContainers 도입 시 테스트 실행 시간 증가

## 관련 문서 (References)
- 반영된 문서: [guides/testing.md](../guides/testing.md)
