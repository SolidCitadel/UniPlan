# UniPlan Frontend Rebuild Plan (Flutter Web)

TS/Vite 프로토타입과 동일한 디자인/플로우를 Flutter Web으로 재구성하기 위한 설계·체크리스트입니다. 완료 후 주요 내용은 `README.md`/`AGENT.md`로 통합합니다.

## 1. 목표/범위
- 프로토타입 UI/UX 패리티 확보(웹 타겟): 색/타이포/레이아웃/컴포넌트/마이크로인터랙션.
- 안정적 인증 흐름: 웹 호환 토큰 스토리지 + refresh 토큰 + 라우팅 가드.
- 백엔드 계약 준수: 컨트롤러/DTO 확인 후 파라미터·응답 매핑, 페이지네이션 포함.
- 상태/품질: 명시적 로딩·에러·빈 상태, 기본 테스트(뷰모델/유틸)와 회귀 체크리스트.

## 2. 아키텍처
- Entry: `main.dart` — ProviderScope, Env/Config 로딩, 테마·라우터 주입.
- Router: GoRouter with Shell
  - `/login`, `/signup`, 보호된 `/app/*` (courses, wishlist, planner, scenario, registration, help).
  - Redirect rule: 미인증 → `/login`, 인증 시 `/login|/signup` 접근 → `/app/courses`.
  - Shell는 헤더/네비/레이아웃 제공, 반응형으로 rail ↔ drawer 전환.
- State: Riverpod AsyncValue + `ref.listen` with `listenWhen` 패턴; ViewModel은 “마지막 데이터 유지 + 로딩 플래그 분리” 접근.
- Data: Repository 인터페이스(도메인) ↔ Impl(Dio + DTO/Mapper). Page<T> 모델 도입. 에러는 도메인 오류 타입으로 변환.
- Theme/Design System: 프로토타입 토큰 기반 (color, typography, spacing, radius, elevation, animation). 공용 위젯 라이브러리 구축.
- Storage: TokenStorage(web-safe) + UserPreferences(shared_preferences). 플랫폼 분기 또는 웹용 구현 우선.
- Network: Dio 싱글턴 Provider + 인터셉터(Authorization, 로그, 401→refresh→retry once→fail & logout).
- Config: Env/flavor (dev/prod) → baseUrl, feature flags. 웹은 `--dart-define` 또는 `assets/config`.

## 3. 디자인 시스템 (초안)
- 색: 프로토타입 추출 후 `theme/colors.dart`에 정의 (primary, surface, text, accent, state).
- 타이포: 프로토타입 폰트 패밀리/스케일 반영(`theme/typography.dart`), heading/body/caption 세트.
- 공간/라운딩: spacing scale (4/8/12/16/24/32), radius scale (4/8/12/16).
- 컴포넌트:
  - 버튼: primary/secondary/ghost, icon-button, loading state 내장.
  - Input: TextField with label/helper/error, leading icon, clear/visibility toggle.
  - Chips/Filters: selectable/segmented, compact density.
  - Card/List: course card, timetable block, scenario step card.
  - Status: loading(스크리머/스피너), error(with retry), empty state(아이콘+가이드).
  - Layout: Page shell, section header, responsive grid, sticky filters.
- Motion: 진입 페이드/슬라이드, 버튼/필터 hover/pressed, timetable highlight transition.

## 4. 기능/화면 스펙
- Auth (로그인/회원가입): ID/PW, Google 자리표시(후순위), 유효성/에러 메시지, 성공 시 토큰 저장→세션 설정→리디렉션.
- Course List/Search:
  - 필터: query(과목명/교수), departmentCode, campus, page/size. Backend Page 응답 반영(totalElements/totalPages).
  - UI: 검색바+필터칩, 결과 리스트(카드/표 결정), 정렬(필요 시).
  - Empty/Loading/Error 명시.
- Wishlist:
  - 목록/추가/삭제/우선순위 변경 (백엔드 스펙 확인 필요, 현재 미구현 → 임시 로컬 상태?).
  - 낙관적 업데이트 여부 결정.
