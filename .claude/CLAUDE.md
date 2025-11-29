# UniPlan Project Guide

## 프로젝트 개요
UniPlan은 대학 수강신청 계획을 돕는 웹 애플리케이션입니다.

## 아키텍처
- **백엔드**: Spring Boot (Java) - `app/backend`
  - catalog-service: 과목 크롤링 및 카탈로그 관리
  - planner-service: 시간표/시나리오/등록 지원 기능
- **프론트엔드**: Flutter Web - `app/frontend`
- **CLI**: Dart CLI - `app/cli-client`
- **프로토타입**: TypeScript/Vite - `Uniplanprototype`

## 핵심 제약사항

### 1. 백엔드 우선 원칙
- 모든 기능 구현 시 백엔드 API를 먼저 확인하고 프론트엔드를 맞춥니다.
- Controller, DTO, 응답 형태를 확인한 후 클라이언트를 구현합니다.

### 2. API Gateway & 인증 규칙 (중요)
- **API 경로 규칙**:
  - 모든 외부 요청은 `/api/v1/*` 형식으로 시작
  - Gateway가 `/api/v1/segment` → `/segment`로 rewrite하여 내부 서비스로 전달
  - 예: 클라이언트 `/api/v1/timetables/123` → 내부 `/timetables/123`

- **JWT 인증 패턴**:
  - 요청: `Authorization: Bearer {token}` 헤더
  - Gateway가 JWT 검증 후 `X-User-Id`, `X-User-Email`, `X-User-Role` 헤더 추가
  - 인증 불필요: `/api/v1/auth/**`
  - 인증 필수: `/api/v1/users/**`, `/api/v1/planner/**`, `/api/v1/timetables/**`, 등

- **서비스별 라우팅**:
  - user-service: `/api/v1/auth/**`, `/api/v1/users/**`
  - planner-service: `/api/v1/planner/**`, `/api/v1/timetables/**`, `/api/v1/scenarios/**`, `/api/v1/wishlist/**`, `/api/v1/registrations/**`
  - catalog-service: `/api/v1/courses/**`, `/api/v1/catalog/**`

### 3. API 계약 (중요)
- **타임테이블/시나리오**:
  - 요청: `excludedCourseIds` (Long 배열)
  - 응답: `excludedCourses` (courseId를 포함한 객체 배열)
- 모든 클라이언트는 이 계약을 준수해야 합니다.

### 4. Flutter 프론트엔드 규칙
- **엔티티/DTO**: freezed abstract class 패턴만 사용
- **상태관리**: `flutter_riverpod`의 `AsyncNotifier` + `AsyncNotifierProvider`만 사용
  - `StateNotifier`, `AutoDisposeAsyncNotifier`, 별도 `riverpod` 패키지 사용 금지
- **디자인**: `AppTokens` (색상/타이포/스페이싱/라운딩) 기반 일관성 유지
- **코드 생성**: `build_runner`로 생성된 파일(*.g.dart, *.freezed.dart)은 반드시 갱신 후 커밋

### 5. 품질 게이트
- `./gradlew test` (백엔드)
- `flutter analyze && flutter test` (프론트엔드)
- 모든 코드 변경 시 품질 게이트 통과 필수

### 6. 보안
- 비밀값(.env, DB 비밀번호, JWT 시크릿) 커밋 절대 금지
- 로컬 설정은 예시 파일만 제공

### 7. 문서화
- 코드 변경 시 관련 README/AGENT 문서 동반 갱신

## 상세 가이드 참조
**작업 전 반드시 다음 문서들을 확인하세요:**

- **루트 AGENTS.md**: 프로젝트 전반의 공통 원칙, 주요 경로, 자주 쓰는 명령어, PR 체크리스트
- **app/frontend/AGENTS.md**: Flutter 프론트엔드 필수 규칙, 현재 상태, 다음 단계, 명령어 요약

## 주요 명령어

### 백엔드
```bash
cd app/backend
./gradlew clean build
./gradlew :catalog-service:bootRun
./gradlew :planner-service:bootRun
```

### 프론트엔드
```bash
cd app/frontend
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
flutter analyze
flutter test
```

### CLI
```bash
cd app/cli-client
dart run bin/cli_client.dart [args]
```

## 작업 시작 전 체크리스트
1. 백엔드 API 확인 (컨트롤러, DTO, 응답 형태)
2. AGENTS.md 문서 확인 (루트 및 해당 모듈)
3. 변경 범위가 큰 경우 초안 공유 후 진행
4. 코드 생성 파일은 `build_runner`로 갱신
5. 품질 게이트 통과 확인
6. 관련 문서 업데이트