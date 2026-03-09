# ECC 벤치마킹 분석 보고서

UniPlan `.claude/` 아키텍처의 설계 근거 및 ECC 채택 내역을 기록하는 영구 참조 문서.
현재 구조와 동작 원칙은 `architecture.md` 참조.

---

## 1. 설계 배경

**출처**: ECC(everything-claude-code) — Claude Code를 위한 커뮤니티 `.claude/` 설정 모음.

ECC는 Commands(40개) / Agents(16개) / Skills(65개)로 이루어진 3-tier 구조를 사용한다.
UniPlan은 이 구조를 채택하되, Spring Boot MSA + Next.js 환경에 특화해 적용했다.

**분석 시점**: 2026년 3월 (ECC 기준 시점)

**분석 범위**:

| 카테고리 | ECC 전체 | 분석함 | 비율 | 주요 확인 파일 |
|---------|---------|--------|------|-------------|
| Commands | 40개 | 14개 | 35% | plan, tdd, multi-plan, orchestrate, update-docs, code-review, e2e, test-coverage, verify, quality-gate, refactor-clean, learn, evolve, instinct-status |
| Skills | 65개 | 18개 | 28% | tdd-workflow, springboot-tdd, springboot-patterns, verification-loop, coding-standards, backend-patterns, frontend-patterns, e2e-testing, java-coding-standards, jpa-patterns, api-design, security-review, autonomous-loops, continuous-learning-v2, springboot-security, springboot-verification, iterative-retrieval, docker-patterns |
| Agents | 16개 | 8개 | 50% | planner, tdd-guide, e2e-runner, architect, code-reviewer, doc-updater, security-reviewer, build-error-resolver |

미확인 영역: `security-scan`, `sessions`, `checkpoint` commands; `loop-operator`, `chief-of-staff` agents; `agentic-engineering`, `enterprise-agent-ops` skills.
→ 핵심 Java/Spring Boot 파일 + 자기학습 메타시스템(learn/evolve/instinct) 확인. 미확인 영역은 현재 UniPlan 범위 초과로 판단해 스킵.

**채택 이유**:
- 기존 UniPlan Skills가 실행 절차 + 도메인 지식을 혼합 → 재사용 불가
- Command 계층 부재로 워크플로우 진입점이 불명확
- ECC의 3-tier 분리가 유지보수성과 재사용성을 높인다는 판단

---

## 2. ECC Command 구조 (실제 파일 패턴)

ECC Command 파일은 이렇게 생겼다:
```markdown
---
description: 한 줄 설명
---
# /command-name
"This command invokes the [agent] agent"
"References the [skill] skill"
언제 사용하는가
인접 커맨드 참조
```
→ 방법론을 직접 담지 않는다. 단, 절차가 단순하면 Command에 직접 포함 가능 (ECC `/update-docs` 패턴).

---

## 3. ECC에서 채택한 것 vs UniPlan 특화

### 채택 (직접 적용)

| ECC 요소 | UniPlan 적용 | 비고 |
|---------|-------------|------|
| 3-tier Command/Agent/Skill 구조 | 동일 채택 | 핵심 설계 |
| `iterative-retrieval` 패턴 | planner, tdd-guide agent에 명시 | DISPATCH→EVALUATE→REFINE→LOOP |
| `code-reviewer` agent 판정 체계 | Approve/Warning/Block | code-review-criteria skill |
| `java-coding-standards` skill | UniPlan 특화 버전으로 적용 | Records, Optional, Stream 규칙 |
| `jpa-patterns` skill | UniPlan 특화 | Lazy loading, DTO projection |
| `api-design` skill | Gateway 패턴 반영 | X-User-Id 헤더 패턴 추가 |
| `security-review` skill | Spring Boot/Next.js 특화 | JWT/BCrypt/CORS 반영 |

### UniPlan 특화 (ECC에서 변형)

| ECC 원본 | UniPlan 변형 | 이유 |
|---------|------------|------|
| `tdd-workflow` (Next.js/Jest 중심) | Spring Boot + Jest 혼합 | MSA 백엔드 중심 |
| `verification-loop` (일반) | `springboot-verification` 기반 7단계 | Spring Boot 특화 파이프라인 |
| `springboot-tdd` | Unit/Component/Contract 레이어 추가 | ECC보다 세분화된 백엔드 테스트 |

### 미도입 (범위 초과 또는 불필요)

| ECC 기능 | 미도입 이유 | 재검토 시점 |
|---------|-----------|----------|
| Learn/Evolve/Instinct 자기학습 시스템 | 복잡한 메타시스템, hooks/homunculus 인프라 필요 | 기반 구조 안정화 후 |
| `jest-rtl-patterns` skill | 프론트 Jest/RTL 미구성 | 프론트 TDD 인프라 도입 시 |
| `refactor-cleaner` agent | 현재 우선순위 낮음 | 기술 부채 증가 시 |
| `quality-gate` command | `/test`로 커버됨 | 중복 |

---

## 4. 테스트 레이어 (ECC vs UniPlan)

ECC는 3-tier (Unit/Integration/E2E). UniPlan 백엔드는 5레이어로 더 세분화:

| ECC | UniPlan 백엔드 | 프레임워크 | 경로 |
|-----|--------------|---------|------|
| Unit (Jest/RTL) | Unit | JUnit5 + Mockito | `src/test/java/.../unit/` |
| — | Component | MockMvc + DockerRequiredExtension | `src/test/java/.../component/` |
| — | Contract | WireMock | `src/test/java/.../contract/` |
| Integration | Integration | pytest | `tests/integration/` |
| E2E (Playwright) | E2E | Playwright | `tests/e2e/` |

**갭**: UniPlan 프론트엔드에 Unit 테스트(Jest/RTL) 미구성. 현재 Playwright E2E로만 커버.

---

## 5. 향후 고려 사항

| 항목 | 설명 | 트리거 조건 |
|------|------|-----------|
| `skills/jest-rtl-patterns/` | React Testing Library 패턴 | 프론트 Jest/RTL 인프라 도입 시 |
| Learn/Evolve/Instinct 시스템 | ECC 자기학습 메타시스템 | 현재 MEMORY.md로 대체 중. 패턴 축적 후 검토 |
| `agents/refactor-cleaner.md` | 기술 부채 정리 전담 agent | 기술 부채 증가 시 |
