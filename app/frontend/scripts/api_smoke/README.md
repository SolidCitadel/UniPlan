# API Smoke Script

백엔드 실제 엔드포인트를 호출해 계약을 빠르게 점검하는 스크립트입니다. 기본 동작은 읽기 전용(로그인 + GET)이며, 서버 상태를 바꾸는 호출은 기본값으로 비활성화했습니다.

## 필요 조건
- 백엔드 게이트웨이가 실행 중이어야 합니다.
- 테스트용 계정 이메일/비밀번호가 필요합니다.

## 실행 방법
- 이전 버전의 스크립트(`main.dart`)는 삭제했습니다. 필요 시 아래 흐름으로 새로 작성하세요.
- 사용 흐름 예시:
  1) `dart create -t console-full api_smoke` 식으로 임시 콘솔 프로젝트 생성
  2) `dio` 의존성 추가
  3) 로그인 → me → courses 검색/페이지 → wishlist → timetables 순으로 호출
  4) mutating API는 별도 플래그로 보호

## 현재 호출 흐름 (기본)
1) `POST /auth/login` → access/refresh 토큰 획득  
2) `GET /users/me` → User DTO 확인  
3) `GET /courses` → Page 응답에서 첫 아이템 스키마 확인  
4) `GET /wishlist` → 리스트 응답 확인(백엔드 구현 시)
5) `GET /timetables` → 리스트 응답 확인(존재 시)

> 주의: 서버 상태를 변경하는 호출(회원가입, 시간표 생성 등)은 기본 꺼짐입니다. 필요 시 별도 플래그를 두고, 백엔드/DB 초기화 정책을 확인한 뒤 사용하세요.
