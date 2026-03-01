# ADR-009: Playwright E2E 테스트 도입

**상태**: 승인됨
**작성일**: 2026-03-02

## 배경 (Context)

ADR-006에서 E2E 테스트 레이어를 정의했으나 구현 도구와 위치가 미정("향후 Flutter")이었다.
현재 프론트엔드는 Next.js(브라우저 기반)이며, pytest Integration Test는 API 레이어만 검증한다.
로그인 → 시간표 생성과 같은 **브라우저 레벨의 사용자 여정**은 수동 테스트에 의존하고 있어 자동화가 필요하다.

## 고려한 대안 (Alternatives Considered)

| 대안 | 장점 | 단점 |
|------|------|------|
| **Playwright (선택)** | 빠름, 자동 대기, storageState 인증 패턴, TS 네이티브, 활발한 생태계 | - |
| Cypress | 풍부한 레퍼런스, 대화형 UI | 느림, 유료 플랜 필요, 크로스 도메인 제약 |
| Selenium | 다양한 브라우저 지원 | 느림, 설정 복잡, 유지보수 비용 높음 |
| pytest + Playwright | Integration Test와 동일 언어 | TS 타입 활용 불가, POM 패턴 어색 |

## 결정 (Decision)

**Playwright**를 E2E 테스트 도구로 채택한다.
위치는 `tests/e2e/`(독립 npm 패키지)로 하여 Integration Test(`tests/integration/`)와 동일한 레벨에서 분리한다.

### 핵심 설계

- **storageState 패턴**: `auth.setup.ts`에서 1회 로그인 후 `.auth/user.json`에 브라우저 상태 저장. 이후 모든 spec이 재사용
- **Page Object Model**: `pages/` 디렉터리에 UI 인터랙션 캡슐화. 로케이터 변경 시 spec 영향 최소화
- **@smoke 태그**: CI에서 빠르게 돌릴 최소 subset (`npm run test:smoke`)
- **webServer**: Playwright가 Next.js를 자동 기동. 로컬은 이미 떠 있으면 재사용
- **브라우저**: 초기 Chromium only. 안정화 후 Firefox/WebKit 추가

### 패키지 매니저

`tests/e2e/`는 `app/frontend/`와 독립된 패키지다.
현재는 프론트엔드와의 일관성을 위해 **npm**을 사용하며, 추후 bun/pnpm으로 마이그레이션 가능하다.

## 근거 (Rationale)

- Playwright는 **자동 대기(auto-waiting)** 내장으로 flaky test 감소
- `storageState`로 매 테스트마다 로그인하는 비용 제거
- TypeScript 네이티브 지원 → 프론트엔드 타입과 동일한 언어로 일관성 유지
- `webServer` 옵션으로 별도 프로세스 관리 없이 테스트 실행 가능

## 영향 (Consequences)

### 긍정적 영향
- 브라우저 레벨 사용자 여정 자동 검증 가능
- ADR-006에서 정의한 5단계 테스트 전략의 E2E 레이어 구현 완료
- `@smoke` 태그로 CI 시 빠른 피드백 가능

### 부정적 영향 / 트레이드오프
- 백엔드 컨테이너(`docker-compose.test.yml`) 기동이 선행되어야 함
- Chromium 바이너리 다운로드(~280MB)로 최초 설치 시간 증가
- 프론트엔드 UI 변경 시 POM 파일도 함께 유지보수 필요

## 관련 문서 (References)

- 관련 ADR: [ADR-006: Test Strategy](./006-test-strategy.md)
- E2E 가이드: [guides/e2e-testing.md](../guides/e2e-testing.md)
- 반영된 문서: [guides/testing.md](../guides/testing.md)
