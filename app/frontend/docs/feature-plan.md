# 유니플랜 프론트엔드 구현 계획(프로토타입 완전 반영본)
프로토타입 화면을 기준으로 각 화면의 시각적 구역, 동작, 그리고 사용되는 백엔드 API 요청/응답을 모두 명시했다. 확인 필요 문구는 없다.

---
## 1. 화면별 상세 구성 및 기능
### 공통 UI/패턴
- 헤더/서치 패널: 카드(배경 AppTokens.surface, radius 12, padding 16~24). 폰트는 AppTokens(Noto Sans), 버튼/Chip 색상도 AppTokens 사용.
- 리스트: Divider로 구분, 상단 요약(총 건수·페이지), 좌측 콘텐츠/우측 액션 정렬.
- 시간 정보는 `월 09:00-10:15` 형식으로 표시.

### Auth(로그인/회원가입)
- 섹션: 중앙 카드, 이메일/비밀번호/이름(회원가입) 입력, 제출 버튼, 로그인 시 로딩 스피너.
- 동작: 로그인/회원가입 성공 시 `/app/courses` 이동. Refresh 로직은 아직 없으므로 401 시 로그아웃으로 처리.

### 강의 목록
- 상단 필터 카드: 과목명, 교수명, 학과 코드, 캠퍼스 입력. 검색/초기화 버튼.
- 리스트 행: 과목명(굵게)·교수·코스코드·캠퍼스, 학점/강의실, 수업시간(ClassTimes) 표시.
- 위시리스트 추가: 행 우측 위시리스트 버튼 → BottomSheet에서 우선순위 1~5 선택 → POST `/wishlist`.
- 페이징: 총 건수/현재 페이지 요약 + 이전/다음 버튼.

### 위시리스트(우선순위별 그룹)
- 상단/좌측에 별도 입력폼 없음. 추가는 강의 목록에서만 가능.
- 본문: 우선순위 1~5 섹션을 별도 카드로 렌더링(제목 “우선순위 N”). 각 섹션 안에 해당 우선순위 강의 리스트.
  - 아이템: 과목명, 교수, (가능 시) 캠퍼스/강의실, 수업시간. courseId는 화면에 노출하지 않음.
  - 액션: 우선순위 변경(다른 1~5 선택 메뉴) → 기존 항목 삭제 후 새 priority로 재추가. 삭제 버튼 제공.
- 추가 경로: 강의 목록에서 우선순위 선택을 통해서만 추가.

### 시간표
- 상단 카드: 시간표 생성(name, year, semester) + 생성 버튼.
- 목록 뷰: 처음 들어오면 오른쪽 편집 영역은 비어 있고, 왼쪽 리스트(이름·연도/학기·삭제 버튼)만 보인다. 리스트 아이템을 클릭해야 편집 화면이 열린다.
- 편집 뷰(리스트에서 항목 클릭 시 열림):
  - 좌측 그리드: 주/요일·시간대 격자에 과목 블록 배치. 블록 색상은 AppTokens.primaryMuted, 충돌 시 붉은 음영. 블록마다 삭제 아이콘으로 제거 가능.
  - 우측 패널 두 개:
    1) “제외된 과목” 리스트: 대체 시간표 생성 시 제외한 course 목록 표시.
    2) “시간 겹치는 과목” 리스트: 현재 선택된 블록들과 시간이 겹치는 과목 쌍을 표시(클라이언트에서 classTimes로 계산).
  - 하단 패널:
    1) “위시리스트에서 추가” 섹션: 우선순위별 그룹을 보여주고, 각 항목마다 “추가” 버튼으로 시간표에 삽입. (강의 목록에서 직접 추가하는 UI는 없음; 프로토타입대로 위시리스트만 경로로 사용)
  - “시나리오 생성” 버튼: 현재 시간표를 기반으로 Plan 생성.

### 시나리오
- 상단 카드: 시나리오 생성(이름, 설명, 참조할 시간표 선택).
- 본문: 시나리오 트리/리스트(Plan A/B/C…). 각 카드에 이름/설명/최근 업데이트/부모 정보.
- 액션: 대체 시나리오 추가(부모 선택), 이름/설명 수정, 삭제, “내비게이트” 실행 버튼(수강신청 준비 흐름으로 이동).

