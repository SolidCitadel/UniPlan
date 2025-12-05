# UniPlan E2E Tests

End-to-End 테스트를 통해 API Gateway를 거쳐 전체 백엔드 스택을 검증합니다.

## 특징

- **Signup-first 접근**: 테스트마다 신규 계정을 생성하여 진정한 E2E 테스트 수행
- **동적 픽스처 생성**: `/api/v1/courses/import` API를 통해 테스트용 과목 데이터 생성
- **API 계약 검증**: HTTP 레벨에서 API 응답 검증 (프론트엔드는 검증된 공통 DTO 사용 가능)
- **자동 정리**: 테스트 종료 시 생성된 리소스 자동 삭제
- **격리된 환경**: tmpfs를 사용한 인메모리 DB로 빠른 테스트 실행

## 사전 준비

### 1. 테스트 환경 실행

```bash
# 루트 디렉토리에서
docker compose -f docker-compose.test.yml up -d

# MySQL만 필요한 경우 (백엔드를 로컬에서 직접 실행할 때)
docker compose -f docker-compose.test.yml up mysql-test -d
```

### 2. 환경 설정

`tests/e2e/.env` 파일:

```bash
API_BASE_URL=http://localhost:8280
```

**참고**: 과목 데이터는 테스트 중 동적으로 생성됩니다 (`seedCourse()` 메서드)

## 테스트 실행

```bash
cd tests/e2e

# 의존성 설치
dart pub get

# 전체 테스트 실행
dart test

# 특정 테스트 실행
dart test test/full_workflow_test.dart
```

## 구조

```
tests/e2e/
├── .env                           # 환경 설정
├── pubspec.yaml                   # Dart 의존성
└── test/
    ├── helpers/
    │   ├── http_client.dart       # GatewayClient, EnvConfig
    │   └── test_context.dart      # E2eContext (API 래퍼 + 정리)
    └── full_workflow_test.dart    # 실제 테스트
```

**참고**: E2E 테스트는 HTTP API를 직접 검증하며, 프론트엔드는 이 검증된 API 명세를 바탕으로 `packages/uniplan_models`의 공통 DTO를 안전하게 사용할 수 있습니다.

## 주요 클래스

### GatewayClient

HTTP 클라이언트로 인증 및 API 호출 처리:

- `signup()`: 신규 계정 생성 및 자동 로그인
- `login()`: 기존 계정 로그인
- `get()`, `post()`, `delete()`: 인증 토큰 포함 API 호출

### E2eContext

테스트 컨텍스트로 리소스 추적 및 정리:

- `signup()`: 타임스탬프 기반 유니크 계정 생성
- `seedCourse()`: `/api/v1/courses/import` API를 통해 테스트용 과목 생성 및 ID 저장
- `createTimetable()`, `addCourse()`, `createScenario()` 등: API 래퍼
- `cleanup()`: 테스트 종료 시 생성된 리소스 삭제 (의존성 순서 고려)
- `fixtureCourseId`: `seedCourse()`로 생성된 과목의 ID

## 테스트 작성 예시

```dart
import 'package:test/test.dart';
import 'package:uniplan_models/uniplan_models.dart';
import 'helpers/http_client.dart';
import 'helpers/test_context.dart';

void main() {
  final env = EnvConfig.load();
  late E2eContext ctx;

  setUpAll(() async {
    ctx = E2eContext(env);
    await ctx.signup();      // 신규 계정 생성
    await ctx.seedCourse();  // 테스트용 과목 생성
  });

  tearDownAll(() async {
    await ctx.cleanup(); // 리소스 정리
  });

  test('alternative timetable respects excludedCourseIds contract', () async {
    expect(ctx.fixtureCourseId > 0, isTrue, reason: 'Fixture course must be seeded');
    final courseId = ctx.fixtureCourseId;

    final base = await ctx.createTimetable(
      name: 'E2E Base Timetable',
      openingYear: DateTime.now().year,
      semester: '1',
    );

    await ctx.addCourse(base.id, courseId);

    final alt = await ctx.createAlternativeTimetable(
      baseTimetableId: base.id,
      name: 'E2E Alternative',
      excludedCourseIds: {courseId},
    );

    // Contract: excludedCourseIds -> excludedCourses with courseId preserved
    expect(alt.excludedCourses.map((c) => c.courseId), contains(courseId));
    expect(alt.excludedCourses.firstWhere((c) => c.courseId == courseId).courseId, equals(courseId));
  });
}
```

## 테스트 환경 특징

### tmpfs 사용

- MySQL 데이터는 tmpfs (인메모리)에 저장되어 빠른 테스트 실행
- 컨테이너 재시작 시 데이터가 초기화되므로 테스트 격리 보장
- docker-compose.test.yml 설정:
  ```yaml
  tmpfs:
    - /var/lib/mysql
  ```

### JPA DDL Auto

- 모든 백엔드 서비스에서 `SPRING_JPA_HIBERNATE_DDL_AUTO=update` 설정
- 테이블 스키마가 자동으로 생성/업데이트됨
- 별도 migration 스크립트 불필요

## 트러블슈팅

### "Signup failed" 오류

- 백엔드 서비스가 실행 중인지 확인
- `docker compose -f docker-compose.test.yml logs api-gateway-test` 로그 확인

### "Failed to seed course" 오류

- catalog-service가 정상 실행 중인지 확인
- `/api/v1/courses/import` API 엔드포인트 확인
- `docker compose -f docker-compose.test.yml logs catalog-service-test` 로그 확인

### 포트 충돌

- 기존 docker-compose.yml (포트 8180, 3316)과 충돌하지 않도록 별도 포트 사용
- test: 8280 (gateway), 3307 (mysql)
- dev: 8180 (gateway), 3316 (mysql)

### 테스트 실패 시 리소스 정리

- 테스트가 실패해도 `tearDownAll`에서 자동 정리됨
- tmpfs 사용으로 컨테이너 재시작 시 자동 초기화
- 수동 정리가 필요한 경우:
  ```bash
  docker compose -f docker-compose.test.yml down
  docker compose -f docker-compose.test.yml up -d
  ```