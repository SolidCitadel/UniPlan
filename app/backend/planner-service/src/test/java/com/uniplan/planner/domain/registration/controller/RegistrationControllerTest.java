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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
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

    private static final Long TEST_USER_ID = 1L;

    @BeforeEach
    void setUp() {
        registrationStepRepository.deleteAll();
        registrationRepository.deleteAll();
        scenarioRepository.deleteAll();
        timetableItemRepository.deleteAll();
        timetableRepository.deleteAll();
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
        mockMvc.perform(delete("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNoContent());

        // 취소 확인
        mockMvc.perform(get("/registrations/" + registrationId)
                        .header("X-User-Id", TEST_USER_ID))
                .andExpect(jsonPath("$.status").value("CANCELLED"));
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