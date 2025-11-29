# UniPlan Frontend (Flutter Web)

Flutter Web 기반 UniPlan 프론트엔드입니다. Riverpod 3 + GoRouter + Dio 조합으로 클린 아키텍처를 유지하며, TS/Vite 프로토타입(루트 `Uniplanprototype`)의 화면/플로우를 그대로 이식해 백엔드와 연동합니다.

## 현재 상태
- 화면 흐름: 로그인 → 강의 목록(검색/위시리스트) → 시간표 목록·편집 → 시나리오 목록·상세 → 수강신청(등록) 목록·상세.
- 시간표/시나리오/수강신청 탭은 목록 ↔ 상세를 분리한 라우팅으로 동작.
- Riverpod 3 `AsyncNotifier` 기반(Autodispose 계열 금지), Freezed/Json Serializable 생성 완료.
- 수강신청 상세는 과목 상태 변경 후 “다음 단계 저장”을 눌러야 서버에 step이 기록됩니다(즉시 호출 없음).

## 기술 스택
- Flutter Web (Dart 3), GoRouter, flutter_riverpod 3.x
- 네트워크: Dio
- 코드 생성: Freezed, Json Serializable
- 테마: FlexColorScheme, Google Fonts, AppTokens

## 디렉터리
```
lib/
├─ core/           # 공용 상수/테마/네트워크 클라이언트
├─ data/           # DTO, mapper, remote datasource(Dio), repository 구현
├─ domain/         # Entity(Freezed), Repository 인터페이스
└─ presentation/   # UI(Screen/Widget) + ViewModel(AsyncNotifier 기반)
docs/              # 설계/플로우 문서
```

## 주요 화면/플로우 요약
- 로그인: 이메일/비밀번호 입력 → `/app/courses`. Refresh 미구현 → 401 시 로그인 리다이렉트.
- 강의 목록: 검색/필터, 교수·과목명·시간대 표기. “위시리스트 추가” → 우선순위 1~5 선택 BottomSheet → POST `/wishlist`.
- 위시리스트: 우선순위별 그룹 카드, 우선순위 변경/삭제 지원.
- 시간표
  - 목록 `/app/timetables`: 카드 리스트 + “생성” 모달(이름 입력). 선택 시 편집.
  - 편집 `/app/timetables/:id`: 좌측 (추가 가능/시간 겹침/제외됨) 토글 + 목록, 우측 주간 그리드(09~21시). 호버 미리보기, 추가/제외 반영. 대안 시간표 생성 버튼은 헤더 오른쪽.
- 시나리오
  - 목록 `/app/scenarios`: 시간표 기반 생성/수정/삭제.
  - 상세 `/app/scenarios/:id`: 트리 뷰 + 기준 시간표/과목 토글 → 대안 연결. 실패 과목과 화살표는 빨간색.
- 수강신청(등록)
  - 목록 `/app/registrations`: 세션 리스트 + “새로 시작”(시나리오 선택, 이름 입력). 취소/삭제 분리.
  - 상세 `/app/registrations/:id`: 좌측 상태 리스트(성공/대기/실패, 누적 집합). 대기는 현재 시간표 과목만, 성공/실패는 시작+현재 시나리오 전체에서 매핑. “다음 단계 저장” 시 `addStep` 호출. 우측 그리드: 성공=초록, 대기=연한 회색, 실패=빨강, 취소/제외=연한 빨강.

세부 화면/요구사항/엔드포인트: `docs/frontend-status.md` 참고.

## 실행
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome          # 개발 실행
# flutter analyze               # 정적 분석(환경에 따라 오래 걸릴 수 있음)
flutter test                   # 테스트
```

## 작업 가이드 (요약)
- Riverpod 3: `AsyncNotifier`/`Notifier` 사용, AutoDispose 계열 지양.
- 버튼 기반 저장 UX(예: 수강신청 “다음 단계 저장”)은 유지.
- 빌드 산출물(`*.g.dart`, `*.freezed.dart`)은 build_runner로 재생성.
- 백엔드 스펙 변경 시 dto/mapper/data source/문서를 함께 수정.
