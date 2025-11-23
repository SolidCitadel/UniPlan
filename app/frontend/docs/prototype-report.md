# 프로토타입 정밀 분석 보고서 (프론트엔드 구현 기준)
프로토타입 화면/행동을 클릭 단위까지 풀어쓴다. 구현 시 본 문서를 절대 기준으로 동일하게 재현한다. 모든 카드 배경은 AppTokens.surface, radius 12, padding 16~24, 본문 폭 1200~1440px 중앙 정렬, 상단 네비 높이 64px(좌 로고, 우 탭: 강의/위시리스트/시간표/시나리오/수강신청/프로필·로그아웃). 여백: 좌우 24~32px, 섹션 간 16~24px. 글꼴은 AppTokens.heading/body/caption.

---
## 1. 전체 사용자 여정 + 클릭 시퀀스
1) 로그인 화면
- 이메일/비밀번호 입력 필드 클릭 → 키입력.
- `로그인` 버튼 클릭 → POST /auth/login → 성공 시 강의 목록 화면으로 이동, 실패 시 에러 토스트.
- `회원가입` 링크 클릭 → 회원가입 카드로 전환.
- 회원가입 카드에서 이름/이메일/비밀번호 입력 후 `회원가입` 버튼 클릭 → POST /auth/signup → 성공 시 로그인 화면(또는 자동 로그인) → 강의 목록 이동.

2) 강의 목록 화면
- 필터(과목명/교수/학과코드/캠퍼스) 입력 클릭 → 키입력.
- `검색` 버튼 클릭 → GET /courses → 리스트 갱신.
- `초기화` 버튼 클릭 → 필터 비움 → 리스트 재조회.
- 리스트 행의 `위시리스트 추가` 아이콘 클릭 → BottomSheet(우선순위 1~5 ChoiceChip) 표시 → Chip 클릭 순간 POST /wishlist → Snackbar 성공.
- 페이징 `이전`/`다음` 아이콘 클릭 → page-1/page+1로 이동(경계면 disabled) → 재조회.

3) 위시리스트 화면
- 우선순위 카드 헤더는 표시만(클릭 없음).
- 리스트 아이템의 `우선순위 변경` PopupMenu 클릭 → 1~5 중 선택 → DELETE /wishlist/{courseId} → POST /wishlist 새 priority → 리스트 갱신.
- `삭제`(휴지통) 아이콘 클릭 → DELETE /wishlist/{courseId} → 리스트 갱신.
- 추가 경로 없음: courseId 수동 입력 UI 금지, 강의 목록 BottomSheet만 사용.

4) 시간표 화면
- 상단 생성 카드: 이름/연도/학기 입력 후 `생성` 클릭 → POST /timetables → 좌측 리스트에 추가.
- 초기 진입: 우측 편집 영역은 선택 안내 텍스트만, 클릭해도 동작 없음.
- 좌측 리스트 아이템 클릭 → 해당 시간표 선택 → 우측 편집 뷰가 열림.
- 리스트 아이템 `삭제` 아이콘 클릭 → DELETE /timetables/{id} → 리스트 갱신, 선택 해제.
- 편집 뷰: 주간 그리드 블록의 `삭제` 아이콘 클릭 → DELETE /timetables/{id}/courses/{courseId} → 블록 제거. “제외된 과목”/“시간 겹치는 과목” 패널은 텍스트 표시만(클릭 없음). “위시리스트에서 추가” 패널의 각 행 `추가` 아이콘 클릭 → POST /timetables/{id}/courses. “시나리오 생성” 버튼(옵션) 클릭 → 시나리오 생성 화면/모달로 이동해 POST /scenarios 트리거.

5) 시나리오 화면
- 상단 카드: 이름/설명 입력, 시간표 Dropdown 클릭 후 선택 → `시나리오 생성` 클릭 → POST /scenarios → 리스트/트리 갱신.
- 리스트/트리 카드 클릭 → 포커스/하이라이트(뷰 상태만 변경).
- 카드 우측 `대체 시나리오 추가` 클릭 → 모달 열림 → 이름/설명/시간표/제외 과목 입력 → POST /scenarios/{parent}/alternatives.
- `수정` 클릭 → 모달 → 이름/설명 변경 → PUT /scenarios/{id}.
- `삭제` 클릭 → DELETE /scenarios/{id}.
- `내비게이트` 클릭 → POST /scenarios/{id}/navigate → 결과 반영.

