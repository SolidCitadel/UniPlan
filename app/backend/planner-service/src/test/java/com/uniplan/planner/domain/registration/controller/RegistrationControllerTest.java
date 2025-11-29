package com.uniplan.planner.domain.registration.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.planner.domain.registration.dto.AddStepRequest;
import com.uniplan.planner.domain.registration.dto.StartRegistrationRequest;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.registration.repository.RegistrationStepRepository;
import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.repository.TimetableItemRepository;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Map;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class RegistrationControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private RegistrationRepository registrationRepository;

    @Autowired
    private RegistrationStepRepository registrationStepRepository;

    @Autowired
    private ScenarioRepository scenarioRepository;

    @Autowired
    private TimetableRepository timetableRepository;

    @Autowired
    private TimetableItemRepository timetableItemRepository;

    @MockBean
    private CatalogClient catalogClient;

    private static final Long TEST_USER_ID = 1L;

    @BeforeEach
    void setUp() {
        registrationStepRepository.deleteAll();
        registrationRepository.deleteAll();
        scenarioRepository.deleteAll();
        timetableItemRepository.deleteAll();
        timetableRepository.deleteAll();

        // Mock CatalogClient to return course details for any courseId
        given(catalogClient.getFullCoursesByIds(anyList())).willAnswer(invocation -> {
            List<Long> courseIds = invocation.getArgument(0);
            Map<Long, CourseFullResponse> result = new java.util.HashMap<>();
            for (Long courseId : courseIds) {
                result.put(courseId, createMockCourse(courseId));
            }
            return result;
        });
    }

    private CourseFullResponse createMockCourse(Long courseId) {
        return CourseFullResponse.builder()
                .id(courseId)
                .courseCode("TEST" + courseId)
                .courseName("Test Course " + courseId)
                .professor("Test Professor")
                .credits(3)
                .classroom("Test Room")
                .campus("Test Campus")
                .classTimes(List.of())
                .build();
    }

    @Test
    @DisplayName("수강신청 시작")
    void startRegistration() throws Exception {
        // Given: 시나리오 생성
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");

        StartRegistrationRequest request = StartRegistrationRequest.builder()
                .scenarioId(planA.getId())
                .build();

        // When & Then
        mockMvc.perform(post("/registrations")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$.startScenario.id").value(planA.getId()))
                .andExpect(jsonPath("$.currentScenario.id").value(planA.getId()))
                .andExpect(jsonPath("$.status").value("IN_PROGRESS"))
                .andExpect(jsonPath("$.succeededCourses").isEmpty())
                .andExpect(jsonPath("$.failedCourses").isEmpty())
                .andExpect(jsonPath("$.steps").isEmpty());
    }

    @Test
    @DisplayName("단계 추가 - 모두 성공 (네비게이션 없음)")
    void addStep_allSuccess() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        AddStepRequest request = AddStepRequest.builder()
                .succeededCourses(List.of(101L, 102L))
                .failedCourses(List.of())
                .canceledCourses(List.of())
                .notes("모두 성공")
                .build();

        // When & Then: 현재 시나리오 유지
        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.currentScenario.id").value(planA.getId()))
                .andExpect(jsonPath("$.succeededCourses", hasSize(2)))
                .andExpect(jsonPath("$.failedCourses").isEmpty())
                .andExpect(jsonPath("$.steps", hasSize(1)))
                .andExpect(jsonPath("$.steps[0].succeededCourses", hasSize(2)))
                .andExpect(jsonPath("$.steps[0].failedCourses").isEmpty())
                .andExpect(jsonPath("$.steps[0].nextScenarioId").doesNotExist());
    }

    @Test
    @DisplayName("단계 추가 - 실패 발생 (자동 네비게이션)")
    void addStep_withFailure_autoNavigation() throws Exception {
        // Given: Plan A → Plan B (CS101 실패 시)
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Scenario planB = createAlternativeScenario(TEST_USER_ID, "Plan B", planA, 101L);

        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        AddStepRequest request = AddStepRequest.builder()
                .succeededCourses(List.of(102L))
                .failedCourses(List.of(101L))  // CS101 실패
                .canceledCourses(List.of())
                .notes("CS101 실패")
                .build();

        // When & Then: Plan B로 자동 네비게이션
        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.currentScenario.id").value(planB.getId()))
                .andExpect(jsonPath("$.currentScenario.name").value("Plan B"))
                .andExpect(jsonPath("$.succeededCourses", hasSize(1)))
                .andExpect(jsonPath("$.failedCourses", hasSize(1)))
                .andExpect(jsonPath("$.steps[0].scenarioId").value(planA.getId()))
                .andExpect(jsonPath("$.steps[0].nextScenarioId").value(planB.getId()));
    }

    @Test
    @DisplayName("복잡한 네비게이션 시나리오")
    void complexNavigationScenario() throws Exception {
        // Given: 트리 구조
        //   Plan A
        //   ├─ Plan B (CS101 실패)
        //   │   └─ Plan B-1 (CS104 실패)
        //   └─ Plan C (CS102 실패)
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Scenario planB = createAlternativeScenario(TEST_USER_ID, "Plan B", planA, 101L);
        Scenario planB1 = createAlternativeScenario(TEST_USER_ID, "Plan B-1", planB, 104L);
        Scenario planC = createAlternativeScenario(TEST_USER_ID, "Plan C", planA, 102L);

        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // Step 1: CS101 실패 → Plan B로 이동
        AddStepRequest step1 = AddStepRequest.builder()
                .succeededCourses(List.of(102L, 103L))
                .failedCourses(List.of(101L))
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(step1)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.currentScenario.id").value(planB.getId()));

        // Step 2: CS104 실패 → Plan B-1로 이동
        AddStepRequest step2 = AddStepRequest.builder()
                .succeededCourses(List.of())
                .failedCourses(List.of(104L))
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(step2)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.currentScenario.id").value(planB1.getId()))
                .andExpect(jsonPath("$.steps", hasSize(2)));
    }

    @Test
    @DisplayName("누적 실패 과목 전송 시 새로 실패한 과목만 추출하여 네비게이션")
    void addStep_accumulatedFailures_shouldExtractNewlyFailed() throws Exception {
        // Given: 트리 구조
        //   Plan A
        //   ├─ Plan B (CS101 실패)
        //   │   └─ Plan B-1 (CS102 실패)
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Scenario planB = createAlternativeScenario(TEST_USER_ID, "Plan B", planA, 101L);
        Scenario planB1 = createAlternativeScenario(TEST_USER_ID, "Plan B-1", planB, 102L);

        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // Step 1: CS101 실패 → Plan B로 이동
        AddStepRequest step1 = AddStepRequest.builder()
                .succeededCourses(List.of(103L))
                .failedCourses(List.of(101L))  // 101 실패
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(step1)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.currentScenario.id").value(planB.getId()))
                .andExpect(jsonPath("$.steps[0].nextScenarioId").value(planB.getId()))
                .andExpect(jsonPath("$.failedCourses", hasSize(1)))
                .andExpect(jsonPath("$.failedCourses[0]").value(101L));

        // Step 2: 프론트엔드가 누적 실패 과목 [101, 102]를 전송
        // 백엔드는 새로 실패한 102만 추출하여 Plan B-1로 네비게이션
        AddStepRequest step2 = AddStepRequest.builder()
                .succeededCourses(List.of(103L))
                .failedCourses(List.of(101L, 102L))  // 누적: [101, 102]
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(step2)))
                .andDo(print())
                .andExpect(status().isCreated())
                // 새로 실패한 102에 대한 대안 시나리오인 Plan B-1로 이동
                .andExpect(jsonPath("$.currentScenario.id").value(planB1.getId()))
                .andExpect(jsonPath("$.currentScenario.name").value("Plan B-1"))
                // Step 2의 nextScenarioId가 Plan B-1이어야 함
                .andExpect(jsonPath("$.steps[1].nextScenarioId").value(planB1.getId()))
                .andExpect(jsonPath("$.failedCourses", hasSize(2)))
                .andExpect(jsonPath("$.steps", hasSize(2)));
    }

    @Test
    @DisplayName("이미 실패한 과목만 재전송 시 네비게이션 없음")
    void addStep_onlyPreviouslyFailedCourses_shouldNotNavigate() throws Exception {
        // Given: 트리 구조
        //   Plan A
        //   └─ Plan B (CS101 실패)
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Scenario planB = createAlternativeScenario(TEST_USER_ID, "Plan B", planA, 101L);

        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // Step 1: CS101 실패 → Plan B로 이동
        AddStepRequest step1 = AddStepRequest.builder()
                .succeededCourses(List.of(102L))
                .failedCourses(List.of(101L))
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(step1)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.currentScenario.id").value(planB.getId()));

        // Step 2: 이미 실패한 CS101만 다시 전송 (새로운 실패 없음)
        // 백엔드는 newlyFailed가 비어있으므로 네비게이션하지 않음
        AddStepRequest step2 = AddStepRequest.builder()
                .succeededCourses(List.of(102L, 103L))
                .failedCourses(List.of(101L))  // 이미 step1에서 실패한 과목
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(step2)))
                .andDo(print())
                .andExpect(status().isCreated())
                // 새로운 실패가 없으므로 Plan B에 그대로 유지
                .andExpect(jsonPath("$.currentScenario.id").value(planB.getId()))
                // Step 2의 nextScenarioId는 null (네비게이션 없음)
                .andExpect(jsonPath("$.steps[1].nextScenarioId").doesNotExist())
                .andExpect(jsonPath("$.steps", hasSize(2)));
    }

    @Test
    @DisplayName("수강신청 완료")
    void completeRegistration() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // When & Then
        mockMvc.perform(post("/registrations/" + registrationId + "/complete")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("COMPLETED"))
                .andExpect(jsonPath("$.completedAt").exists());
    }

    @Test
    @DisplayName("수강신청 취소")
    void cancelRegistration() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // When & Then
        mockMvc.perform(post("/registrations/" + registrationId + "/cancel")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk());

        // 취소 확인
        mockMvc.perform(get("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andExpect(jsonPath("$.status").value("CANCELLED"));
    }

    @Test
    @DisplayName("수강신청 삭제")
    void deleteRegistration() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // When & Then
        mockMvc.perform(delete("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNoContent());

        // 삭제 확인 - 404 Not Found
        mockMvc.perform(get("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("성공한 과목 목록 조회")
    void getAllSucceededCourses() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // Step 1: 101, 102 성공
        AddStepRequest step1 = AddStepRequest.builder()
                .succeededCourses(List.of(101L, 102L))
                .failedCourses(List.of())
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(step1)));

        // Step 2: 103, 104 성공
        AddStepRequest step2 = AddStepRequest.builder()
                .succeededCourses(List.of(103L, 104L))
                .failedCourses(List.of())
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(step2)));

        // When & Then: 총 4개 과목 성공
        mockMvc.perform(get("/registrations/" + registrationId + "/succeeded-courses")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(4)));
    }

    @Test
    @DisplayName("상태별 수강신청 목록 조회")
    void getUserRegistrationsByStatus() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        startTestRegistration(TEST_USER_ID, planA.getId());  // IN_PROGRESS

        // When & Then
        mockMvc.perform(get("/registrations")
                        .header("X-User-Id", TEST_USER_ID)
                        .param("status", "IN_PROGRESS"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    @DisplayName("과목 취소 처리")
    void cancelCourses() throws Exception {
        // Given
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // Step 1: 101, 102, 103 성공
        AddStepRequest step1 = AddStepRequest.builder()
                .succeededCourses(List.of(101L, 102L, 103L))
                .failedCourses(List.of())
                .canceledCourses(List.of())
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(step1)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.succeededCourses", hasSize(3)))
                .andExpect(jsonPath("$.canceledCourses").isEmpty());

        // Step 2: 102 취소
        AddStepRequest step2 = AddStepRequest.builder()
                .succeededCourses(List.of())
                .failedCourses(List.of())
                .canceledCourses(List.of(102L))
                .build();

        mockMvc.perform(post("/registrations/" + registrationId + "/steps")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(step2)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.succeededCourses", hasSize(2)))  // 101, 103만 남음
                .andExpect(jsonPath("$.canceledCourses", hasSize(1)))
                .andExpect(jsonPath("$.canceledCourses[0]").value(102L))
                .andExpect(jsonPath("$.steps", hasSize(2)))
                .andExpect(jsonPath("$.steps[1].canceledCourses", hasSize(1)))
                .andExpect(jsonPath("$.steps[1].canceledCourses[0]").value(102L));
    }

    @Test
    @DisplayName("childScenarios의 과목 정보도 정상 조회")
    void getRegistration_withChildScenarios_shouldIncludeAllCourseDetails() throws Exception {
        // Given: 시나리오 트리 생성 (Plan A -> Plan B)
        // Plan A: courseId 101, 102
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        addCourseToScenario(planA, 101L);
        addCourseToScenario(planA, 102L);

        // Plan B (child of Plan A): courseId 103, 104
        Scenario planB = createAlternativeScenario(TEST_USER_ID, "Plan B", planA, 101L);
        addCourseToScenario(planB, 103L);
        addCourseToScenario(planB, 104L);

        // Registration 시작
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // When & Then: Registration 조회 시 childScenarios의 과목 정보도 포함되어야 함
        mockMvc.perform(get("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(registrationId))
                .andExpect(jsonPath("$.startScenario.timetable.items", hasSize(2)))
                // Plan A의 과목들이 courseCode, courseName 등 상세 정보 포함
                .andExpect(jsonPath("$.startScenario.timetable.items[0].courseId").exists())
                .andExpect(jsonPath("$.startScenario.timetable.items[0].courseCode").exists())
                .andExpect(jsonPath("$.startScenario.timetable.items[0].courseName").exists())
                // childScenarios도 존재
                .andExpect(jsonPath("$.startScenario.childScenarios", hasSize(1)))
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items", hasSize(2)))
                // childScenarios의 과목들도 상세 정보 포함 (null이 아님)
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[0].courseId").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[0].courseCode").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[0].courseName").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[1].courseId").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[1].courseCode").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[1].courseName").exists());
    }

    @Test
    @DisplayName("깊은 시나리오 트리의 모든 과목 정보 조회")
    void getRegistration_withDeepScenarioTree_shouldIncludeAllCourseDetails() throws Exception {
        // Given: 3단계 시나리오 트리 (Plan A -> Plan B -> Plan C)
        // Plan A: courseId 101
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A");
        addCourseToScenario(planA, 101L);

        // Plan B (child of Plan A): courseId 102
        Scenario planB = createAlternativeScenario(TEST_USER_ID, "Plan B", planA, 101L);
        addCourseToScenario(planB, 102L);

        // Plan C (child of Plan B): courseId 103
        Scenario planC = createAlternativeScenario(TEST_USER_ID, "Plan C", planB, 102L);
        addCourseToScenario(planC, 103L);

        // Registration 시작
        Long registrationId = startTestRegistration(TEST_USER_ID, planA.getId());

        // When & Then: 모든 깊이의 시나리오에서 과목 정보가 제대로 조회되어야 함
        mockMvc.perform(get("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                // Plan A의 과목 정보
                .andExpect(jsonPath("$.startScenario.timetable.items[0].courseCode").exists())
                .andExpect(jsonPath("$.startScenario.timetable.items[0].courseName").exists())
                // Plan B (1단계 child)의 과목 정보
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[0].courseCode").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].timetable.items[0].courseName").exists())
                // Plan C (2단계 child)의 과목 정보
                .andExpect(jsonPath("$.startScenario.childScenarios[0].childScenarios[0].timetable.items[0].courseCode").exists())
                .andExpect(jsonPath("$.startScenario.childScenarios[0].childScenarios[0].timetable.items[0].courseName").exists());
    }

    // Helper methods
    private Scenario createTestScenario(Long userId, String name) {
        Timetable timetable = Timetable.builder()
                .userId(userId)
                .name(name + " 시간표")
                .openingYear(2025)
                .semester("1학기")
                .build();
        timetable = timetableRepository.save(timetable);

        Scenario scenario = Scenario.builder()
                .userId(userId)
                .name(name)
                .timetable(timetable)
                .build();
        return scenarioRepository.save(scenario);
    }

    private Scenario createAlternativeScenario(Long userId, String name, Scenario parent, Long failedCourseId) {
        Timetable timetable = Timetable.builder()
                .userId(userId)
                .name(name + " 시간표")
                .openingYear(2025)
                .semester("1학기")
                .build();
        timetable = timetableRepository.save(timetable);

        Scenario scenario = Scenario.builder()
                .userId(userId)
                .name(name)
                .timetable(timetable)
                .parentScenario(parent)
                .failedCourseIds(java.util.Set.of(failedCourseId))
                .build();
        return scenarioRepository.save(scenario);
    }

    private void addCourseToScenario(Scenario scenario, Long courseId) {
        com.uniplan.planner.domain.timetable.entity.TimetableItem item =
            com.uniplan.planner.domain.timetable.entity.TimetableItem.builder()
                .timetable(scenario.getTimetable())
                .courseId(courseId)
                .build();
        timetableItemRepository.save(item);
    }

    private Long startTestRegistration(Long userId, Long scenarioId) {
        try {
            String response = mockMvc.perform(post("/registrations")
                            .header("X-User-Id", userId)
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(
                                    StartRegistrationRequest.builder().scenarioId(scenarioId).build())))
                    .andReturn().getResponse().getContentAsString();

            return objectMapper.readTree(response).get("id").asLong();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}