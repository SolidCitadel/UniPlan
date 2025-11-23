# AGENT Guide (Frontend - Flutter Web)

## 필수 규칙
- 엔티티/DTO는 **freezed abstract class** 패턴 유지.
- 상태관리: **`flutter_riverpod`의 `AsyncNotifier` + `AsyncNotifierProvider`만 사용**. `StateNotifier`/`AutoDisposeAsyncNotifier`/별도 `riverpod` 패키지 사용 금지.
- ViewModel/UI에서는 `package:flutter_riverpod/flutter_riverpod.dart`만 import.
- 디자인: `AppTokens`(색/타이포/스페이싱/라운딩) 기반으로 UI 일관성 유지.
- API 계약: planner-service 타임테이블/시나리오 응답은 제외 과목을 `excludedCourses`(courseId 포함 객체 배열)로 내려주고, 요청은 `excludedCourseIds`를 받습니다. DTO/매퍼를 이 형태로 맞춥니다.

## 현재 상태
- TS/Vite 프로토타입 참고로 Flutter Web 골격 구성. Auth/코스 리스트/위시리스트/시간표 뷰모델/화면 뼈대 완료, 디자인 토큰 적용.
- `flutter analyze` clean 상태.

## 다음 단계
1) UI 패리티 확장: 시간표/시나리오/등록 지원 화면에 디자인 토큰 적용 후 실제 플로우 구현.
2) 백엔드 연동: 위시리스트 CRUD, 시간표/시나리오 플로우, 등록 지원 API 반영.
3) 품질: 뷰모델/유틸 테스트, 필요 시 골든 테스트, 회귀 플로우 체크리스트 유지.

## 명령 요약
- 의존성: `flutter pub get`
- 코드 생성: `flutter pub run build_runner build --delete-conflicting-outputs`
- 실행: `flutter run -d chrome`
- 분석/테스트: `flutter analyze`, `flutter test`
