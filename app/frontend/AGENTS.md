# AGENT Guide (Frontend)

프론트 작업 시 따라야 할 공통 규칙입니다. 기존 코드/문서와 다르면 이 문서를 우선합니다.

## 기본 원칙
- Riverpod 3만 사용. `AutoDisposeAsyncNotifier*` 계열, 예전 Provider 문법 금지. 상태는 `AsyncNotifier`/`Notifier`로 관리하고 `ref.watch`/`ref.read` 패턴 유지.
- 화면 저장 흐름을 지키기: 수강신청 상세는 과목 상태 변경 후 “다음 단계 저장” 버튼으로 `addStep` 호출. 즉시 전송 UX로 바꾸지 말 것.
- 라우팅: 목록/상세 분리(`.../:id`) 유지. 뒤로가기/헤더 동작이 목록으로 돌아오도록 고정.
- API 스펙 변경 시 DTO → mapper → datasource → domain → 문서 순으로 일관되게 수정.
- 코드 생성 파일(`*.g.dart`, `*.freezed.dart`)은 `flutter pub run build_runner build --delete-conflicting-outputs`로 재생성.
- 테마/토큰(AppTokens) 사용, 하드코딩된 색상/폰트 지양.

## 화면별 주의
- 강의 목록/위시리스트: 우선순위 1~5 선택 BottomSheet, courseId는 UI에 노출하지 않음.
- 시간표 편집: 좌측 탭(추가 가능/시간 겹침/제외됨) + 우측 주간 그리드 09~21시. 호버 시 반투명 미리보기. 겹치는 과목은 “시간 겹침” 탭에만 노출.
- 시나리오 상세: 트리 뷰에서 실패 과목/화살표를 빨간색으로 표시. 기준 시간표는 변경하지 않음.
- 수강신청 상세: 성공/대기/실패는 백엔드가 누적 집합을 내려줌. 대기는 현재 시나리오의 과목만, 성공/실패는 시작+현재 시나리오 전체를 매핑. “다음 단계 저장” 버튼 필수.

## 분석/테스트
- `flutter analyze`가 환경에 따라 오래 걸릴 수 있음. 가능하면 로컬에서 전체 실행, 최소한 수정 파일 단위 분석 수행.
- 테스트 추가 시 `flutter test`로 돌릴 수 있게 작성.
