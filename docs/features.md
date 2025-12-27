# Features

UniPlan의 주요 기능별 사용자 시나리오와 API 명세입니다.

---

## 1. 강의 검색 (Course Search)

### 사용자 시나리오

과목명, 교수명, 학과, 캠퍼스 등의 조건으로 강의를 검색합니다.

### API

```
GET /api/v1/courses?courseName=컴퓨터&professor=김철수&page=0&size=20
GET /api/v1/courses/{id}
```

### 주요 기능

- 검색 필터: 과목명, 교수명, 학과코드, 캠퍼스
- 페이징: page/size 파라미터
- 강의 상세: 시간, 강의실, 학점

---

## 2. 위시리스트 (Wishlist)

### 사용자 시나리오

관심 과목을 우선순위(1~5)와 함께 저장합니다.

### API

```
POST   /api/v1/wishlist { courseId: 101, priority: 1 }
GET    /api/v1/wishlist
PATCH  /api/v1/wishlist/{id} { priority: 3 }
DELETE /api/v1/wishlist/{id}
```

### 주요 기능

- 과목 추가: 강의 목록에서 선택 → 우선순위 지정
- 우선순위 변경: 1~5 선택
- 우선순위별 그룹화 표시

### 제약사항

- 같은 과목 중복 추가 불가

---

## 3. 시간표 계획 (Timetable Planning)

### 사용자 시나리오

여러 시간표를 만들어 강의 조합을 계획합니다. 특정 과목을 제외한 대안 시간표도 생성 가능합니다.

### API

```
POST   /api/v1/timetables { name: "Plan A", openingYear: 2025, semester: "1" }
GET    /api/v1/timetables
GET    /api/v1/timetables/{id}
PATCH  /api/v1/timetables/{id}
DELETE /api/v1/timetables/{id}

POST   /api/v1/timetables/{id}/courses/{courseId}
DELETE /api/v1/timetables/{id}/courses/{courseId}

POST   /api/v1/timetables/{id}/alternatives { name: "Plan B", excludedCourseIds: [101] }
```

### 주요 기능

- 시간표 생성: 이름, 연도, 학기 입력
- 강의 추가/삭제: 위시리스트에서 선택
- 대안 시간표: 기존 시간표 복사 + 일부 과목 제외
- 시간 충돌 감지

### 제약사항

- 제외된 과목은 해당 시간표에 다시 추가 불가

### API 계약

- **요청**: `excludedCourseIds` (Long 배열)
- **응답**: `excludedCourses` (courseId 포함 객체 배열)

---

## 4. 시나리오 계획 (Scenario Planning)

### 사용자 시나리오

과목 실패 시 어떤 대안 시간표로 이동할지 의사결정 트리로 계획합니다.

### API

```
POST   /api/v1/scenarios { name: "Plan A", timetableId: 1 }
POST   /api/v1/scenarios/{parentId}/alternatives { name: "Plan B", failedCourseIds: [101], timetableId: 2 }
GET    /api/v1/scenarios
GET    /api/v1/scenarios/{id}
POST   /api/v1/scenarios/{id}/navigate { failedCourseIds: [101] }
DELETE /api/v1/scenarios/{id}
```

### 주요 기능

- 루트 시나리오: 시작 시간표 지정
- 대안 시나리오: 특정 과목 실패 시 이동할 자식 시나리오
- 트리 시각화: 의사결정 트리로 시나리오 전개 확인
- 네비게이션 테스트: 실패 조합에 따른 이동 경로 확인

---

## 5. 수강신청 시뮬레이션 (Registration)

### 사용자 시나리오

계획한 시나리오를 기반으로 수강신청을 시뮬레이션합니다. 과목 실패 시 자동으로 대안 시나리오로 전환됩니다.

### API

```
POST   /api/v1/registrations { scenarioId: 10, name: "2025-1 수강신청" }
GET    /api/v1/registrations
GET    /api/v1/registrations/{id}
POST   /api/v1/registrations/{id}/steps { succeededCourses: [101], failedCourses: [102], canceledCourses: [] }
POST   /api/v1/registrations/{id}/complete
POST   /api/v1/registrations/{id}/cancel
DELETE /api/v1/registrations/{id}
```

### 주요 기능

- 세션 시작: 시나리오 선택 + 세션 이름
- 과목별 결과 기록: 성공/실패/취소 마킹
- 자동 네비게이션: 실패 시 대안 시나리오로 전환
- 상태 시각화: 주간 그리드에 색상으로 표시

### 상태

| 상태 | 설명 | 색상 |
|------|------|------|
| 성공 | 수강신청 성공 | 초록 |
| 대기 | 아직 시도 안함 | 회색 |
| 실패 | 수강신청 실패 | 빨강 |
| 취소 | 사용자가 취소 | 연한 빨강 |

---

## 공통

### UI 원칙

- 최대 너비 1440px 중앙 정렬
- shadcn/ui 컴포넌트 + Tailwind CSS
- 반응형 디자인

### 라우팅 패턴

- 목록: `/timetables`, `/scenarios`, `/registrations`
- 상세: `/timetables/{id}`, `/scenarios/{id}`, `/registrations/{id}`