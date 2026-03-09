# 검증 루프 (Spring Boot 특화)

/test command가 참조하는 UniPlan 빌드→테스트→보안 검증 파이프라인.
ECC의 springboot-verification 기반으로 UniPlan 환경에 맞게 적용.

## 7단계 검증 파이프라인

### Phase 1: Build (실패 시 즉시 중단)

```bash
cd app/backend && ./gradlew clean build -x test
```

컴파일 에러, 설정 오류 → 즉시 중단. 이후 Phase 진행 불가.

### Phase 2: 정적 분석 (백엔드 변경 시)

```bash
cd app/backend && ./gradlew check
```

SpotBugs, PMD, Checkstyle 실행. 경고도 리포트에 포함.

### Phase 3: 테스트 + 커버리지

```bash
cd app/backend && ./gradlew test jacocoTestReport
```

**커버리지 기준:**
- 전체: 80%+ (line coverage)
- 핵심 비즈니스 로직 (시간표 충돌, 수강신청 시뮬레이션): 100%

빌드 결과에서 확인:
```bash
cd app/backend && ./gradlew test 2>&1 | grep -E "BUILD|tests|failures|errors" | tail -10
```

### Phase 4: 보안 스캔 (의존성 CVE)

```bash
cd app/backend && ./gradlew dependencyCheckAnalyze
```

CRITICAL CVE 발견 시 BLOCKED. 의존성 버전 업그레이드 필요.

### Phase 5: Integration 테스트 (백엔드 변경 시 필수)

백엔드 코드를 건드렸으면 어떤 변경이든 **무조건** 실행.

```bash
# 개발 컨테이너 중지 (실행 중인 경우)
docker compose down

# 테스트용 컨테이너 실행
docker compose -f docker-compose.yml -f docker-compose.test.yml up -d --build

# 서비스 준비 대기
sleep 30

# Integration 테스트
cd tests/integration && uv sync && uv run pytest -v

# 정리
docker compose -f docker-compose.yml -f docker-compose.test.yml down
```

### Phase 6: E2E 테스트 (조건부)

다음 중 하나에 해당하면 실행:
- `app/frontend/` 페이지(`page.tsx`) 또는 주요 컴포넌트 변경
- 새 라우트 또는 사용자 흐름 변경

```bash
# smoke (핵심 흐름, 권장)
cd tests/e2e && npm run test:smoke

# 도메인별 단독
cd tests/e2e && npx playwright test specs/course.spec.ts
```

**E2E 전제조건:**
- Docker Compose 백엔드 기동 완료
- `tests/e2e/.env` 설정 완료 (`cp tests/e2e/.env.example tests/e2e/.env`)

### Phase 7: Diff 리뷰 (수동)

```bash
git diff --cached
```

확인 항목:
- [ ] `System.out.println` / `console.log` 디버그 코드 제거
- [ ] TODO/FIXME 주석 처리
- [ ] 에러 핸들링 누락 없는지
- [ ] 환경변수 하드코딩 없는지 (ADR-005 준수)

## 변경 영역별 실행 범위

| 변경 영역 | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 | Phase 6 |
|-----------|---------|---------|---------|---------|---------|---------|
| `app/backend/` | ✅ | ✅ | ✅ | ✅ | ✅ | 조건부 |
| `app/frontend/` 페이지/컴포넌트 | ✅ (npm build) | - | - | - | - | ✅ |
| `app/frontend/` 스타일/설정 | ✅ (npm build) | - | - | - | - | - |
| `tests/integration/` | - | - | - | - | ✅ | - |

## 출력 형식

```
### 검증 결과
- Phase 1 Build: ✅ PASS / ❌ FAIL
- Phase 2 정적 분석: ✅ PASS / ⚠️ 경고 N개 / ❌ FAIL
- Phase 3 테스트: ✅ N개 통과 / ❌ N개 실패 | 커버리지: N%
- Phase 4 보안: ✅ PASS / ⚠️ LOW N개 / ❌ CRITICAL N개
- Phase 5 Integration: ✅ N개 통과 / ❌ N개 실패
- Phase 6 E2E: ✅ PASS / ❌ FAIL / ⏭️ SKIP (해당 없음)

**판정: SHIP / NEEDS WORK / BLOCKED**
```

## 판정 기준

| 판정 | 조건 |
|------|------|
| **SHIP** | 모든 Phase 통과, 커버리지 80%+ |
| **NEEDS WORK** | 경고 있음, 커버리지 미달 |
| **BLOCKED** | 빌드 실패, 테스트 실패, CRITICAL CVE |
