# ADR-001: Test Strategy (5-Tier Classification)

**Status:** Accepted  
**Date:** 2026-01-18

## Context

기존 테스트 구조에서 다음 문제가 발생:

1. **E2E 테스트에서 엣지 케이스까지 테스트** - 비효율적 (느리고, 실패 원인 파악 어려움)
2. **테스트 분류가 불명확** - "통합 테스트"가 무엇을 의미하는지 혼란
3. **용어 혼용** - E2E, Integration, Component 등의 정의가 팀 내에서 일치하지 않음

## Decision

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
3. **기존 `tests/e2e/` → `tests/integration/`로 이름 변경**: 실제 UI 테스트가 아니므로
4. **Integration 테스트는 Happy Path만**: 엣지 케이스는 Unit/Component에서 검증

## Rationale

### 테스트 피라미드 원칙

```
        ▲
       /E\     E2E (향후)
      /───\
     /Intg\    Integration (적음, 느림)
    /───────\
   /Contract \  Contract (필요 시)
  /───────────\
 /  Component  \  Component (중간)
/───────────────\
│     Unit      │  Unit (많음, 빠름)
└───────────────┘
```

- **빠른 피드백**: Unit/Component가 대부분의 로직 검증
- **명확한 실패 원인**: 각 레벨에서 책임 분리
- **실제 환경 검증**: Integration에서 docker-compose 설정까지 확인

### TestContainers vs H2

| 항목 | H2 | TestContainers MySQL |
|------|----|--------------------|
| 속도 | 빠름 | 느림 (컨테이너 시작) |
| MySQL 호환성 | 부분적 | 완전 |
| JSON 컬럼 | 다름 | 동일 |
| 인덱스 동작 | 다름 | 동일 |

→ **신뢰성을 위해 TestContainers MySQL 사용**

### Integration vs E2E 용어

- **Integration**: 모든 서비스가 통합된 환경에서 API 테스트
- **E2E**: 사용자가 실제로 UI를 통해 조작하는 전체 흐름

현재 `tests/e2e/`는 UI 없이 API만 테스트하므로 **Integration**이 더 적절.

## Consequences

### Positive

- 테스트 책임이 명확해짐
- 빠른 테스트(Unit)에서 대부분의 로직 검증
- 실패 원인 파악이 쉬워짐

### Negative

- 폴더 구조 변경 필요 (`tests/e2e/` → `tests/integration/`)
- 백엔드 테스트 폴더 재구성 필요 (`unit/`, `component/`, `contract/`)
- TestContainers 도입 시 테스트 실행 시간 증가

### Migration Plan

1. **문서 업데이트**: `docs/guides.md`, README, SKILL 파일
2. **폴더 이름 변경**: `tests/e2e/` → `tests/integration/`
3. **백엔드 테스트 재구성**: 점진적으로 `unit/`, `component/` 폴더 구조 적용
4. **TestContainers 도입**: 기존 H2 테스트를 TestContainers로 마이그레이션
