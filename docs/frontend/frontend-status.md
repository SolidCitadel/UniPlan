# Frontend 최신 현황 정리 (Flutter Web)

## 개요
- 프로토타입(루트 `Uniplanprototype`)의 화면/플로우를 Flutter Web로 재구현 완료.
- 주요 플로우: 로그인 → 강의 검색/위시리스트 → 시간표 목록·편집 → 시나리오 트리 → 수강신청(등록) 목록·상세.
- 상태 관리: Riverpod 3 `AsyncNotifier` 기반, AutoDispose 계열 미사용.
- 저장 UX: 과목 상태 변경 후 명시적 “저장/생성” 버튼을 눌러야 서버 호출이 이루어지도록 유지.

## 라우트/화면
- `/` 로그인: 이메일+비밀번호 입력 → `/app/courses` 이동. Refresh 로직 없음(401 시 로그인으로 리다이렉트).
- `/app/courses` 강의 목록: 검색/필터, 교수·과목명·시간대 노출. 위시리스트 추가 버튼 → 우선순위 1~5 BottomSheet → POST `/wishlist`.
- `/app/wishlist` 위시리스트: 우선순위별 카드(과목명, 교수, 시간). 우선순위 변경/삭제 지원.
- `/app/timetables` 시간표 목록: 카드 리스트 + “생성” 버튼(이름 입력 모달). 카드 선택 시 편집.
- `/app/timetables/:id` 시간표 편집:
  - 레이아웃: 상단 헤더(뒤로가기, 시간표명, 대안 생성 버튼), 좌측 탭(추가 가능/시간 겹침/제외됨) + 같은 영역에 해당 목록, 우측 주간 그리드(09~21시).
  - 기능: 좌측 목록 호버 시 그리드에 반투명 미리보기. 추가/제외 반영. 겹치는 과목은 “시간 겹침” 탭으로 이동. 제외 목록도 동일 포맷으로 표시.
  - 주간 그리드: 과목 블록에 교수명·장소만 표시(시간 텍스트 제거). 09시 시작, 클래스 시간에 맞춰 행렬 위치 결정.
  - 대안 시간표 생성: 기준 시간표에서 일부 과목을 토글해 제외하고 새로운 시간표를 생성, 생성 직후 해당 시간표 편집 화면으로 전환.
- `/app/scenarios` 시나리오 목록: 시간표 기반 생성/수정/삭제.
- `/app/scenarios/:id` 시나리오 상세:
  - 트리 뷰로 시나리오 전개. 노드 라벨은 “시나리오명: 실패 과목들 → 대안” 형태, 실패 과목/화살표를 빨간색으로 강조.
  - 기준 시간표는 생성 시 지정한 값으로 유지. 자식 시나리오 생성은 좌측 영역에서 기준 시간표를 선택 → 제외할 과목 토글 → 호환 시간표 제안 목록에서 선택 → 화살표로 연결.
- `/app/registrations` 수강신청(등록) 목록:
  - 세션 리스트(상태 표시). “새로 시작” 버튼 → 시나리오 선택 + 세션 이름 입력 → 생성 후 상세로 이동.
  - 취소와 삭제 분리(`/registrations/{id}/cancel`, DELETE `/registrations/{id}`).
- `/app/registrations/:id` 수강신청 상세:
  - 좌측 상태 리스트(성공/대기/실패). 성공·실패는 시작+현재 시나리오 전체에서 과목 정보를 매핑, 대기는 현재 시나리오 과목만 대상.
  - “다음 단계 저장” 버튼을 눌러야 `addStep` 호출. 버튼을 누르기 전까지는 로컬 상태만 변경됨.
  - 취소된 과목: 서버의 `canceledCourses` + 성공 목록 중 현재 시간표에 없는 과목을 자동으로 취소로 간주해 빨간색으로 강조.
  - 우측 주간 그리드: 성공=초록, 대기=연한 회색, 실패=빨강, 취소/제외=연한 빨강. 실패/대기는 반투명 처리. 실패 과목도 그리드에 표시.
  - 완료/취소/삭제 버튼은 AppBar 액션에 위치.

## 상태/로직 메모
- Registration 응답의 `succeeded/failed/canceledCourses`는 백엔드에서 모든 step을 누적(distinct)한 집합을 내려줌. 프론트는 이 집합을 그대로 사용해 좌측 리스트/그리드를 그림.
- 대기 목록은 현재 시나리오의 과목만 포함하도록 필터링. 성공/실패는 시작+현재 시나리오 전체를 매핑해 누락된 과목도 표시(없으면 “알 수 없는 과목(id)”로 보강).
- “다음 단계 저장”은 `_succeeded/_failed/_canceled` 로컬 집합을 그대로 `addStep`에 전달해 새 step을 추가/덮어씀.
- 시간표 편집의 좌측 탭(추가 가능/시간 겹침/제외됨)은 단일 선택 토글로 목록과 통합해 상단에 상태 선택, 아래에 해당 목록을 표시. 탭 상태가 바뀌어도 주간 그리드는 위로 붙은 상태 유지.
- 호버 미리보기는 “추가 가능” 목록에서만 반투명 블록으로 표시, 실제 추가/제외 시 반영됨.

## API 요약 (gateway 기준 `/api/v1`)
- Auth: `POST /auth/login`, `POST /auth/signup`, `GET /users/me`
- 강의: `GET /courses`(courseName/professor/departmentCode/campus/page/size)
- 위시리스트: `GET /wishlist`, `POST /wishlist`(courseId, priority), `PATCH /wishlist/{id}`(priority), `DELETE /wishlist/{id}`
- 시간표: `GET/POST /timetables`, `GET/PATCH/DELETE /timetables/{id}`, 대안 생성 `POST /timetables/{id}/alternatives`
- 시나리오: `GET/POST /scenarios`, `GET/PATCH/DELETE /scenarios/{id}`, 대안 연결 `POST /scenarios/{parentId}/alternatives`
- 수강신청(등록):
  - `GET /registrations`(목록), `POST /registrations`(시나리오 선택, 이름)
  - `GET /registrations/{id}`
  - `POST /registrations/{id}/steps` (succeededCourses, failedCourses, canceledCourses)
  - `POST /registrations/{id}/complete`
  - `POST /registrations/{id}/cancel`
  - `DELETE /registrations/{id}`

## 앞으로 확인/유지 사항
- `flutter analyze`가 환경에 따라 오래 걸릴 수 있음. 변경 파일 단위라도 분석 수행.
- 백엔드 스펙 변경 시 DTO/mapper/datasource/문서 동기화 필수.
- UI 차이: 프로토타입 대비 누락/변경 사항이 생기면 본 문서에 우선 기록 후 개발에 반영.
