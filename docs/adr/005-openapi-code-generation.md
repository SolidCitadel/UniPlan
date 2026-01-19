# ADR-005: OpenAPI 기반 코드 자동 생성 전략

**상태**: 승인됨  
**작성일**: 2025-01-20

## 배경 (Context)

마이크로서비스 아키텍처(MSA) 환경에서 프론트엔드, 백엔드, 테스트 코드 간 **API 스펙 불일치** 문제 발생.

1.  **필드 누락**: 백엔드 DTO 변경 사항이 클라이언트 코드에 즉시 반영되지 않아 런타임 오류 발생 (예: `universityId` 누락).
2.  **타입 불안정성**: `any` 타입 사용 등 타입 안전성 부재.
3.  **반복 작업**: API 변경 시마다 클라이언트 코드를 수동으로 수정하는 유지보수 비용 발생.

## 고려한 대안 (Alternatives Considered)

| 대안 | 설명 | 장점 | 단점 |
|------|------|------|------|
| **1. 수동 명세 관리** | Wiki나 Notion 등에 API 명세 작성 후 수동 코딩 | 유연성 높음 | 문서와 코드의 불일치 발생 빈번, 높은 유지보수 비용 |
| **2. Design-First** | OpenAPI YAML 사양서를 먼저 작성하고 백엔드/프론트 코드 생성 | 명확한 계약 우선 | 사양서 작성의 번거로움, 빠른 개발 속도 저해 |
| **3. Code-First (Selected)** | 백엔드 코드(Controller/DTO)를 SSOT로 하여 OpenAPI 및 클라이언트 코드 자동 생성 | **개발 속도 빠름**, 코드와 명세의 **완벽한 동기화** | 백엔드 코드에 OpenAPI 어노테이션 의존성 추가 |

## 결정 (Decision)

**Code-First 접근 방식을 채택하여, 프론트엔드와 Integration 테스트 코드를 OpenAPI 스펙 기반으로 자동 생성한다.**

1.  **Single Source of Truth**: 백엔드(Java/Kotlin) 코드를 유일한 명세 원천으로 지정.
2.  **SpringDoc 활용**: 백엔드 런타임에 `springdoc-openapi`를 통해 최신 OpenAPI JSON 노출.
3.  **클라이언트 코드 자동 생성**:
    - **Frontend**: `openapi-typescript`를 사용하여 TypeScript 인터페이스 생성.
    - **Integration Test**: `datamodel-code-generator`를 사용하여 Python Pydantic 모델 생성.
4.  **CI 강제화**: GitHub Actions에서 생성된 코드와 최신 백엔드 스펙의 일치 여부 검증.

## 근거 (Rationale)

- **생산성**: 소규모 팀에서 사양서를 별도로 관리하는 비용을 줄이고, 코드 작성에 집중할 수 있습니다.
- **안전성**: 컴파일 타임(TS) 및 테스트 타임(Pydantic)에 API 불일치를 즉시 감지할 수 있습니다.
- **자동화**: 사람의 개입 없이 스펙 변경이 전파되므로 휴먼 에러를 방지합니다.

## 영향 (Consequences)

### 긍정적 영향
- 백엔드 DTO 변경 시 프론트엔드/테스트 컴파일 오류가 발생하여, 변경 영향 범위를 즉시 파악 가능.
- 테스트 코드 작성 시 Response 스키마 검증 로직이 간소화됨.

### 부정적 영향 / 트레이드오프
- 백엔드가 실행되어야만 클라이언트 코드를 생성할 수 있음 (CI/CD 파이프라인에서 백엔드 구동 시간 필요).
- Java의 `LocalDateTime` 등 일부 타입과 클라이언트 타입 간의 호환성 관리 필요 (별도 치환 로직이나 매핑 설정 필요).

## 관련 문서 (References)
- [Architecture - API Specification & Code Generation](../architecture.md#api-specification--code-generation)
- [Guide - Integration Testing](../guides/testing.md#pydantic-model-generation-validation)
