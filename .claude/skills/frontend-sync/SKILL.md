---
name: frontend-sync
description: |
  백엔드 API 계약(DTO, 에러 응답) 변경 시 반드시 사용.
  프론트엔드 타입과 에러 처리가 백엔드와 일치하는지 확인.
  app/backend/**/dto/ 또는 **/exception/ 파일 수정 후 이 skill을 자동 적용.
---

# 프론트엔드 타입 동기화 워크플로우

백엔드 DTO가 변경되었습니다. 프론트엔드와 동기화를 확인해야 합니다.

## 1. 변경된 DTO 확인

변경된 백엔드 DTO 파일 식별:
- `*Request.java`
- `*Response.java`

## 2. 프론트엔드 타입 매핑

| 백엔드 DTO | 프론트엔드 타입 |
|-----------|----------------|
| `AuthResponse` | `LoginResponse` in `src/types/index.ts` |
| `UserResponse` | `User` in `src/types/index.ts` |
| `CourseResponse` | `Course` in `src/types/index.ts` |
| `WishlistItemResponse` | `WishlistItem` in `src/types/index.ts` |
| `TimetableResponse` | `Timetable` in `src/types/index.ts` |
| `TimetableItemResponse` | `TimetableItem` in `src/types/index.ts` |
| `ScenarioResponse` | `Scenario` in `src/types/index.ts` |
| `RegistrationResponse` | `Registration` in `src/types/index.ts` |
| `RegistrationStepResponse` | `RegistrationStep` in `src/types/index.ts` |

## 3. 불일치 점검

각 필드별로 확인:

- [ ] 필드명 일치 (camelCase)
- [ ] 필드 타입 일치 (Long → number, String → string, List → array)
- [ ] Optional 여부 일치 (nullable → `?`)
- [ ] 중첩 객체 구조 일치

### 주의할 패턴

| 백엔드 | 프론트엔드 |
|--------|-----------|
| `Long` | `number` |
| `Integer` | `number` |
| `String` | `string` |
| `Boolean` | `boolean` |
| `List<T>` | `T[]` |
| `Set<T>` | `T[]` (JSON 직렬화 시 배열) |
| `LocalDateTime` | `string` (ISO 형식) |
| `Enum` | `string` 또는 union type |

## 4. 프론트엔드 수정 (필요시)

### 타입 수정
`app/frontend/src/types/index.ts` 업데이트

### API 클라이언트 수정 (필요시)
`app/frontend/src/lib/api/*.ts` 확인

### 컴포넌트 수정 (필요시)
변경된 필드를 사용하는 컴포넌트 확인:
- 필드명 변경: `parentId` → `parentScenarioId`
- 중첩 구조 변경: `response.email` → `response.user.email`

## 5. 빌드 검증

```bash
cd app/frontend
npm run build
```

TypeScript 컴파일 에러가 없어야 함.

## 완료 조건

- [ ] 백엔드 DTO와 프론트엔드 타입 일치 확인
- [ ] 필요한 타입 수정 완료
- [ ] 관련 컴포넌트/API 클라이언트 수정 완료
- [ ] `npm run build` 성공
- [ ] **이 조건 충족 전까지 DTO 변경 작업 미완료로 간주**

## API 계약 규칙 (중요)

CLAUDE.md 및 docs/architecture.md 참조:
- **요청**: `excludedCourseIds` (Long 배열)
- **응답**: `excludedCourses` (courseId 포함 객체 배열)

이 규칙을 위반하는 변경은 허용되지 않음.

---

# 에러 응답 동기화 워크플로우

백엔드 에러 처리가 변경되었거나, 프론트엔드 에러 표시를 확인해야 합니다.

## 6. ErrorResponse 구조 확인

### 통일된 에러 응답 구조

모든 백엔드 서비스는 동일한 구조 사용:

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

## 7. 에러 처리 체크리스트

### 백엔드 확인

- [ ] 새 예외 클래스가 GlobalExceptionHandler에 등록되었는가?
- [ ] 적절한 HTTP 상태 코드 반환 (400, 401, 404, 409 등)
- [ ] 사용자 친화적 한글 메시지 포함

### 프론트엔드 확인

- [ ] API 호출부에서 에러 파싱: `error.response?.data?.message`
- [ ] 사용자에게 백엔드 메시지 표시 (고정 메시지 금지)
- [ ] HTTP 상태별 분기 처리 (필요시)

## 8. 에러 상태별 처리 가이드

| HTTP 상태 | 의미 | 프론트엔드 처리 |
|-----------|------|----------------|
| 400 | 잘못된 요청 | 백엔드 message 표시 |
| 401 | 인증 실패 | 백엔드 message 표시 (로그인 페이지) |
| 404 | 리소스 없음 | 백엔드 message 표시 |
| 409 | 충돌 (중복) | 백엔드 message 표시 |
| 500 | 서버 오류 | "서버 오류가 발생했습니다" 고정 메시지 |

## 9. 에러 처리 패턴

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

## 완료 조건 (에러 처리)

- [ ] ErrorResponse 구조가 모든 서비스에서 통일됨
- [ ] 프론트엔드 ApiError 타입 정의됨
- [ ] 모든 API 호출부에서 백엔드 메시지 파싱
- [ ] 고정 에러 메시지 사용 없음
- [ ] **이 조건 충족 전까지 에러 처리 변경 작업 미완료로 간주**