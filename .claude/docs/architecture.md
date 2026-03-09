# .claude/ 시스템 아키텍처

UniPlan `.claude/` 시스템의 구조와 동작 원칙. 수정 시 업데이트 필요.
설계 근거(ECC 벤치마킹)는 `ecc-analysis.md`, 결정 이유는 `workflow-decisions.md` 참조.

---

## 1. 3-tier 구조

| 계층 | 역할 | 두께 | 예시 |
|------|------|------|------|
| **Command** | 얇은 진입점. 라우팅 + Agent/Skill 참조만 | 얇음 | `/tdd`, `/plan` |
| **Agent** | 페르소나 + 실행 책임. Tools 접근 권한 보유 | 중간 | `tdd-guide`, `planner` |
| **Skill** | 순수 재사용 가능한 도메인 지식 | 두꺼움 | `tdd-workflow`, `springboot-tdd` |

### 흐름 예시

```
/tdd (Command)         ← 얇은 진입점
  └─ tdd-guide (Agent) ← 페르소나 + 실행 책임
       └─ tdd-workflow (Skill)    ← TDD 방법론 (재사용 지식)
       └─ springboot-tdd (Skill) ← Spring Boot 테스트 패턴
```

### 자동 주입 규칙

Claude Code가 **자동**으로 컨텍스트에 주입:
- `CLAUDE.md` — 모든 에이전트·대화에 공통 적용
- `.claude/agents/*.md` — 에이전트 정의
- `.claude/skills/*/SKILL.md` — 모든 대화에 항상 주입

**자동 주입되지 않음** (명시적 호출/읽기 필요):
- `.claude/commands/*.md` — 슬래시 커맨드 호출 시에만
- `.claude/docs/*` — 명시적으로 읽을 때만

### 설계 원칙

- Command는 방법론을 직접 담지 않는다 — Agent/Skill로 위임
- Skill은 항상 로드되므로 **모든 에이전트에 공통 필요한 지식**만 담는다
- Agent는 특정 역할에만 필요한 지식을 직접 포함한다
- CLAUDE.md는 **진짜 공통 지식만**: 프로젝트 구조, API 규칙, 실행 원칙

---

## 2. 현재 구조

```
.claude/
├── CLAUDE.md                        # 프로젝트 공통 규칙 (최소한)
├── commands/                        # 11개 — 얇은 진입점
│   ├── plan.md                      # Phase 0~6 전체 오케스트레이터
│   ├── tdd.md                       # TDD 세션 (tdd-guide agent)
│   ├── code-review.md               # 코드 품질+보안 (code-reviewer agent)
│   ├── arch-review.md               # 아키텍처 리뷰 (architecture-reviewer agent)
│   ├── qa-review.md                 # 커버리지 갭 (qa-reviewer agent)
│   ├── test.md                      # 빌드→테스트→보안 검증
│   ├── doc-sync.md                  # 문서 동기화
│   ├── pm.md                        # UX/기획 상담 (product-manager agent)
│   ├── frontend-sync.md             # DTO 변경 → 프론트 타입 동기화
│   ├── adr.md                       # ADR 생성
│   └── dotclaude.md                 # .claude/ 수정 시 배경지식 로드
├── agents/                          # 6개 — 페르소나 + 실행 책임
│   ├── planner.md                   # TDD-aware 구현 계획 수립
│   ├── tdd-guide.md                 # Double Loop TDD 실행
│   ├── code-reviewer.md             # Approve/Warning/Block 판정
│   ├── architecture-reviewer.md     # SOLID/추상화/복잡도 평가
│   ├── qa-reviewer.md               # 테스트 커버리지 갭 분석
│   └── product-manager.md           # 사용성/비즈니스 가치 평가
├── skills/                          # 14개 — 순수 도메인 지식
│   # 방법론
│   ├── tdd-workflow/                # RED/GREEN/REFACTOR 7단계 프로세스
│   ├── springboot-tdd/              # Spring Boot 테스트 레이어 패턴
│   ├── verification-loop/           # 7단계 빌드→검증 파이프라인
│   # Java/Spring 표준
│   ├── java-coding-standards/       # Records, Optional, Stream 규칙
│   ├── jpa-patterns/                # Lazy loading, DTO projection, N+1
│   ├── api-design/                  # URL 구조, HTTP 상태코드, 페이지네이션
│   ├── security-review/             # 10가지 보안 체크리스트
│   ├── springboot-security/         # JWT/BCrypt/@PreAuthorize/Bucket4j
│   # 리뷰 기준
│   ├── code-review-criteria/        # Approve/Warning/Block 판정 기준
│   ├── arch-review-criteria/        # SOLID/추상화/복잡도 평가 기준
│   ├── qa-analysis-criteria/        # 경계값/Sad Path/비즈니스 엣지케이스
│   # 문서/동기화
│   ├── doc-sync-checklist/          # 변경 유형별 문서 매핑
│   ├── frontend-sync-mapping/       # Java↔TypeScript 타입 변환, 에러 구조
│   # 기획
│   └── pm-evaluation-criteria/      # UX/비즈니스 5가지 평가 기준
└── docs/                            # 참조 문서 (자동 주입 안 됨)
    ├── architecture.md              # 이 파일: 구조와 동작 원칙
    ├── ecc-analysis.md              # ECC 벤치마킹 분석 (설계 근거)
    └── workflow-decisions.md        # 워크플로우 설계 결정 근거
```
