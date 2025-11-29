# AGENT Guide (UniPlan)

프로젝트 전반을 작업할 때 따라야 할 기본 원칙과 빠른 참조용 명령어입니다.

## 공통 원칙
- 백엔드 먼저 확인: 컨트롤러·DTO 필드·응답 형태를 확인한 뒤 프런트/CLI를 맞춥니다.
- 타임테이블/시나리오 계약: planner-service는 제외 과목을 요청 시 `excludedCourseIds`로 받고, 응답은 `excludedCourses`(courseId 포함 객체 배열)로 내려줍니다. 클라이언트 계약을 이 형태에 맞춥니다.
- 안전한 변경: 새 기능은 작은 단위로 PR, 영향 범위가 넓은 변경은 초안 공유 후 진행.
- 품질 게이트: `test`/`analyze` 통과, 코드 생성 파일은 `build_runner`로 갱신 후 커밋.
- 보안: 비밀값(.env, DB 비번, JWT 시크릿) 커밋 금지. 로컬 설정은 예시 파일만 제공합니다.
- 문서 우선: 변경 시 관련 README/AGENT를 함께 갱신합니다.

## API Gateway 규칙
### 경로 규칙
- **외부 요청**: 모든 클라이언트 요청은 `/api/v1/*` 형식으로 시작
- **URL Rewrite**: Gateway가 `/api/v1/segment` → `/segment`로 변환하여 내부 서비스로 전달
- **예시**: 클라이언트가 `/api/v1/timetables/123` 요청 → planner-service는 `/timetables/123`로 수신

### JWT 인증 패턴
- **요청 헤더**: `Authorization: Bearer {token}`
- **인증 흐름**:
  1. Gateway가 JWT 토큰 검증
  2. 성공 시 `X-User-Id`, `X-User-Email`, `X-User-Role` 헤더 추가
  3. 다운스트림 서비스로 전달 (각 서비스는 헤더에서 사용자 정보 추출)
- **인증 불필요 경로**: `/api/v1/auth/**` (로그인/회원가입)
- **인증 필수 경로**: `/api/v1/users/**`, `/api/v1/planner/**`, `/api/v1/timetables/**`, `/api/v1/scenarios/**`, `/api/v1/wishlist/**`, `/api/v1/registrations/**`, `/api/v1/courses/**`, `/api/v1/catalog/**`

### 서비스별 라우팅
- **user-service**: `/api/v1/auth/**`, `/api/v1/users/**`
- **planner-service**: `/api/v1/planner/**`, `/api/v1/timetables/**`, `/api/v1/scenarios/**`, `/api/v1/wishlist/**`, `/api/v1/registrations/**`
- **catalog-service**: `/api/v1/courses/**`, `/api/v1/catalog/**`

## 주요 경로
- 루트 개요: `README.md`
- 백엔드: `app/backend`
- CLI 클라이언트: `app/cli-client`
- 프런트엔드(Flutter web): `app/frontend`
- TS 프로토타입: `Uniplanprototype`

## 자주 쓰는 명령
- 루트 포맷: `git status`, `git diff`
- 백엔드 빌드/테스트: `cd app/backend && ./gradlew clean build`
- CLI 실행: `cd app/cli-client && dart run bin/cli_client.dart ...`
- 프런트엔드 준비: `cd app/frontend && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs`
- 프런트엔드 실행(웹): `cd app/frontend && flutter run -d chrome`
- 프런트엔드 분석/테스트: `cd app/frontend && flutter analyze && flutter test`

## 브랜치/PR 체크리스트
1) 변경 요약, 동기, 테스트 결과를 PR 본문에 기재  
2) 관련 문서/예시 설정 파일 동반 업데이트  
3) 생성물(`*.g.dart`, `*.freezed.dart`)은 `build_runner`로 갱신  
4) 대규모 UI 변경 시 스크린샷/캡처 첨부  
5) 백엔드 연동 변경 시 API 계약 확인 근거(컨트롤러/DTO 경로) 명시