6) 수강신청(등록) 화면
- 상단 카드: 시나리오 Dropdown 클릭 후 선택, 제목/메모 입력 → `등록 세션 시작` 클릭 → POST /registrations.
- 본문 스텝 리스트 상단 `스텝 추가` 클릭 → 모달(과목/액션/상태/메시지) → POST /registrations/{id}/steps.
- 각 스텝 행의 삭제 아이콘 클릭 → DELETE(또는 PATCH) → 리스트 갱신. 상태 Chip은 표시 전용(클릭 없음).
- 하단 버튼: `완료` 클릭 → POST /registrations/{id}/complete. `취소` 클릭 → DELETE /registrations/{id}. `전체 삭제` 클릭 → DELETE /registrations.
- “성공한 과목” 섹션은 조회만(GET /registrations/{id}/succeeded-courses), 클릭 없음.

---
## 2. 화면별 상세 UI/컴포넌트/레이아웃/클릭 액션
### 공통 규칙
- 네비: 좌 로고 클릭 시 강의 목록으로 이동. 우 탭 클릭 시 해당 화면 라우팅. 프로필/로그아웃 드롭다운 → `로그아웃` 클릭 시 세션 삭제 후 로그인 화면 이동.
- 카드: AppTokens.surface, radius 12, padding 16~24, 그림자 elevation 4. 텍스트는 heading/body/caption. 시간 포맷 `월 09:00-10:15`.
- 스크롤: 페이지 전체 스크롤 우선, 카드 내부는 리스트가 길 때만 내부 스크롤.

### 로그인/회원가입
- 레이아웃: 중앙 카드 폭 420px. 상단 로고 → 입력 필드(로그인은 2개, 가입은 3개, 높이 48px, 간격 12px) → 주요 버튼 48px → 하단 전환 링크.
- 클릭 액션: 입력 포커스/입력, 주요 버튼 클릭(로그인/회원가입), 전환 링크 클릭.

### 강의 목록
- 필터 카드: 3행 레이아웃
  - 1행: 과목명 TextField(50%), 교수명 TextField(50%).
  - 2행: 학과코드 TextField(50%), 캠퍼스 TextField(50%).
  - 3행: 좌 `검색` 버튼(48px), 우 `초기화` 텍스트 버튼.
- 리스트 카드:
  - 헤더: 총 건수/페이지 표시. 클릭 없음.
  - 본문 행(높이 80~96px): 좌 과목명(16px bold), 하위 교수·코드·캠퍼스(12~14px), 중간 시간 캡션, 우 학점/강의실. 우측 끝 `위시리스트 추가` 아이콘 버튼 클릭 → BottomSheet 우선순위 선택(ChoiceChip) → Chip 클릭 시 POST /wishlist.
  - 하단 페이징: `이전`/`다음` 아이콘 버튼 클릭 → 페이지 이동.

### 위시리스트
- 우선순위 섹션(세로 스택, 각 카드 margin-bottom 16px): 헤더 배지 “우선순위 N”(primaryMuted 배경), 클릭 없음.
- 아이템(높이 72px): 좌 과목명 bold, 교수/시간 캡션. 우 PopupMenu `P{n}` 클릭 → 1~5 중 선택 시 우선순위 변경(DELETE+POST). 휴지통 아이콘 클릭 → 삭제.

