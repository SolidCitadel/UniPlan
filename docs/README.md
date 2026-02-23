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

- [ADR-001: Monorepo Structure](./adr/001-monorepo-structure.md): 모노레포 구조 선택 (멀티레포 대비 근거)
- [ADR-002: MSA & DDD Strategy](./adr/002-msa-ddd-strategy.md): MSA 및 도메인 주도 설계
- [ADR-003: Docker Compose Infrastructure](./adr/003-docker-compose-infra.md): Docker Compose 기반 인프라 운영 (K8s/Terraform 미도입 근거)
- [ADR-004: API Gateway Strategy](./adr/004-api-gateway-strategy.md): 중앙집중식 API Gateway 및 인증
- [ADR-005: Centralized Configuration](./adr/005-centralized-config.md): Docker Compose 환경변수 기반 설정 관리
- [ADR-006: Test Strategy](./adr/006-test-strategy.md): 5단계 테스트 전략 및 TestContainers 도입
- [ADR-007: OpenAPI Code Generation](./adr/007-openapi-code-generation.md): Code-First OpenAPI 기반 클라이언트 코드 자동 생성

## 🛠️ 가이드 (Guides)

- [**Backend Guide**](./guides/backend.md): 백엔드 개발 컨벤션, DDD, 구조
- [**Frontend Guide**](./guides/frontend.md): 프론트엔드 컨벤션, 상태 관리
- [**Testing Guide**](./guides/testing.md): 테스트 전략, JUnit/Pytest 가이드
- [**Deployment Guide**](./guides/deployment.md): 로컬 실행 및 배포 전략

