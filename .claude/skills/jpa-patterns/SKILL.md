# JPA 패턴 (UniPlan)

code-reviewer agent가 참조하는 JPA/Hibernate 사용 패턴 및 안티패턴.

## Lazy Loading (기본 원칙)

```java
// ✅ 기본: LAZY (N+1 문제 방지)
@OneToMany(mappedBy = "timetable", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
private List<TimetableItem> items = new ArrayList<>();

// ✅ 필요 시 JOIN FETCH (N+1 해결)
@Query("SELECT t FROM Timetable t LEFT JOIN FETCH t.items WHERE t.userId = :userId")
List<Timetable> findByUserIdWithItems(@Param("userId") Long userId);

// ❌ 안티패턴: EAGER Loading
@OneToMany(fetch = FetchType.EAGER) // 항상 join → 성능 저하
```

## DTO Projection (읽기 최적화)

```java
// ✅ DTO Projection — 필요한 필드만 조회
public interface TimetableSummary {
    Long getId();
    String getName();
    Long getItemCount();
}

@Query("SELECT t.id as id, t.name as name, COUNT(i) as itemCount " +
       "FROM Timetable t LEFT JOIN t.items i WHERE t.userId = :userId GROUP BY t.id, t.name")
List<TimetableSummary> findSummaryByUserId(@Param("userId") Long userId);

// ❌ 안티패턴: Entity 전체 조회 후 필드 추출
timetableRepository.findAll().stream().map(t -> t.getName()).toList();
```

## @Transactional 규칙

```java
// ✅ 읽기 전용 쿼리에 readOnly=true
@Transactional(readOnly = true)
public TimetableResponse findById(Long id) {
    return timetableRepository.findById(id)
        .map(TimetableResponse::from)
        .orElseThrow(() -> new TimetableNotFoundException(id));
}

// ✅ 쓰기 작업에는 기본 트랜잭션
@Transactional
public TimetableResponse create(Long userId, CreateTimetableRequest request) {
    Timetable timetable = new Timetable(userId, request.name());
    return TimetableResponse.from(timetableRepository.save(timetable));
}
```

## Entity 설계 원칙

```java
@Entity
@Table(name = "timetables")
public class Timetable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false, length = 100)
    private String name;

    @OneToMany(mappedBy = "timetable", cascade = CascadeType.ALL, orphanRemoval = true)
    private final List<TimetableItem> items = new ArrayList<>();

    // ✅ 비즈니스 메서드 포함 (도메인 로직)
    public void addItem(TimetableItem item) {
        validateNoConflict(item);
        items.add(item);
        item.setTimetable(this);
    }

    private void validateNoConflict(TimetableItem newItem) {
        boolean hasConflict = items.stream().anyMatch(existing -> existing.conflicts(newItem));
        if (hasConflict) {
            throw new TimeConflictException("시간 충돌이 발생합니다.");
        }
    }
}
```

## 테스트 (Testcontainers)

```java
@DataJpaTest
@ExtendWith(DockerRequiredExtension.class)
class TimetableRepositoryTest {

    @Autowired
    private TimetableRepository timetableRepository;

    @Test
    void 사용자별_시간표_조회() {
        Timetable timetable = new Timetable(1L, "2024-1학기");
        timetableRepository.save(timetable);

        List<Timetable> result = timetableRepository.findByUserId(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo("2024-1학기");
    }
}
```

## HikariCP 설정 (application.yml)

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20
      minimum-idle: 5
      connection-timeout: 30000
      idle-timeout: 600000
```

## N+1 문제 감지 방법

```yaml
# application-local.yml (개발 환경)
spring:
  jpa:
    properties:
      hibernate:
        generate_statistics: true
logging:
  level:
    org.hibernate.SQL: DEBUG
    org.hibernate.orm.jdbc.bind: TRACE
```

반복되는 동일 쿼리 → N+1 → `JOIN FETCH` 또는 `@BatchSize` 적용