### 시간표
- 상단 생성 카드: 이름(1.5비율)/연도(0.8)/학기(0.7)/`생성` 버튼(0.5) 한 줄 배치. 버튼 클릭 → POST /timetables.
- 본문 2열: 좌 리스트(폭 280px), 우 편집. 간격 24px.
  - 리스트 행(68px): 이름/연도·학기 텍스트, 클릭 시 편집 뷰 열림. 삭제 아이콘 클릭 → DELETE /timetables/{id}.
  - 편집 뷰(선택된 경우만):
    - 타이틀행: 시간표명 + 과목 개수. 클릭 없음.
    - 주간 그리드 카드(높이 420px): 요일 5컬럼. 강의 블록에 과목/시간 표시, 겹침 시 붉은 음영. 블록의 삭제 아이콘 클릭 → DELETE /timetables/{id}/courses/{courseId}.
    - 우측 패널 2개: “제외된 과목” 리스트, “시간 겹치는 과목” 리스트(텍스트만, 클릭 없음).
    - 하단 추가 패널: “위시리스트에서 추가” 카드 → 우선순위별 리스트 각 행 `추가` 아이콘 클릭 → POST /timetables/{id}/courses.
    - (옵션) “시나리오 생성” 버튼: 클릭 시 시나리오 생성 흐름 진입.
  - 선택 없을 때: 중앙 안내 텍스트 “시간표를 선택하면 편집 화면이 열립니다.”

### 시나리오
- 생성 카드: 이름/설명 TextField, 시간표 Dropdown, `시나리오 생성` 버튼(클릭 시 POST /scenarios).
- 본문: 리스트/트리 뷰 토글 탭 클릭 → 뷰 전환. 각 Plan 카드(이름 bold, 설명 캡션, 부모/업데이트 캡션).
- 카드 우측 액션: `대체 시나리오 추가` 클릭 → 모달 → POST /scenarios/{parent}/alternatives. `수정` 클릭 → 모달 → PUT /scenarios/{id}. `삭제` 클릭 → DELETE /scenarios/{id}. `내비게이트` 클릭 → POST /scenarios/{id}/navigate.

### 수강신청
- 상단 카드: 시나리오 Dropdown 선택, 제목/메모 입력, `등록 세션 시작` 버튼(POST /registrations).
- 스텝 리스트 카드: 테이블 행마다 과목/액션/상태 Chip/메시지, 행 끝 삭제 아이콘(DELETE). 상단 `스텝 추가` 버튼 클릭 → 모달 → POST /registrations/{id}/steps.
- 하단 버튼 그룹: `완료`(POST /complete), `취소`(DELETE /{id}), `전체 삭제`(DELETE /registrations). “성공한 과목” 카드: 클릭 없음, GET 결과 표시만.

---
## 3. 데이터·API 매핑 (요약)
- 인증: POST `/api/v1/auth/login|signup`, GET `/users/me`; Refresh 없음 → 401 시 로그아웃.
- 강의: GET `/courses`(courseName/professor/departmentCode/campus/page/size), GET `/courses/{id}`.
- 위시리스트: POST `/wishlist {courseId, priority}`, GET `/wishlist`, DELETE `/wishlist/{courseId}`, GET `/wishlist/check/{courseId}`; 우선순위 변경은 삭제+재추가.
- 시간표: GET/POST/DELETE `/timetables`, GET `/timetables/{id}`, POST `/timetables/{id}/courses`, DELETE `/timetables/{id}/courses/{courseId}`, POST `/timetables/{id}/alternatives {excludedCourseIds}`.
- 시나리오: POST `/scenarios`, POST `/scenarios/{parent}/alternatives`, GET `/scenarios`, GET `/scenarios/{id}`, GET `/scenarios/{id}/tree`, PUT `/scenarios/{id}`, DELETE `/scenarios/{id}`, POST `/scenarios/{id}/navigate`.
- 수강신청: POST `/registrations`, POST `/registrations/{id}/steps`, GET `/registrations|/{id}`, POST `/registrations/{id}/complete`, DELETE `/registrations|/{id}`, GET `/registrations/{id}/succeeded-courses`.

---
## 4. 구현 체크리스트(프로토타입 동일성)
- 모든 클릭 액션은 위 시퀀스대로만 제공(추가 경로 금지: 강의 목록→시간표 직접 추가 UI 금지, courseId 수동 입력 금지).
- 선택되지 않은 편집 영역에는 안내만 표시, 리스트 클릭 후에만 편집 열림.
- 우선순위 변경/추가는 지정된 버튼·BottomSheet 경로 외 제공 금지.
- 충돌 계산은 classTimes로 즉시 수행해 표시.
- 문구/레이아웃은 카드 기반(AppTokens 색상/타이포)으로 유지, 확인 필요/TODO 문구 없음.
