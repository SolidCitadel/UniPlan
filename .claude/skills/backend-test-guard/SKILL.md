---
name: backend-test-guard
description: |
  백엔드 코드(Controller, Service, DTO, Entity, Repository) 변경 시 반드시 사용.
  테스트 코드 점검, 수정, 검증까지 완료해야 백엔드 작업이 끝난 것으로 간주.
  app/backend/ 하위 파일 수정 후 이 skill을 자동 적용.
---

# 백엔드 변경 시 테스트 검증 워크플로우

백엔드 코드가 변경되었습니다. 다음 단계를 **반드시** 수행해야 합니다.

## 1. 변경 영향 분석

- 변경된 파일 목록 확인
- 변경 유형 파악:
  - DTO 필드 추가/삭제/변경
  - API 응답 구조 변경
  - 비즈니스 로직 변경
  - Entity 구조 변경

## 2. 관련 테스트 파일 식별

### 테스트 레벨

| 유형 | 위치 | 테스트 대상 |
|------|------|------------|
| **Unit** | `unit/` | 비즈니스 로직, 엣지 케이스, 예외 처리 |
| **Component** | `component/` | 단일 서비스 전체 레이어, TestContainers MySQL |
| **Contract** | `contract/` | 다른 서비스 API 계약 |
| **Integration** | `tests/integration/` | 전체 시스템 Happy Path |

### 테스트 파일 매핑

| 변경 파일 | 테스트 파일 |
|----------|------------|
| `*Service.java` | `unit/*ServiceTest.java` |
| `*Controller.java` + Service + Repository | `component/*Test.java` |
| `*Client.java` (외부 서비스 호출) | `contract/*ContractTest.java` |
| API 엔드포인트/응답 구조 | `tests/integration/test_*.py` |

### Integration 테스트 매핑 (tests/integration/)

| 변경 도메인 | Integration 테스트 파일 |
|------------|------------------------|
| user-service (인증) | `test_auth.py` |
| catalog-service (강의) | `test_courses.py` |
| planner-service (위시리스트) | `test_wishlist.py` |
| planner-service (시간표) | `test_timetable.py` |
| planner-service (시나리오) | `test_scenario.py` |
| planner-service (수강신청) | `test_registration.py` |

## 3. 테스트 코드 점검

> **핵심 원칙:**
> - **Unit/Component**: 비즈니스 로직, 엣지 케이스, 예외 처리 검증
> - **Integration**: Happy Path만, 실제 환경 통합 검증

각 테스트 파일에서 확인:

- [ ] DTO 필드 변경 → 테스트의 assertion이 새 구조에 맞는지
- [ ] API 응답 변경 → `jsonPath()` 또는 response 검증이 올바른지
- [ ] 새 필드 추가 → 테스트에서 해당 필드를 검증하는지
- [ ] 필드 제거 → 제거된 필드를 참조하는 코드가 없는지

## 4. 테스트 수정 (필요시)

변경된 구조에 맞게 테스트 코드 업데이트.

### 엄격한 검증 규칙 (필수 준수)

**1. 단일 상태 코드 검증**
```python
# ❌ 금지 - 느슨한 검증
assert response.status_code in (200, 400, 409)

# ✅ 필수 - 정확한 상태 코드
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

**3. DTO 필드 완전 검증**
```python
# 필수 필드 존재 확인
assert "id" in data
assert "name" in data
assert "createdAt" in data

# 타입 검증
assert isinstance(data["id"], int)
assert isinstance(data["items"], list)

# 값 검증
assert data["name"] == expected_name
```

**4. 에러 응답도 검증**
```python
# 에러 구조 확인 (프론트엔드가 메시지를 표시할 수 있도록)
error = response.json()
assert "message" in error or "error" in error
```

## 5. 테스트 실행 및 검증

### Unit/Component 테스트 (필수)

```bash
cd app/backend
./gradlew test
```

### Integration 테스트 (주요 API 변경 시)

```bash
# 1. 개발 컨테이너가 떠있다면 중지
docker compose down

# 2. 테스트용 컨테이너 실행 (tmpfs로 매번 깨끗한 DB)
docker compose -f docker-compose.test.yml up -d --build

# 3. 서비스 준비 대기 (약 30초)
sleep 30

# 4. Integration 테스트 실행
cd tests/integration
uv sync
uv run pytest -v

# 5. 테스트 완료 후 정리
docker compose -f docker-compose.test.yml down
```

**Integration 테스트 실행 조건:**
- API 엔드포인트 추가/삭제/변경
- 요청/응답 구조 변경
- 인증 흐름 변경

### 실패 시 대응

1. 실패 원인 분석
2. 테스트 코드 또는 프로덕션 코드 수정
3. 재실행하여 통과 확인

## 완료 조건

- [ ] 모든 관련 Unit/Component 테스트 파일 점검 완료
- [ ] 필요한 테스트 수정 완료
- [ ] `./gradlew test` 전체 통과
- [ ] (주요 변경 시) Integration 테스트 통과
- [ ] **이 조건 충족 전까지 백엔드 작업 미완료로 간주**