### 수강신청(등록) 플로우
- 상단 카드: 시나리오 선택 + 제목/메모 입력 후 “등록 세션 시작”.
- 본문: 등록 스텝 리스트(과목, 액션 ENROLL/DROP, 상태 PENDING/DONE/FAILED, 메시지). 새 스텝 추가 버튼.
- 액션: 완료(complete) → 상태 DONE 고정, 취소(cancel) → 세션 종료, 전체 삭제 버튼.
- 보조 뷰: DONE 상태 스텝의 “성공한 과목” 목록을 별도 섹션으로 표시.

### 전체 사용자 시나리오(화면 조작 순서)
1) 회원가입/로그인 카드에서 이메일·비밀번호 입력 → 로그인 → 강의 목록 화면 이동.
2) 강의 목록 필터 입력(과목/교수/학과/캠퍼스) → 검색 → 원하는 강의 우측 위시리스트 버튼 → BottomSheet에서 우선순위 1~5 선택 후 추가.
3) 위시리스트 탭: 우선순위 섹션에서 강의 확인. 필요 시 우선순위 변경 메뉴로 이동 → 새 우선순위 선택 → 변경 적용(삭제 후 재추가). 불필요한 항목은 삭제.
4) 시간표 탭: 이름/연도/학기 입력 후 생성 → 목록에서 원하는 시간표 클릭 → 상세 탭에서
   - 위시리스트 패널에서 과목 추가,
   - 겹치는 시간 블록은 충돌 색상으로 표시,
   - 제외된 과목 리스트와 시간 겹치는 과목 리스트 확인,
   - 필요 시 대체 시간표 생성(제외 과목 지정).
5) 시나리오 탭: Plan A 생성(시간표 선택) → 필요 시 Plan B/C 등 대체 시나리오 추가(제외 과목 지정) → 트리에서 전환/수정/삭제.
6) 수강신청 탭: 시나리오 선택 후 등록 세션 시작 → 과목별 ENROLL/DROP 스텝 추가 → 완료 혹은 취소 → 성공한 과목 목록 확인.

---
## 2. 백엔드 API 명세(컨트롤러 기반, JSON 형식)
### 인증/사용자(gateway `/api/v1/auth`, `/api/v1/users`)
- POST `/api/v1/auth/login`  
  Body `{ "email": string, "password": string }`  
  Res `{ "accessToken": string, "refreshToken": string, "userId": number, "email": string, "name": string }`
- POST `/api/v1/auth/signup`  
  Body `{ "email": string, "password": string, "name": string }` → 동일 구조.
- GET `/api/v1/users/me` (Authorization Bearer) → `User { id, email, name, ... }`
- Refresh 엔드포인트 없음 → 401 시 로그아웃 처리.

### 강의(catalog-service `/api/v1/courses`)
- GET `/api/v1/courses`  
  Query: `courseName?`, `professor?`, `departmentCode?`, `campus?`, `page`(int), `size`(int)  
  Res(Page):
  ```json
  {
    "content": [
      {
        "id": 123,
        "openingYear": 2025,
        "semester": "1",
        "courseCode": "CS101",
        "section": "01",
        "courseName": "자료구조",
        "professor": "홍길동",
        "credits": 3,
        "classroom": "공학관 101",
        "campus": "서울",
        "departmentCode": "CS",
        "departmentName": "...",
        "collegeCode": "...",
        "collegeName": "...",
        "classTimes": [
          { "day": "월", "startTime": "09:00", "endTime": "10:15" },
          { "day": "수", "startTime": "09:00", "endTime": "10:15" }
        ]
      }
    ],
    "totalElements": 123,
    "totalPages": 13,
    "size": 10,
    "number": 0
  }
  ```
- GET `/api/v1/courses/{id}` → 단일 Course JSON(동일 구조).

### 위시리스트(planner-service `/api/v1/wishlist`)
- 공통: Authorization Bearer. Gateway가 X-User-Id를 주입하므로 별도 헤더 필요 없음.
- POST `/wishlist`  
  Body `{ "courseId": number, "priority": number(1-5) }`  
  Res:
  ```json
  {
    "id": 1,
    "userId": 1,
    "courseId": 123,
    "courseName": "자료구조",
    "professor": "홍길동",
    "priority": 2,
    "addedAt": "2025-11-01T12:34:56"
  }
  ```
