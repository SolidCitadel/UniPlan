# 코드 리뷰 판정 기준

code-reviewer agent가 참조하는 카테고리별 이슈 분류 및 판정 체계.

## 판정 체계

| 판정 | 조건 | 의미 |
|------|------|------|
| **Approve** | CRITICAL 0개 + HIGH 0개 | 병합 가능 |
| **Warning** | HIGH 있음 (CRITICAL 없음) | 병합 가능, 다음 PR에서 해결 권장 |
| **Block** | CRITICAL 있음 | 수정 필수, `/test` 재실행 |

## 카테고리별 판정 기준

### Security (주로 CRITICAL)

| 이슈 | 심각도 |
|------|--------|
| 하드코딩된 비밀 (JWT secret, 비밀번호, API 키) | CRITICAL |
| SQL Injection 취약점 | CRITICAL |
| XSS 취약점 (`dangerouslySetInnerHTML`) | CRITICAL |
| 인증 우회 가능한 코드 | CRITICAL |
| 타인 리소스 접근 방지 누락 | CRITICAL |
| 민감 정보 로그 출력 | HIGH |
| CORS 전체 허용 (`*`) | HIGH |

### Code Quality (주로 HIGH)

> 세부 코딩 규칙과 수치 기준은 **java-coding-standards skill** 참조.

| 이슈 | 심각도 |
|------|--------|
| 메서드 길이 50줄 초과 | HIGH |
| 파일 300줄 초과 | HIGH |
| 중첩 깊이 4레벨 초과 | HIGH |
| 에러 핸들링 완전 누락 (try-catch 비어있음) | HIGH |
| 빈 catch 블록 (예외 무시) | HIGH |
| `Optional.get()` 직접 호출 | MEDIUM |
| 매직 넘버/문자열 (상수화 필요) | MEDIUM |
| 중복 코드 (3회 이상 반복) | MEDIUM |

### Framework (HIGH)

| 이슈 | 심각도 |
|------|--------|
| N+1 쿼리 패턴 (`EAGER` 또는 루프 내 조회) | HIGH |
| `@Transactional` 누락 (상태 변경 메서드) | HIGH |
| `@Valid` 누락 (Controller 요청 검증 없음) | HIGH |
| 트랜잭션 경계 오류 (Service 외부에서 save 호출) | MEDIUM |
| DTO 없이 Entity 직접 반환 | MEDIUM |

### Spring Boot UniPlan 특화

| 이슈 | 심각도 |
|------|--------|
| `X-User-Id`가 아닌 요청 바디로 userId 수신 | CRITICAL |
| 내부 서비스에서 JWT 직접 파싱 (Gateway 역할 침범) | HIGH |
| `${VAR:default}` 환경변수 기본값 (ADR-005 위반) | HIGH |
| `application.yml`에 비밀값 직접 기재 | CRITICAL |

### Performance (MEDIUM)

| 이슈 | 심각도 |
|------|--------|
| 비효율적 알고리즘 (O(n²) 불필요) | MEDIUM |
| 루프 내 DB 쿼리 (N+1) | HIGH |
| 불필요한 전체 컬렉션 로드 | MEDIUM |

### Best Practices (LOW)

| 이슈 | 심각도 |
|------|--------|
| 누락된 Swagger 애노테이션 | LOW |
| 잘못된 네이밍 (컨벤션 불일치) | LOW |
| 불필요한 주석 (코드로 표현 가능) | LOW |
| `TODO`/`FIXME` 방치 | LOW |

## 검토 체크리스트

### 필수 확인

- [ ] Security: 하드코딩 비밀, SQL Injection, XSS, 인증 우회
- [ ] 소유자 검증: 타인 리소스 접근 방지
- [ ] 환경변수: ADR-005 준수 (기본값 금지)
- [ ] 에러 핸들링: 빈 catch 블록 없는지

### 코드 품질

- [ ] 메서드/파일 크기 기준 준수
- [ ] `@Valid` + `@Transactional` 적절히 적용
- [ ] Optional 올바른 사용
- [ ] DTO로 Entity 직접 노출 방지

### UniPlan 특화

- [ ] `X-User-Id` 헤더로 userId 수신
- [ ] Gateway 역할 침범 없음
- [ ] ADR-005 환경변수 패턴 준수

## 출력 예시

```
## 판정: Block

### CRITICAL
1. TimetableController.java:45: 요청 바디에서 userId 수신 → X-User-Id 헤더 사용

### HIGH
1. TimetableService.java:82: 메서드 길이 67줄 → Extract Method 적용
2. application.yml:12: DB 비밀번호 하드코딩 → ${DB_PASSWORD:?error} 사용

### MEDIUM
1. TimetableRepository.java:30: N+1 가능성 → JOIN FETCH 적용 검토
```
