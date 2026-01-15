---
name: frontend-sync
description: |
  백엔드 DTO(Request/Response) 변경 시 반드시 사용.
  프론트엔드 타입(src/types/)과 API 클라이언트가 백엔드와 일치하는지 확인.
  app/backend/**/dto/ 파일 수정 후 이 skill을 자동 적용.
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