# Spring Boot TDD 패턴

UniPlan Spring Boot 프로젝트의 테스트 레이어별 패턴 및 예시.
tdd-guide agent가 참조하여 테스트를 작성한다.

## 테스트 레이어 구조

| 레이어 | 위치 | 목적 | 속도 |
|--------|------|------|------|
| Unit | `src/test/java/{service}/unit/` | 비즈니스 로직 단독 검증 | 빠름 |
| Component | `src/test/java/{service}/component/` | Controller+Service+DB 통합 | 중간 |
| Contract | `src/test/java/{service}/contract/` | 외부 API 클라이언트 | 중간 |
| Integration | `tests/integration/test_*.py` | API 레벨 End-to-end | 느림 |

## Unit 테스트 (JUnit5 + Mockito)

```java
@ExtendWith(MockitoExtension.class)
class TimetableServiceTest {

    @InjectMocks
    private TimetableService timetableService;

    @Mock
    private TimetableRepository timetableRepository;

    @Test
    void 시간표_생성_성공() {
        // given
        Long userId = 1L;
        CreateTimetableRequest request = new CreateTimetableRequest("2024-1학기");
        Timetable savedTimetable = new Timetable(1L, userId, "2024-1학기");
        given(timetableRepository.save(any())).willReturn(savedTimetable);

        // when
        TimetableResponse result = timetableService.create(userId, request);

        // then
        assertThat(result.id()).isEqualTo(1L);
        assertThat(result.name()).isEqualTo("2024-1학기");
    }

    @ParameterizedTest
    @ValueSource(strings = {"", " ", "  "})
    void 빈_이름으로_시간표_생성_시_예외(String blankName) {
        CreateTimetableRequest request = new CreateTimetableRequest(blankName);
        assertThatThrownBy(() -> timetableService.create(1L, request))
            .isInstanceOf(IllegalArgumentException.class);
    }
}
```

**규칙:**
- `@ExtendWith(MockitoExtension.class)` 필수
- given/when/then 구조 엄수
- `assertThat` (AssertJ) 사용 — `assertEquals` 금지
- `@ParameterizedTest`로 경계값 테스트

## Component 테스트 (MockMvc + TestContainers)

```java
@ExtendWith(DockerRequiredExtension.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class TimetableControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private TimetableRepository timetableRepository;

    @BeforeEach
    void setUp() {
        timetableRepository.deleteAll(); // 격리 보장
    }

    @Test
    void 시간표_생성_API_201_반환() throws Exception {
        mockMvc.perform(post("/timetables")
                .header("X-User-Id", "1")
                .header("X-User-Email", "test@test.com")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {"name": "2024-1학기"}
                    """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.id").isNumber())
            .andExpect(jsonPath("$.name").value("2024-1학기"));
    }

    @Test
    void 인증_헤더_없이_요청_시_401() throws Exception {
        mockMvc.perform(post("/timetables")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""{"name": "test"}"""))
            .andExpect(status().isUnauthorized());
    }
}
```

**규칙:**
- `@ExtendWith(DockerRequiredExtension.class)` 필수 (Docker 미실행 시 skip)
- `@BeforeEach deleteAll()` — 테스트 격리 보장
- `X-User-Id`, `X-User-Email` 헤더 포함 (Gateway 시뮬레이션)
- `jsonPath()` 또는 `andExpectAll()` 사용

## Contract 테스트 (WireMock)

```java
@ExtendWith(WireMockExtension.class)
class CatalogClientTest {

    @Test
    void 외부_카탈로그_API_호출_성공() {
        // WireMock stubbing
        stubFor(get(urlEqualTo("/courses/1"))
            .willReturn(aResponse()
                .withStatus(200)
                .withBody("""{"id": 1, "name": "자료구조"}""")));

        CourseResponse result = catalogClient.getCourse(1L);

        assertThat(result.name()).isEqualTo("자료구조");
    }
}
```

## Integration 테스트 (pytest)

```python
def test_시간표_생성_성공(auth_client):
    response = auth_client.post("/api/v1/timetables", json={"name": "2024-1학기"})
    assert response.status_code == 201
    data = response.json()
    assert "id" in data
    assert isinstance(data["id"], int)
    assert data["name"] == "2024-1학기"

def test_비인증_시간표_접근_401(client):
    response = client.get("/api/v1/timetables")
    assert response.status_code == 401
```

**규칙:**
- `auth_client` fixture 사용 (인증된 클라이언트)
- `pytest.skip` 절대 금지
- 단일 상태 코드 검증 (`assert response.status_code == 201`)
- DTO 필드 완전 검증

## 테스트 데이터 빌더 패턴

```java
// Builder 패턴으로 테스트 데이터 생성
class TimetableTestBuilder {
    private Long userId = 1L;
    private String name = "테스트 시간표";

    public TimetableTestBuilder withUserId(Long userId) {
        this.userId = userId;
        return this;
    }

    public Timetable build() {
        return new Timetable(null, userId, name);
    }
}
```

## 소스 → 테스트 매핑

| 변경 파일 | 테스트 파일 |
|----------|------------|
| `*Service.java` | `unit/*ServiceTest.java` |
| `*Controller.java` | `component/*Test.java` |
| `*Client.java` | `contract/*ContractTest.java` |
| API 엔드포인트 | `tests/integration/test_*.py` |

## DockerRequiredExtension 동작

Docker가 실행 중이 아닌 경우 Component 테스트를 자동으로 skip.
로컬 환경에서 Docker 없이 Unit 테스트만 실행 가능.
