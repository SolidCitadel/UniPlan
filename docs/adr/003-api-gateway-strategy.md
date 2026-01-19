# ADR-003: 중앙집중식 API Gateway 및 인증 (API Gateway Strategy)

**상태**: 승인됨  
**작성일**: 2026-01-20

## 배경 (Context)

MSA 환경에서 클라이언트(Frontend)가 직접 다수의 마이크로서비스와 통신하면:
1. **CORS & 보안**: 모든 서비스가 CORS 설정과 인증 로직을 중복 구현해야 함
2. **복잡성**: 클라이언트가 내부 서비스의 주소와 포트를 모두 알아야 함
3. **Chatty Communication**: 화면 하나를 그리기 위해 여러 번의 호출 필요

## 고려한 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 |
|------|------|------|
| 직접 서비스 호출 | 단순함, 홉 없음 | CORS 중복, 서비스 노출 |
| BFF (Backend for Frontend) | 클라이언트별 최적화 | 추가 개발 비용 |
| **API Gateway (선택)** | 중앙 인증, 단일 진입점 | SPOF 위험, 추가 홉 |

## 결정 (Decision)

**Spring Cloud Gateway**를 단일 진입점으로 사용하고, **인증(Authentication) 책임을 Gateway에 중앙화**합니다.

### 핵심 패턴

1. **Gateway Offloading**:
   - JWT 검증은 Gateway에서 단 한 번 수행
   - 검증된 사용자 정보는 HTTP 헤더(`X-User-Id`)로 내부 서비스에 전파
   - 내부 서비스는 헤더 값만 신뢰

2. **Route Transformation**:
   - 외부 경로: `/api/v1/{resource}`
   - 내부 경로: `/{resource}`
   - Gateway가 Prefix 제거(RewritePath)하여 라우팅

## 근거 (Rationale)

- **DRY (Don't Repeat Yourself)**: 보안 로직, 로깅, Rate Limiting을 한 곳에서 관리
- **클라이언트 단순화**: 프론트엔드는 Gateway 주소 하나만 알면 됨
- **보안 강화**: 내부 서비스는 사설망에 숨기고 Gateway만 외부 노출

## 영향 (Consequences)

### 긍정적 영향
- 각 마이크로서비스의 코드가 단순해짐 (인증 로직 제거)
- API 정책 변경이나 버전 관리가 용이

### 부정적 영향 / 트레이드오프
- Gateway가 단일 장애 지점(SPOF)이 될 수 있음
- Gateway를 거치는 추가 네트워크 홉으로 미세한 지연 발생

## 관련 문서 (References)
- 반영된 문서: [architecture.md](../architecture.md#jwt-인증-흐름)
- 관련 ADR: [ADR-002 MSA](./002-msa-ddd-strategy.md)
