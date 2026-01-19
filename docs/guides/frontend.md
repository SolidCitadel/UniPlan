# Frontend Development Guide

UniPlan 프론트엔드 (Next.js) 개발 가이드입니다.

## 1. Tech Stack

- **Framework**: Next.js 16 (App Router)
- **Language**: TypeScript
- **State Management**: React Query (@tanstack/react-query)
- **UI Toolkit**: shadcn/ui + Tailwind CSS
- **HTTP Client**: axios

## 2. Coding Conventions

### 명명 규칙
- **Component**: PascalCase (`TimetableList`, `WeeklyGrid`)
- **Variable/Function**: camelCase (`fetchTimetables`)
- **File**: kebab-case (`timetable-list.tsx`, `weekly-grid.tsx`)
- **Type/Interface**: PascalCase (`Timetable`)

### 상태 관리 (React Query)

- **서버 상태**: `useQuery`, `useMutation` 적극 활용
- **로컬 상태**: `useState`는 UI 전용 상태(모달 열림 등)에만 사용

```typescript
// 예시: 시간표 목록 조회
const { data: timetables, isLoading } = useQuery({
  queryKey: ['timetables'],
  queryFn: timetableApi.getAll,
});

// 예시: 시간표 생성
const createMutation = useMutation({
  mutationFn: timetableApi.create,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['timetables'] });
  },
});
```

## 3. OpenAPI Type Generation

백엔드의 Swagger/OpenAPI 스펙을 기반으로 TypeScript 타입을 자동 생성합니다.

### 워크플로우
1. 백엔드 서비스 실행 (Docker 등)
2. `npm run types:generate` 실행
3. 생성된 타입은 `git commit` 포함

### 사용법
```typescript
import type { Timetable } from '@/types';
// 백엔드 DTO 변경 시 컴파일 에러 발생으로 안전성 보장
```

## 4. Directory Structure

```
app/frontend/
├── src/
│   ├── app/                # Next.js App Router (Pages)
│   ├── components/
│   │   ├── ui/             # shadcn/ui 공용 컴포넌트
│   │   └── ...             # 비즈니스 컴포넌트
│   ├── lib/
│   │   └── api/            # API Clients (axios)
│   ├── types/              # Generated Types
│   └── hooks/              # Custom Hooks
```
