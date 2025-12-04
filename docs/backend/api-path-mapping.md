# API 경로 매핑 정리

## 🔍 문제: 경로 충돌

### ❌ 잘못된 방식 (이전)
```
API Gateway: /api/v1/users/me
  → RewritePath로 /users/me 변환
  → User Service에 /users/me 요청

User Service: @RequestMapping("/api/v1/users")
  → /api/v1/users/me만 받음
  → 404 Not Found! ❌
```

### ✅ 올바른 방식 (수정 후)
```
API Gateway: /api/v1/users/me
  → RewritePath로 /users/me 변환
  → User Service에 /users/me 요청

User Service: @RequestMapping("/users")
  → /users/me 받음
  → 200 OK! ✅
```

## 📋 서비스별 경로 매핑 규칙

### API Gateway (application-local.yml)
```yaml
routes:
  - id: user-service
    uri: http://localhost:8081
    predicates:
      - Path=/api/v1/auth/**, /api/v1/users/**
    filters:
      - RewritePath=/api/v1/(?<segment>.*), /$\{segment}
      #              ^^^^^^^^^^^^^^^^^^^^     ^^^^^^^^^^^^^^
      #              외부 경로                 내부 경로 (변환)
```

**변환 예시:**
- `/api/v1/users/me` → `/users/me`
- `/api/v1/auth/login` → `/auth/login`
- `/api/v1/planner/scenarios` → `/planner/scenarios`

### User Service (Controller)
```java
// ❌ 잘못된 매핑
@RequestMapping("/api/v1/users")  // Gateway가 이미 /api/v1 제거함!

// ✅ 올바른 매핑
@RequestMapping("/users")  // Gateway에서 변환된 경로
```

### 다른 서비스들도 동일 (향후)
```java
// Planner Service
@RequestMapping("/planner")  // /api/v1/planner → /planner

// Catalog Service  
@RequestMapping("/catalog")  // /api/v1/catalog → /catalog
```

## 🎯 왜 이렇게 하나요?

### 장점:
1. **서비스 독립성**: User Service는 `/api/v1` 같은 Gateway 규칙을 몰라도 됨
2. **유연성**: Gateway에서 버전 관리 (`/api/v1`, `/api/v2`)
3. **단순성**: 각 서비스는 간단한 경로만 처리
4. **일관성**: 모든 서비스가 동일한 패턴

### 실제 요청 흐름:
```
클라이언트 (Flutter 웹)
  ↓
  GET http://localhost:8080/api/v1/users/me
  Authorization: Bearer {token}
  ↓
API Gateway
  ├─ JWT 검증
  ├─ X-User-Id: 123 헤더 추가
  └─ 경로 변환: /api/v1/users/me → /users/me
  ↓
User Service (8081)
  ↓
  GET http://localhost:8081/users/me
  X-User-Id: 123
  ↓
UserController (@RequestMapping("/users"))
  └─ @GetMapping("/me")
  ↓
UserService.getUserInfo(123)
  ↓
200 OK { id: 123, email: "...", ... }
```

## 📝 직접 테스트 시

### API Gateway 통해 (실제 사용):
```bash
curl http://localhost:8080/api/v1/users/me \
  -H "Authorization: Bearer {token}"
```

### User Service 직접 (개발/테스트):
```bash
# ✅ 올바른 경로
curl http://localhost:8081/users/me \
  -H "X-User-Id: 1"

# ❌ 잘못된 경로 (404 발생)
curl http://localhost:8081/api/v1/users/me \
  -H "X-User-Id: 1"
```

## 🔧 수정 완료

### User Service
- ✅ `UserController`: `/api/v1/users` → `/users`
- ✅ AuthController는 그대로 (루트 경로 사용)

### 다른 컨트롤러가 있다면?
```java
// 인증 관련 (Gateway: /api/v1/auth/** → /auth/**)
@RestController
@RequestMapping("/auth")  // /api/v1 제외
class AuthController { ... }

// 시간표 관련 (Planner Service)
@RestController
@RequestMapping("/timetables")  // /api/v1 제외
class TimetableController { ... }
```

## 🎓 핵심 원칙

**"마이크로서비스는 Gateway의 라우팅 규칙을 모른다"**
- 각 서비스는 자신만의 단순한 경로 (`/users`, `/planner`)
- API Gateway가 외부 경로 (`/api/v1/users`) 관리
- 경로 변환은 Gateway의 책임!

이제 User Service를 재시작하면 정상 작동합니다! 🎉