- Timetable/Scenario:
  - 리스트/생성/삭제, 코스 추가/제거, 충돌 표시, 시나리오 A/B/C 전환 UI.
  - 시간표 렌더러: 요일×시간 그리드, 하이라이트/충돌색.
- Course Registration Assist:
  - 단계 안내, 현재 시나리오/코스 강조, 실패/성공 피드백.
- Help:
  - 온보딩/FAQ/핵심 단축키(프로토타입 기준).

## 5. 네트워크/스토리지 설계
- Base URL: `ApiConfig` (dev/prod), `--dart-define BASE_URL=...`.
- TokenStorage: 웹은 `shared_preferences` 또는 JS localStorage 사용. 인터페이스 + 구현 분리.
- Interceptor:
  - Request: Authorization Bearer 주입(존재 시).
  - Error 401: refresh 토큰 존재 시 refresh → 원 요청 1회 재시도 → 실패 시 로그아웃.
  - 로깅: dev 환경만.
- API 계약:
  - Auth: `/api/v1/auth/login|signup` → access/refresh. `/api/v1/users/me`.
  - Courses: `/api/v1/courses` Page 응답 {content, totalElements, totalPages, ...}.
  - Timetables: CRUD + course add/remove.
  - Wishlist: 백엔드 스펙 확인 필요(임시 Stub 제거 계획).

## 6. 라우팅/플로우
- 공개: `/login`, `/signup`
- 보호: `/app/courses`, `/app/wishlist`, `/app/planner`, `/app/scenario`, `/app/course-registration`, `/app/help`
- Redirect: 미인증 → `/login`; 인증 상태에서 `/login|/signup` 접근 → `/app/courses`.
- 세션 복원: 앱 부팅 시 토큰 검사 → me 호출 성공 시 세션 세팅, 실패 시 로그아웃.

## 7. 데이터 모델/DTO
- Domain: `User`, `Course`, `ClassTime`, `Timetable`, `WishlistItem`, `Page<T>`.
- DTO: API 응답/요청 전용 클래스(필드명 백엔드와 일치), Mapper로 Domain 변환.
- Pagination: page/size, totalElements/totalPages 유지.

## 8. 품질/테스트
- lint/analyze 0 경고 유지.
- Tests:
  - ViewModel: auth, course list(pagination/filter), timetable ops.
  - Utils: time slot utils.
  - Golden(선택): 주요 화면 1~2개.
- 회귀 플로우 체크: 로그인 → 과목 검색 → 위시리스트 추가 → 시간표 배치 → 시나리오 전환 → 로그아웃.

## 9. 구현 단계(TODO)
- [ ] 베이스 세팅: flutter stable, pub get, build_runner clean build, analyze
- [ ] Config/Env: ApiConfig + dart-define, Dio provider 재구성
- [ ] TokenStorage 웹 호환 구현 + refresh 플로우
- [ ] Router/Guard 재구성: `/login|/signup` + `/app/*` Shell, 리디렉션
- [ ] Theme/Design tokens: 프로토타입 추출 → colors/typography/spacing/components
- [ ] 공용 컴포넌트: 버튼/입력/칩/카드/상태 뷰/레이아웃
- [ ] Auth 화면 리빌드 + 세션 복원
- [ ] Course List 화면: 필터/검색/페이지네이션 + Page<T> 처리
- [ ] Wishlist: 백엔드 스펙 확인 후 구현(or 임시 로컬 상태)
- [ ] Timetable/Scenario: UI/상태/충돌 표시 + API 연동
- [ ] Registration Assist + Help 화면
- [ ] 테스트: 뷰모델/유틸/골든(필요 시)
- [ ] README/AGENT 반영 후 docs 통합/정리
- [x] API 계약 프로브 스크립트 (scripts/api_smoke) 작성: 실제 백엔드 호출로 요청/응답 필드 검증
- [ ] Refresh 정책: 현재 백엔드에 refresh 엔드포인트 없음 → 401 시 즉시 로그아웃. 추후 백엔드가 제공하면 Dio 인터셉터에 재시도 로직 추가 예정.
