# Features

UniPlan의 주요 기능별 사용자 시나리오와 명세를 설명합니다.

---

## 1. 강의 검색 (Course Search)

### 사용자 시나리오

사용자는 과목명, 교수명, 학과코드, 캠퍼스 등의 조건으로 강의를 검색할 수 있습니다.

### 주요 기능

- 검색 필터: 과목명, 교수명, 학과코드, 캠퍼스
- 페이징 지원: page/size 파라미터
- 강의 상세 조회: 시간, 강의실, 학점 등

### API

```
GET /api/v1/courses?courseName=컴퓨터&professor=김철수&page=0&size=20
GET /api/v1/courses/{id}
```

### UI 플로우

```
강의 목록 화면
  ├─ 필터 입력 (과목명/교수/학과/캠퍼스)
  ├─ 검색 버튼 클릭 → 리스트 갱신
  ├─ 초기화 버튼 → 필터 비움
  └─ 리스트 행 클릭 → 강의 상세
```

---

## 2. 위시리스트 (Wishlist)

### 사용자 시나리오

사용자는 관심 있는 과목을 우선순위(1~5)와 함께 위시리스트에 추가할 수 있습니다.

### 주요 기능

- 과목 추가: 강의 목록에서 위시리스트 아이콘 클릭 → 우선순위 선택 (BottomSheet)
- 우선순위 변경: PopupMenu에서 1~5 선택
- 과목 삭제: 휴지통 아이콘 클릭
- 우선순위별 그룹화: 카드 헤더에 "우선순위 N" 표시

### API

```
POST   /api/v1/wishlist { courseId: 101, priority: 1 }
GET    /api/v1/wishlist
PATCH  /api/v1/wishlist/{id} { priority: 3 }
DELETE /api/v1/wishlist/{id}
```

### 제약사항

- courseId 수동 입력 UI 금지 (강의 목록 BottomSheet만 사용)
- 같은 과목 중복 추가 불가

### UI 플로우

```
강의 목록 화면
  └─ 위시리스트 추가 아이콘 클릭
      └─ BottomSheet (우선순위 1~5 ChoiceChip)
          └─ Chip 클릭 → POST /wishlist → 성공 Snackbar

위시리스트 화면
  ├─ 우선순위별 카드 (헤더: "우선순위 N")
  ├─ 아이템 클릭 → 우선순위 변경 PopupMenu
  └─ 삭제 아이콘 클릭 → DELETE
```

---

## 3. 시간표 계획 (Timetable Planning)

### 사용자 시나리오

사용자는 여러 시간표를 만들어 강의 조합을 계획할 수 있습니다. 특정 과목을 제외한 대안 시간표도 생성 가능합니다.

### 주요 기능

- 시간표 생성: 이름, 연도, 학기 입력
- 강의 추가: 위시리스트에서 선택
- 강의 삭제: 주간 그리드에서 삭제 아이콘 클릭
- 대안 시간표 생성: 기존 시간표를 복사하고 일부 과목 제외
- 시간 충돌 감지: 겹치는 과목은 "시간 겹침" 탭으로 이동
- 제외 과목 관리: 대안 시간표 생성 시 제외된 과목은 추가 불가

### API

```
POST   /api/v1/timetables { name: "Plan A", openingYear: 2025, semester: "1학기" }
POST   /api/v1/timetables/{id}/courses { courseId: 101 }
DELETE /api/v1/timetables/{id}/courses/{courseId}
POST   /api/v1/timetables/{id}/alternatives { name: "Plan B", excludedCourseIds: [101] }
GET    /api/v1/timetables
GET    /api/v1/timetables/{id}
PATCH  /api/v1/timetables/{id}
DELETE /api/v1/timetables/{id}
```

### UI 플로우

```
시간표 목록 화면
  ├─ 생성 카드: 이름/연도/학기 입력 → 생성 버튼
  ├─ 리스트 아이템 클릭 → 편집 화면
  └─ 삭제 아이콘 클릭 → DELETE

시간표 편집 화면
  ├─ 좌측: 탭 (추가 가능/시간 겹침/제외됨)
  │   ├─ 추가 가능: 호버 시 주간 그리드에 미리보기
  │   ├─ 시간 겹침: 충돌 과목 목록
  │   └─ 제외됨: 대안 시간표에서 제외한 과목
  ├─ 우측: 주간 그리드 (09~21시)
  │   ├─ 과목 블록 (교수/장소 표시, 시간 텍스트 제외)
  │   └─ 삭제 아이콘 클릭 → 과목 제거
  └─ 대안 생성 버튼: 일부 과목 토글 → 새 시간표 생성
```

### 제약사항

- 제외된 과목은 해당 시간표에 다시 추가 불가
- 시간 겹치는 과목은 자동으로 "시간 겹침" 탭으로 분리

---

## 4. 시나리오 계획 (Scenario Planning)

### 사용자 시나리오

사용자는 수강신청 시 과목이 실패했을 때 어떤 대안 시간표로 이동할지 미리 계획할 수 있습니다.

### 주요 기능

