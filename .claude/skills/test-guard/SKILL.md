---
name: test-guard
description: |
  백엔드 또는 프론트엔드 코드 변경 시 반드시 사용.
  테스트 실행 및 검증까지 완료해야 작업이 끝난 것으로 간주.
  app/backend/, tests/integration/, app/frontend/ 하위 파일 수정 후 자동 적용.
---

# 테스트 검증 워크플로우

코드가 변경되었습니다. 변경된 파일을 기반으로 아래 단계를 수행하세요.

## 1. 변경 영향 분석

변경된 파일 목록을 확인하고 실행할 테스트 범위를 결정합니다.

| 변경 영역 | 실행할 테스트 |
|-----------|--------------|
| `app/backend/` | 백엔드 (Unit/Component/Contract) + Integration |
| `tests/integration/` | Integration |
| `app/frontend/` 페이지/컴포넌트 | 프론트엔드 빌드 + E2E (조건부) |
| `app/frontend/` 스타일/설정 | 프론트엔드 빌드만 |

## 2. 테스트 레벨 구조

| 레벨 | 위치 | 대상 | 특징 |
|------|------|------|------|
| **Unit** | `src/test/java/{service}/unit/` | Service 비즈니스 로직 | Mock 기반, 엣지 케이스 |
| **Component** | `src/test/java/{service}/component/` | Controller + 전체 레이어 | TestContainers MySQL |
| **Contract** | `src/test/java/{service}/contract/` | 외부 서비스 클라이언트 | WireMock |
| **Integration** | `tests/integration/test_*.py` | API 레벨 Happy Path + 인프라 | Docker 필요, pytest |
| **E2E** | `tests/e2e/specs/*.spec.ts` | 사용자 여정 전체 | Playwright, 풀스택 |

### 소스 → 테스트 매핑

| 변경 파일 | 테스트 파일 |
|----------|------------|
| `*Service.java` | `unit/*ServiceTest.java` |
| `*Controller.java` + Service + Repository | `component/*Test.java` |
| `*Client.java` (외부 서비스 호출) | `contract/*ContractTest.java` |
| API 엔드포인트/응답 구조 | `tests/integration/test_*.py` |
| 프론트엔드 페이지/컴포넌트 | `tests/e2e/specs/*.spec.ts` |

### Integration 테스트 도메인 매핑

| 변경 도메인 | Integration 테스트 파일 |
|------------|------------------------|
| user-service (인증) | `test_auth.py` |
| catalog-service (강의) | `test_courses.py` |
| planner-service (위시리스트) | `test_wishlist.py` |
| planner-service (시간표) | `test_timetable.py` |
| planner-service (시나리오) | `test_scenario.py` |
| planner-service (수강신청) | `test_registration.py` |

## 3. 백엔드 테스트 (`app/backend/` 변경 시)

### 테스트 코드 점검

> **핵심 원칙:**
> - **Unit/Component**: 비즈니스 로직, 엣지 케이스, 예외 처리 검증
> - **Integration**: 도메인은 Happy Path, `infra/`는 Cross-Cutting Concerns (보안, 인증 전파)
> - **엄격성 준수**: `pytest.skip` 사용 금지, 느슨한 상태 코드 검증 금지

- [ ] DTO 필드 변경 → 테스트의 assertion이 새 구조에 맞는지
- [ ] API 응답 변경 → `jsonPath()` 또는 response 검증이 올바른지
- [ ] 새 필드 추가 → 테스트에서 해당 필드를 검증하는지
- [ ] 필드 제거 → 제거된 필드를 참조하는 코드가 없는지

### 엄격한 검증 규칙

**1. 단일 상태 코드 검증**
```python
# ❌ 금지
assert response.status_code in (200, 400, 409)

# ✅ 필수
assert response.status_code == 201
assert response.status_code == 409, "중복 리소스는 409 Conflict"
```

**2. RESTful 상태 코드 규칙**
| 동작 | 상태 코드 |
|------|-----------|
| POST (리소스 생성) | **201 Created** |
| POST (상태 변경) | **200 OK** |
| GET | **200 OK** |
| DELETE | **204 No Content** |
| 중복 리소스 | **409 Conflict** |
| 잘못된 요청 | **400 Bad Request** |
| 리소스 없음 | **404 Not Found** |
| 인증 실패 | **401 Unauthorized** |

**3. Test Skip 금지**
```python
# ❌ 금지
if not items:
    pytest.skip("데이터 없음")

# ✅ 필수
assert items, "테스트를 위한 필수 데이터가 없습니다"
```

**4. DTO 필드 완전 검증**
```python
assert "id" in data
assert isinstance(data["id"], int)
assert data["name"] == expected_name
```

**5. 에러 응답도 검증**
```python
error = response.json()
assert "message" in error or "error" in error
```

### Unit/Component 테스트 실행

```bash
cd app/backend && ./gradlew test
```

### Integration 테스트 실행 (백엔드 변경 시 항상 필수)

백엔드(`app/backend/`)를 건드렸으면 어떤 변경이든 **무조건** 실행한다.
API 계약뿐 아니라 인프라, 비즈니스 로직, 설정 변경 등 어디까지 영향이 갔을지 모르기 때문이다.

```bash
# 1. 개발 컨테이너가 떠있다면 중지
docker compose down

# 2. 테스트용 컨테이너 실행 (tmpfs로 매번 깨끗한 DB)
docker compose -f docker-compose.test.yml up -d --build

# 3. 서비스 준비 대기
sleep 30

# 4. Integration 테스트 실행
cd tests/integration && uv sync && uv run pytest -v

# 5. 정리
docker compose -f docker-compose.test.yml down
```

## 4. 프론트엔드 테스트 (`app/frontend/` 변경 시)

```bash
cd app/frontend && npm run build
```

빌드 실패 시 타입 오류 또는 컴파일 오류를 수정하고 재실행.

## 5. E2E 테스트 (조건부)

다음 중 하나라도 해당하면 실행:
- `app/frontend/` 의 페이지(`page.tsx`) 또는 주요 컴포넌트 변경
- 새 라우트 추가 또는 기존 사용자 흐름(버튼, 페이지 이동) 변경

해당 없으면 생략 (백엔드 전용 변경, 스타일 수정 등).

```bash
# smoke만 (핵심 흐름, 권장)
cd tests/e2e && npm run test:smoke

# 전체 (새 사용자 흐름 추가 시)
cd tests/e2e && npm test
```

## 완료 조건

- [ ] 해당 Unit/Component 테스트 점검 및 수정 완료
- [ ] `cd app/backend && ./gradlew test` 통과 (백엔드 변경 시)
- [ ] Integration 테스트 통과 (백엔드 변경 시 항상 필수)
- [ ] `cd app/frontend && npm run build` 성공 (프론트엔드 변경 시)
- [ ] E2E smoke 통과 (UI 흐름 변경 시)
- [ ] **이 조건 충족 전까지 작업 미완료로 간주**
