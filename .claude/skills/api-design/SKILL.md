# API 설계 원칙 (UniPlan)

code-reviewer agent, planner agent가 참조하는 REST API 설계 가이드.
UniPlan Gateway 패턴 반영.

## URL 구조

```
외부 경로: /api/v1/{resource}
내부 경로: /{resource}  (Gateway가 /api/v1 제거)

예시:
  클라이언트 → Gateway → 서비스
  /api/v1/timetables/1 → /timetables/1 (planner-service)
  /api/v1/courses → /courses (catalog-service)
```

## 복수 명사 + kebab-case

```
✅ /api/v1/timetables
✅ /api/v1/timetable-items
✅ /api/v1/team-members

❌ /api/v1/getTimetable
❌ /api/v1/timetable
❌ /api/v1/TimetableItems
```

## 비CRUD 동사: 동사형 URL

```
✅ POST /api/v1/registrations/{id}/cancel
✅ POST /api/v1/scenarios/{id}/simulate
✅ POST /api/v1/timetables/{id}/items/{itemId}/move

❌ PUT /api/v1/registrations/{id}?action=cancel
```

## HTTP 상태 코드 표준

| 동작 | 상태 코드 | 예시 |
|------|-----------|------|
| GET 성공 | 200 OK | 목록/단건 조회 |
| POST 생성 | **201 Created** + Location 헤더 | 시간표, 시나리오 생성 |
| POST 상태 변경 | 200 OK | 시뮬레이션, 취소 |
| PUT/PATCH 수정 | 200 OK | 이름 변경 |
| DELETE | **204 No Content** | 삭제 |
| 유효성 실패 | **422 Unprocessable Entity** | @Valid 실패 |
| 리소스 없음 | **404 Not Found** | findById 실패 |
| 중복 | **409 Conflict** | 시간 충돌, 이미 존재 |
| 인증 실패 | **401 Unauthorized** | 토큰 없음/만료 |
| 권한 부족 | **403 Forbidden** | 타인 리소스 |

```java
// 201 + Location 헤더 예시
@PostMapping("/timetables")
public ResponseEntity<TimetableResponse> create(...) {
    TimetableResponse response = timetableService.create(userId, request);
    URI location = URI.create("/timetables/" + response.id());
    return ResponseEntity.created(location).body(response);
}
```

## 에러 응답 통일 구조

```java
// 모든 서비스 공통 (GlobalExceptionHandler)
public record ErrorResponse(int status, String message) {}

// 응답 예시
{
  "status": 404,
  "message": "시간표를 찾을 수 없습니다. id: 999"
}
```

## 페이지네이션

```
# 소량 데이터 (< 1000건): offset 기반
GET /api/v1/courses?page=0&size=20&sort=name,asc

# 대량 데이터 (> 1000건): 커서 기반 권장
GET /api/v1/courses?cursor=eyJpZCI6MTAwfQ&size=20
```

## 요청/응답 패턴

```java
// Request: @Valid 사용, Records
public record CreateTimetableRequest(
    @NotBlank(message = "시간표 이름은 필수입니다") String name
) {}

// Response: Records, 필요한 필드만
public record TimetableResponse(
    Long id,
    String name,
    LocalDateTime createdAt
) {
    public static TimetableResponse from(Timetable timetable) {
        return new TimetableResponse(
            timetable.getId(),
            timetable.getName(),
            timetable.getCreatedAt()
        );
    }
}
```

## 인증 헤더 (Gateway 주입)

```java
// Controller 파라미터로 수신
@GetMapping("/timetables")
public List<TimetableResponse> list(
    @RequestHeader("X-User-Id") Long userId,
    @RequestHeader("X-User-Email") String userEmail
) { ... }
```

인증 불필요 경로: `/api/v1/auth/**`, `/api/v1/universities/**`

## Swagger 애노테이션

```java
@Operation(summary = "시간표 생성", description = "새 시간표를 생성합니다")
@ApiResponses({
    @ApiResponse(responseCode = "201", description = "생성 성공"),
    @ApiResponse(responseCode = "400", description = "잘못된 요청"),
    @ApiResponse(responseCode = "401", description = "인증 필요")
})
```
