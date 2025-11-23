# UniPlan Frontend (Flutter Web)

TS/Vite 프로토타입과 동일한 디자인/플로우를 Flutter Web으로 구현하는 클라이언트입니다. Riverpod+GoRouter+Dio 기반의 Clean Architecture를 사용합니다.

## 현재 상태
- 프로토타입(루트 `Uniplanprototype`)을 참고해 Flutter 골격을 구성했지만, UI/상태/스타일 오류가 많아 전면 리팩토링이 필요합니다.
- 목표: 프로토타입과 UI 패리티 확보 → 백엔드 API 연동 → 품질/테스트 안정화.

## 기술 스택
- Flutter Web, Dart 3
- 상태관리: Riverpod/Hooks Riverpod
- 라우팅: GoRouter
- 네트워크: Dio (인터셉터 기반 인증)
- 코드 생성: Freezed, JSON Serializable
- 테마: FlexColorScheme, Google Fonts

## 디렉터리 구조
```
lib/
├─ core/           # 공용 상수, 테마, 라우터, 네트워크, 스토리지
├─ data/           # DataSource + Repository 구현(Dio)
├─ domain/         # Entity(Freezed), Repository 인터페이스
└─ presentation/   # UI(Screen, Widget) + ViewModel(StateNotifier)
```

## 준비 및 실행
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome        # 웹 실행
flutter analyze              # 정적 분석
flutter test                 # 테스트
```

## 리팩토링/개발 가이드 (요약)
- Phase 0: Flutter stable 고정, 코드 생성/분석 정리, 프로토타입에서 색/타이포/컴포넌트 토큰 추출.
- Phase 1: 화면별 UI 패리티(로그인/회원가입, 과목검색+필터, 위시리스트, 시나리오·시간표, 등록 지원, 도움말), 공용 컴포넌트/반응형 레이아웃 확보.
- Phase 2: 백엔드 연동(컨트롤러·DTO 확인 후 파라미터/응답 매핑, 토큰 주입/401 처리, 로딩/에러/빈 상태 UX).
- Phase 3: 품질(뷰모델/유틸 테스트, 필요 시 골든 테스트, 회귀 체크리스트).

자세한 작업 단계와 규칙은 `app/frontend/AGENT.md`를 참고하세요.