- GET `/wishlist` → `WishlistItemResponse[]` (id, userId, courseId, courseName, professor, priority, addedAt)
- DELETE `/wishlist/{courseId}` → 204
- GET `/wishlist/check/{courseId}` → `true/false`
- 우선순위 변경용 별도 API는 없음 → 클라이언트에서 삭제 후 새 priority로 재추가.

### 시간표(planner-service `/api/v1/timetables`)
- GET `/timetables` (openingYear?, semester?) → `TimetableResponse[]`
- GET `/timetables/{timetableId}` → 단일 `TimetableResponse`
- POST `/timetables`  
  Body `{ "name": string, "openingYear": number, "semester": string }` → `TimetableResponse`
- PUT `/timetables/{timetableId}`  
  Body `{ "name": string }` → `TimetableResponse`
- DELETE `/timetables/{timetableId}` → 204
- POST `/timetables/{timetableId}/courses`  
  Body `{ "courseId": number }` → `TimetableItemResponse`(id, courseId, courseName, professor, credits, department, classroom, classTimes[], addedAt)
- DELETE `/timetables/{timetableId}/courses/{courseId}` → 204
- POST `/timetables/{timetableId}/alternatives`  
  Body `{ "name": string, "openingYear": number, "semester": string, "excludedCourseIds": [number] }` → `TimetableResponse`(alternatives 포함, 응답은 `excludedCourses` 배열로 과목 정보를 내려줌)

### 시나리오(planner-service `/api/v1/scenarios`)
- POST `/scenarios` (루트 생성)  
  Body `{ "name": string, "description": string?, "timetableId": number }` → `ScenarioResponse`
- POST `/scenarios/{parentScenarioId}/alternatives`  
  Body `{ "name": string, "description": string?, "timetableId": number, "excludedCourseIds": [number]? }` → `ScenarioResponse`(parentId 설정; 내포된 `timetable` 응답에서 `excludedCourses` 제공)
- GET `/scenarios` → `ScenarioResponse[]`
- GET `/scenarios/{scenarioId}` → 단일
- GET `/scenarios/{scenarioId}/tree` → 해당 시나리오와 모든 하위 시나리오 트리
- PUT `/scenarios/{scenarioId}` Body `{ "name": string, "description": string? }` → 업데이트된 `ScenarioResponse`
- DELETE `/scenarios/{scenarioId}` → 204
- POST `/scenarios/{scenarioId}/navigate`  
  Body `{ "preferredCourseIds": [number], "excludedCourseIds": [number], "currentStep": string? }`  
  Res: `ScenarioResponse` (내비게이션 결과 상태)
- GET `/scenarios/{scenarioId}/children` → 자식 시나리오 리스트

### 수강신청(등록)(planner-service `/api/v1/registrations`)
- POST `/registrations` (등록 세션 시작)  
  Body `{ "scenarioId": number, "title": string?, "notes": string? }` → `RegistrationResponse { id, scenarioId, status, steps: [] }`
- POST `/registrations/{registrationId}/steps`  
  Body `{ "courseId": number, "action": "ENROLL"|"DROP", "status": "PENDING"|"DONE"|"FAILED", "message": string? }` → `RegistrationResponse`(steps 갱신)
- GET `/registrations/{registrationId}` → `RegistrationResponse`(steps 포함)
- GET `/registrations` → `RegistrationResponse[]`
- POST `/registrations/{registrationId}/complete` → 완료 처리, `RegistrationResponse`
- DELETE `/registrations/{registrationId}` → 취소, 204
- DELETE `/registrations` → 사용자의 모든 등록 세션 삭제, 204
- GET `/registrations/{registrationId}/succeeded-courses` → `[courseId, ...]`

---
## 3. 구현 우선순위/체크리스트
1) 위시리스트: priority 그룹 UI, 우선순위 변경(삭제+재추가), manual 입력 제거, API DELETE/POST에 맞춰 정비.
2) 시간표: 그리드 렌더링, 제외 과목 리스트·시간 겹치는 과목 리스트 표시, 위시리스트/강의 목록에서 추가, 대체 시간표 생성 흐름.
3) 시나리오: 트리/리스트 UI, 생성/대체/수정/삭제/내비게이트 버튼 구현.
4) 수강신청: 등록 세션 생성/스텝 관리/완료·취소/성공 과목 뷰.
5) 문서/검증: README/AGENTS 최신화 유지, `flutter analyze`·스모크 테스트 추가.