- 루트 시나리오 생성: 시작 시간표 지정
- 대안 시나리오 생성: 부모 시나리오에서 특정 과목 실패 시 이동할 자식 시나리오
- 의사결정 트리 시각화: 트리 뷰로 시나리오 전개 확인
- 실패 과목 강조: 실패 과목과 화살표를 빨간색으로 표시
- 실시간 네비게이션 테스트: 특정 과목 실패 시 어느 시나리오로 이동하는지 확인

### API

```
POST /api/v1/scenarios { name: "Plan A", timetableId: 1 }
POST /api/v1/scenarios/{parentId}/alternatives { name: "Plan B", failedCourseId: 101, timetableId: 2 }
GET  /api/v1/scenarios
GET  /api/v1/scenarios/{id}
GET  /api/v1/scenarios/{id}/tree
POST /api/v1/scenarios/{id}/navigate { failedCourseIds: [101] }
PATCH /api/v1/scenarios/{id}
DELETE /api/v1/scenarios/{id}
```

### UI 플로우

```
시나리오 목록 화면
  ├─ 생성 카드: 이름/설명/시간표 선택 → 생성 버튼
  └─ 리스트/트리 뷰 토글 탭

시나리오 상세 화면 (트리 뷰)
  ├─ 노드 라벨: "시나리오명: 실패 과목들 → 대안"
  │   └─ 실패 과목/화살표: 빨간색 강조
  ├─ 노드 클릭 → 포커스/하이라이트
  ├─ 대체 시나리오 추가 버튼
  │   └─ 모달: 이름/설명/시간표/제외 과목 입력
  ├─ 수정 버튼 → 이름/설명 변경
  ├─ 삭제 버튼
  └─ 내비게이트 버튼 → 실시간 네비게이션 테스트
```

### 제약사항

- 기준 시간표는 생성 시 지정한 값으로 유지 (변경 불가)
- 자식 시나리오는 부모와 실패 과목으로 연결

---

## 5. 수강신청 (Registration)

### 사용자 시나리오

사용자는 미리 계획한 시나리오를 기반으로 수강신청 과정을 시뮬레이션하고, 실패 시 자동으로 대안 시나리오로 전환됩니다.

### 주요 기능

- 세션 시작: 시작 시나리오 선택 + 세션 이름 입력
- 과목별 결과 기록: 성공/실패/취소 상태 마킹
- 배치 제출: 마킹한 결과를 한 번에 서버로 전송
- 자동 네비게이션: 실패 과목이 있으면 자동으로 대안 시나리오로 전환
- 상태 시각화:
  - 좌측 리스트: 성공/대기/실패/취소 목록
  - 우측 주간 그리드: 색상으로 상태 표시 (성공=초록, 대기=회색, 실패=빨강, 취소=연한 빨강)
- 완료/취소/삭제: 세션 종료 옵션

### API

```
POST   /api/v1/registrations { scenarioId: 10 }
POST   /api/v1/registrations/{id}/steps { succeededCourses: [101], failedCourses: [102], canceledCourses: [] }
GET    /api/v1/registrations
GET    /api/v1/registrations/{id}
POST   /api/v1/registrations/{id}/complete
POST   /api/v1/registrations/{id}/cancel
DELETE /api/v1/registrations/{id}
```

### 상태 관리 규칙

- **성공/실패**: 백엔드가 모든 step을 누적(distinct)한 집합을 내려줌
- **대기**: 현재 시나리오의 과목만 필터링
- **취소**: 서버의 `canceledCourses` + 성공 목록 중 현재 시간표에 없는 과목

### UI 플로우

```
수강신청 목록 화면
  ├─ 세션 리스트 (상태 표시)
  ├─ 새로 시작 버튼
  │   └─ 모달: 시나리오 선택 + 세션 이름 입력
  └─ 세션 클릭 → 상세 화면

수강신청 상세 화면
  ├─ 좌측: 상태 리스트 (성공/대기/실패/취소)
  ├─ 우측: 주간 그리드 (색상으로 상태 표시)
  ├─ 과목 상태 변경 (로컬 마킹)
  │   └─ 성공/실패/취소 선택
  ├─ "다음 단계 저장" 버튼 클릭
  │   └─ POST /steps → 자동 네비게이션 (실패 시)
  └─ AppBar 액션: 완료/취소/삭제
```

### 제약사항

- 과목 상태 변경 후 "다음 단계 저장" 버튼을 눌러야 서버 호출
- 즉시 전송 UX로 변경 금지 (명시적 저장 흐름 유지)
- 취소된 과목은 빨간색으로 강조

---

## 공통 규칙

### API 계약

- **Timetable/Scenario**: 요청 시 `excludedCourseIds` (배열), 응답 시 `excludedCourses` (객체 배열)
- **Registration**: 배치 방식 (succeededCourses, failedCourses, canceledCourses 배열)

### UI 원칙

- 모든 카드: AppTokens.surface, radius 12, padding 16~24
- 본문 폭: 1200~1440px 중앙 정렬
- 상단 네비: 높이 64px (좌 로고, 우 탭)
- 글꼴: AppTokens.heading/body/caption

### 라우팅

- 목록/상세 분리: `.../:id` 패턴
- 뒤로가기/헤더: 목록으로 이동
- 네비 탭 클릭: 해당 화면 라우팅
