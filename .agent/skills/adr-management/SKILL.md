---
name: adr-management
description: |
  중요한 아키텍처/기술 결정 후 반드시 사용.
  ADR(Architecture Decision Record) 생성 또는 수정 후 관련 문서 최신화.
  docs/adr/ 폴더에 새 ADR 추가 시 docs/README.md 인덱스도 업데이트.
---

# ADR 관리 워크플로우

중요한 아키텍처 또는 기술 결정이 이루어졌습니다. ADR을 작성하고 관련 문서를 업데이트해야 합니다.

## 1. ADR 작성 여부 판단

다음 중 하나에 해당하면 ADR 작성:

- [ ] 아키텍처 패턴 결정 (MSA, DDD, CQRS 등)
- [ ] 기술 스택 선택 (DB, 메시징, 인증 방식 등)
- [ ] 중요한 설계 원칙 확립
- [ ] 기존 아키텍처 결정 변경

## 2. ADR 파일 생성

### 파일명 규칙

```
docs/adr/NNN-kebab-case-title.md
```

- `NNN`: 순번 (001, 002, ...)
- 예: `004-centralized-config.md`

### 작성 원칙 (Writing Style)

- **어조**: 주관적인 서술("우리는 ~했습니다")을 배제하고 **객관적이고 건조한** 어조를 유지한다.
- **종결어미**: 문장은 가급적 **명사형**으로 끝맺는다. (예: "~하기로 결정함", "~가 발생함")
- **간결성**: 장황한 설명보다는 핵심 내용 위주로 개조식 작성을 지향한다.

### ADR 템플릿

```markdown
# ADR-NNN: [제목]

**상태**: 승인됨 | 폐기됨 | 대체됨 (→ ADR-XXX)  
**작성일**: YYYY-MM-DD

## 배경 (Context)
이 결정이 필요했던 문제 상황. 무엇이 불편했는가?

## 고려한 대안 (Alternatives Considered)
| 대안 | 장점 | 단점 |
|------|------|------|
| A 방식 | ... | ... |
| B 방식 | ... | ... |
| **선택된 방식** | ... | ... |

## 결정 (Decision)
무엇을 결정했는가? 핵심만 간결하게.

## 근거 (Rationale)
왜 이 대안을 선택했는가? 다른 대안을 버린 이유.

## 영향 (Consequences)

### 긍정적 영향
- ...

### 부정적 영향 / 트레이드오프
- ...

## 관련 문서 (References)
- 관련 ADR: [ADR-XXX](./XXX-*.md)
- 반영된 문서: [architecture.md](../architecture.md#섹션)
```

## 3. 관련 문서 업데이트

ADR 생성/수정 후 반드시 업데이트:

| 문서 | 업데이트 내용 |
|------|--------------|
| `docs/README.md` | ADR 섹션에 새 항목 추가 |
| `docs/architecture.md` | 결정 사항을 아키텍처에 반영 (해당 시) |
| `.claude/CLAUDE.md` | 핵심 규칙 변경 시 반영 |

## 4. 완료 조건

- [ ] ADR 파일 생성/수정 완료
- [ ] `docs/README.md` ADR 인덱스 업데이트
- [ ] `docs/architecture.md`에 결정 사항 반영 (해당 시)
- [ ] **이 조건 충족 전까지 결정 작업 미완료로 간주**

## ADR 위치 참고

```
UniPlan/
├── docs/
│   ├── README.md              # ADR 인덱스 포함
│   ├── architecture.md        # ADR 내용 반영
│   └── adr/
│       ├── 001-test-strategy.md
│       ├── 002-msa-ddd-strategy.md
│       ├── 003-api-gateway-strategy.md
│       └── 004-centralized-config.md
```
