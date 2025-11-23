# UniPlan

시나리오 기반 대학 수강 계획/실시간 등록 내비게이션 서비스입니다. Plan A/B/C로 시간표를 준비하고, 등록 시점에는 남은 선택지를 실시간으로 안내합니다.

## 현재 상태
- 백엔드(Spring Boot MSA)와 CLI 클라이언트는 동작 가능.
- TS/Vite 프로토타입(`Uniplanprototype`)을 참고해 `app/frontend`에 Flutter Web 앱 골격을 만들었으나, 오류가 많아 전면 리팩토링 필요.
- 목표: 프로토타입과 동일한 디자인/UX로 Flutter Web을 완성 → 백엔드 API 연동 → 통합 검증.

## 디렉터리 구조
```
UniPlan/
├─ app/
│  ├─ backend/          # Spring Boot MSA (api-gateway, user, catalog, planner, common-lib)
│  ├─ cli-client/       # Dart CLI 클라이언트
│  └─ frontend/         # Flutter Web 앱(리팩토링 대상)
├─ scripts/
│  └─ crawler/          # 강의 메타데이터 크롤러
└─ Uniplanprototype/    # TS/Vite 프로토타입 (디자인/플로우 참고)
```

## 주요 스택
- Backend: Spring Boot 3.x (Java 21), Gradle(Kotlin DSL), MySQL(prod)/H2(dev), JWT, Swagger/OpenAPI
- Frontend: Flutter Web, Riverpod, GoRouter, Dio, Freezed/JSON Serializable, FlexColorScheme, Hooks
- CLI: Dart
- Scripts: Python 3.x

## 우선 로드맵 (프런트 중심)
1) **베이스 정리**: Flutter stable 고정, `flutter pub get`, `build_runner` 재생성, `flutter analyze` 경고 제거.  
2) **UI 패리티**: 프로토타입의 색/타이포/레이아웃/컴포넌트를 추출해 Flutter 테마/공용 위젯에 반영. 화면별(로그인/회원가입, 과목 검색, 위시리스트, 시나리오·시간표, 등록 지원, 도움말) UI 정비.  
3) **백엔드 연동**: 컨트롤러·DTO·응답 형태 확인 후 파라미터/모델 매핑. Dio 인터셉터로 토큰 주입·401 처리. 로딩/에러/빈 상태를 UI에 명시.  
4) **품질/검증**: 핵심 뷰모델/유틸 테스트, 필요한 골든 테스트, 회귀 체크리스트(로그인→검색→위시리스트→시간표 배치→시나리오 전환).

## 실행/개발 요약
- Backend 빌드/실행  
  ```bash
  cd app/backend
  ./gradlew clean build
  ./gradlew :api-gateway:bootRun      # 8080
  ./gradlew :user-service:bootRun     # 8081
  ./gradlew :catalog-service:bootRun  # 8083
  ```
  Swagger: http://localhost:8080/swagger-ui.html

- Crawler 예시  
  ```bash
  cd scripts/crawler
  python -m venv venv && venv\Scripts\activate
  pip install -r requirements.txt
  python crawl_metadata.py --year 2025 --semester 1
  python run_crawler.py --year 2025 --semester 1
  python transformer.py --metadata ... --courses ...
  ```

- Frontend 준비/실행(웹)  
  ```bash
  cd app/frontend
  flutter pub get
  flutter pub run build_runner build --delete-conflicting-outputs
  flutter run -d chrome
  flutter analyze
  flutter test
  ```

## 참고 문서
- 작업 가이드(루트): `AGENT.md`
- 프런트엔드 가이드: `app/frontend/AGENT.md`
- TS 프로토타입: `Uniplanprototype/README.md` (Figma 링크 포함)
