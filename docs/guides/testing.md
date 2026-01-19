# Testing Guide

UniPlan의 5단계 테스트 전략 및 작성 가이드입니다. 상세한 배경은 [ADR-001](../adr/001-test-strategy.md)을 참고하세요.

## Test Levels

| 유형 | 범위 | DB | 외부 서비스 | 위치 |
|------|------|-----|------------|------|
| **Unit** | 단일 클래스 | Mock | Mock | `unit/` |
| **Component** | 단일 서비스 | TestContainers | Mock | `component/` |
| **Contract** | API 계약 | - | WireMock | `contract/` |
| **Integration** | 전체 시스템 | 실제 (Docker) | 실제 | `tests/integration/` |
| **E2E** | 사용자 여정 | 실제 | 실제 | (Future) |

---

## 1. Backend Testing rules

### Unit Test
- **목적**: 비즈니스 로직의 상세 검증, 엣지 케이스 확인
- **도구**: JUnit 5, Mockito
- **규칙**: DB나 Spring Context를 띄우지 마세요. (`@SpringBootTest` 금지)

### Component Test
- **목적**: Spring Context, DB 연동, API 응답 규격 검증
- **도구**: `@SpringBootTest`, `TestContainers` (MySQL)
- **규칙**:
  - H2 Database 사용 금지 (MySQL과의 호환성 문제)
  - `DockerRequiredExtension`을 사용하여 Docker 미실행 시 Fail-fast

### Contract Test
- **목적**: 마이크로서비스 간(Feign) 통신 규격 검증
- **도구**: Spring Cloud Contract 또는 WireMock

---

## 2. Integration Testing

Python(`pytest`)을 사용하여 실제 실행 중인 컨테이너 환경을 블랙박스 테스트합니다.

### 실행 방법
```bash
# 1. 테스트 환경 구동 (tmpfs DB 사용으로 빠름)
docker compose -f docker-compose.test.yml up -d --build
sleep 30

# 2. 테스트 실행
cd tests/integration
uv sync
uv run pytest -v

# 3. 정리
docker compose -f docker-compose.test.yml down
```

### 작성 가이드 (Best Practices)

1.  **Skip 금지**: 데이터가 없다고 테스트를 스킵하지 마세요. Fixture를 사용해 데이터를 생성하세요.
2.  **엄격한 검증**:
    - Status Code: `200` vs `201` 구분
    - 응답 본문: 필수 필드 누락 여부 전수 검사
3.  **에러 응답 검증**: 실패 케이스(4xx)에서도 에러 메시지 포맷이 올바른지 확인하세요.

---

## 3. Frontend Testing

- **Lint**: `npm run lint` (ESLint)
- **Build**: `npm run build` (타입 체크 포함)
- **Note**: 프론트엔드 로직 검증은 주로 Integration Test의 시나리오를 통해 간접 검증하거나, 복잡한 유틸리티 함수에 대해 Jest 단위 테스트를 작성합니다.
