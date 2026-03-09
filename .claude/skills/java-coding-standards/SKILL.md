# Java 코딩 표준 (UniPlan)

code-reviewer agent와 code-review-criteria skill이 참조하는 Java 21+ 코딩 규칙.

## Records 우선 사용 (불변 DTO)

```java
// ✅ Records (Java 16+)
public record CreateTimetableRequest(
    @NotBlank String name
) {}

public record TimetableResponse(
    Long id,
    String name,
    LocalDateTime createdAt
) {}

// ❌ 피해야 할 패턴
public class TimetableResponse {
    private Long id;
    // getter/setter...
}
```

Records를 우선 사용. 변경 가능한 상태가 필요할 때만 class 사용.

## Optional 사용 규칙

```java
// ✅ map/flatMap/orElseThrow 사용
return timetableRepository.findById(id)
    .map(TimetableResponse::from)
    .orElseThrow(() -> new TimetableNotFoundException(id));

// ❌ 금지: isPresent() + get() 패턴
Optional<Timetable> opt = timetableRepository.findById(id);
if (opt.isPresent()) {
    return opt.get(); // NPE 가능성 없애는 목적 무효화
}
```

`Optional.get()` 직접 호출 금지. 항상 `orElse`, `orElseThrow`, `map` 사용.

## Stream API 사용 기준

```java
// ✅ 단순 변환 - Stream OK
List<TimetableResponse> responses = timetables.stream()
    .map(TimetableResponse::from)
    .toList();

// ✅ 복잡한 누적 로직 - 일반 loop 권장 (가독성)
List<ConflictInfo> conflicts = new ArrayList<>();
for (TimetableItem item : items) {
    for (TimetableItem other : items) {
        if (item.conflicts(other)) {
            conflicts.add(new ConflictInfo(item, other));
        }
    }
}

// ❌ 중첩 flatMap 과용 (가독성 저하)
items.stream().flatMap(i -> items.stream().filter(o -> i.conflicts(o)).map(...))
```

## 예외 처리

```java
// ✅ 도메인별 unchecked exception
public class TimetableNotFoundException extends RuntimeException {
    public TimetableNotFoundException(Long id) {
        super("시간표를 찾을 수 없습니다. id: " + id);
    }
}

// ✅ GlobalExceptionHandler에 등록
@ExceptionHandler(TimetableNotFoundException.class)
public ResponseEntity<ErrorResponse> handle(TimetableNotFoundException e) {
    return ResponseEntity.status(404)
        .body(new ErrorResponse(404, e.getMessage()));
}
```

## 패키지 구조

```
{service}/
├── config/        # Spring 설정
├── controller/    # REST Controller (@RestController)
├── service/       # 비즈니스 로직 (@Service)
├── repository/    # JPA Repository
├── domain/        # Entity (@Entity)
├── dto/           # Request/Response Records
└── exception/     # Custom Exceptions
```

## 함수/클래스 크기 기준

| 대상 | 기준 | 조치 |
|------|------|------|
| 메서드 길이 | 50줄 이하 | 초과 시 Extract Method |
| 클래스 길이 | 300줄 이하 | 초과 시 분리 검토 |
| 중첩 깊이 | 4레벨 이하 | 초과 시 Early Return 또는 추출 |
| 파라미터 수 | 4개 이하 | 초과 시 Request 객체로 묶기 |

## UniPlan 특화 규칙

- `X-User-Id`, `X-User-Email` 헤더를 직접 파싱하지 말 것 — Controller 파라미터로 주입
- Gateway가 검증한 헤더는 신뢰, 재검증 불필요
- `@RequestHeader("X-User-Id") Long userId` 패턴 사용

## 코드 냄새 체크리스트

- [ ] `null` 반환 (Optional 또는 예외로 대체)
- [ ] `instanceof` 연쇄 (다형성으로 대체)
- [ ] 긴 메서드 체인 (중간 변수로 분리)
- [ ] 매직 넘버/문자열 (상수로 추출)
- [ ] 빈 catch 블록 (로깅 또는 예외 재throw)
