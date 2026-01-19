# UniPlan Documentation

UniPlan 프로젝트의 기술 문서 인덱스입니다.

## 📚 핵심 문서

| 문서 | 설명 | 대상 |
|------|------|------|
| [**Requirements**](./requirements.md) | 프로젝트 요구사항 상세 | 전체 |
| [**Features**](./features.md) | 기능 명세, 사용자 시나리오 | 기획, 개발 전체 |
| [**Architecture**](./architecture.md) | 시스템 아키텍처, 데이터 모델, 통신 구조 | 아키텍트, 백엔드 |
| [**Guides**](./guides/) | 개발 가이드 (Backend, Frontend, etc) | 전체 |

## 🏗️ Architecture Decision Records (ADR)

중요한 기술적 의사결정의 배경과 결과를 기록합니다.

- [**001-test-strategy.md**](./adr/001-test-strategy.md): 5단계 테스트 전략 및 TestContainers 도입
- [**002-msa-ddd-strategy.md**](./adr/002-msa-ddd-strategy.md): MSA 도입 및 도메인 분리 전략 (User/Planner/Catalog)
- [**003-api-gateway-strategy.md**](./adr/003-api-gateway-strategy.md): 중앙 집중식 인증 및 라우팅 전략
- [**004-centralized-config.md**](./adr/004-centralized-config.md): 중앙집중식 설정 관리 (Docker Compose 환경변수)

## 🛠️ 가이드 (Guides)

- [**Backend Guide**](./guides/backend.md): 백엔드 개발 컨벤션, DDD, 구조
- [**Frontend Guide**](./guides/frontend.md): 프론트엔드 컨벤션, 상태 관리
- [**Testing Guide**](./guides/testing.md): 테스트 전략, JUnit/Pytest 가이드
- [**Deployment Guide**](./guides/deployment.md): 로컬 실행 및 배포 전략

