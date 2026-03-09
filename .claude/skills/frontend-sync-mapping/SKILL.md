# 프론트엔드 동기화 매핑

/frontend-sync command가 참조하는 Java↔TypeScript 타입 매핑 및 에러 처리 패턴.

## DTO 매핑 테이블

| 백엔드 DTO | 프론트엔드 타입 | 위치 |
|-----------|----------------|------|
| `AuthResponse` | `LoginResponse` | `src/types/index.ts` |
| `UserResponse` | `User` | `src/types/index.ts` |
| `CourseResponse` | `Course` | `src/types/index.ts` |
| `WishlistItemResponse` | `WishlistItem` | `src/types/index.ts` |
| `TimetableResponse` | `Timetable` | `src/types/index.ts` |
| `TimetableItemResponse` | `TimetableItem` | `src/types/index.ts` |
| `ScenarioResponse` | `Scenario` | `src/types/index.ts` |
| `RegistrationResponse` | `Registration` | `src/types/index.ts` |
| `RegistrationStepResponse` | `RegistrationStep` | `src/types/index.ts` |

## Java → TypeScript 타입 변환

| 백엔드 (Java) | 프론트엔드 (TypeScript) | 비고 |
|--------------|------------------------|------|
| `Long` | `number` | |
| `Integer` | `number` | |
| `String` | `string` | |
| `Boolean` | `boolean` | |
| `List<T>` | `T[]` | |
| `Set<T>` | `T[]` | JSON 직렬화 시 배열 |
| `LocalDateTime` | `string` | ISO 8601 형식 |
| `Enum` | `string` 또는 union type | |
| nullable 필드 | `fieldName?: Type` | Optional(`?`) |

## 필드 불일치 점검

각 DTO 변경 후 확인:

- [ ] 필드명 일치 (camelCase)
- [ ] 필드 타입 일치 (Long → number, String → string, List → array)
- [ ] Optional 여부 일치 (nullable → `?`)
- [ ] 중첩 객체 구조 일치

## 수정 대상 파일

1. `app/frontend/src/types/index.ts` — 타입 정의
2. `app/frontend/src/lib/api/*.ts` — API 클라이언트 (필요시)
3. 변경된 필드를 사용하는 컴포넌트 (필요시)

## API 계약 규칙

CLAUDE.md 및 docs/architecture.md 참조:
- **요청**: `excludedCourseIds` (Long 배열)
- **응답**: `excludedCourses` (courseId 포함 객체 배열)

이 규칙을 위반하는 변경은 허용되지 않음.

## ErrorResponse 구조

### 백엔드 통일 구조

모든 서비스는 동일한 에러 응답 구조를 사용:

```java
// GlobalExceptionHandler의 ErrorResponse
public record ErrorResponse(int status, String message) {}
```

### 프론트엔드 타입

```typescript
// src/types/index.ts
interface ApiError {
  status: number;
  message: string;
}
```

## 에러 처리 패턴

### 올바른 패턴 ✅

```typescript
// React Query useMutation
onError: (error: AxiosError<ApiError>) => {
  const message = error.response?.data?.message || '오류가 발생했습니다';
  toast.error(message);
}

// try-catch
try {
  await api.call();
} catch (error) {
  const axiosError = error as AxiosError<ApiError>;
  const message = axiosError.response?.data?.message || '오류가 발생했습니다';
  toast.error(message);
}
```

### 금지된 패턴 ❌

```typescript
// 고정 메시지 사용 금지
onError: () => {
  toast.error('실패했습니다. 다시 시도해주세요.');
}

// 에러 객체 무시 금지
catch (error) {
  toast.error('오류가 발생했습니다');
}
```

## HTTP 상태별 처리 가이드

| HTTP 상태 | 의미 | 프론트엔드 처리 |
|-----------|------|----------------|
| 400 | 잘못된 요청 | 백엔드 message 표시 |
| 401 | 인증 실패 | 백엔드 message 표시 (로그인 페이지) |
| 404 | 리소스 없음 | 백엔드 message 표시 |
| 409 | 충돌 (중복) | 백엔드 message 표시 |
| 500 | 서버 오류 | "서버 오류가 발생했습니다" 고정 메시지 |

## 완료 조건

- [ ] 백엔드 DTO와 프론트엔드 타입 일치 확인
- [ ] 필요한 타입 수정 완료
- [ ] 관련 컴포넌트/API 클라이언트 수정 완료
- [ ] `cd app/frontend && npm run build` 성공
- [ ] ErrorResponse 구조가 모든 서비스에서 통일됨
- [ ] 모든 API 호출부에서 백엔드 메시지 파싱
