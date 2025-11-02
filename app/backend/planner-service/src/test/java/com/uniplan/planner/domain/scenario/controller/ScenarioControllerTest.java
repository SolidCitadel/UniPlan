package com.uniplan.planner.domain.scenario.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.registration.repository.RegistrationStepRepository;
import com.uniplan.planner.domain.scenario.dto.*;
import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.timetable.dto.CreateTimetableRequest;
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

import java.util.Set;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class ScenarioControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ScenarioRepository scenarioRepository;

    @Autowired
    private TimetableRepository timetableRepository;

    @Autowired
    private TimetableItemRepository timetableItemRepository;

    @Autowired
    private RegistrationRepository registrationRepository;

    @Autowired
    private RegistrationStepRepository registrationStepRepository;

    private static final Long TEST_USER_ID = 1L;
    private static final Long OTHER_USER_ID = 2L;

    @BeforeEach
    void setUp() {
        registrationStepRepository.deleteAll();
        registrationRepository.deleteAll();
        scenarioRepository.deleteAll();
        timetableItemRepository.deleteAll();
        timetableRepository.deleteAll();
    }

    @Test
    @DisplayName("루트 시나리오 생성")
    void createRootScenario() throws Exception {
        CreateTimetableRequest timetableRequest = CreateTimetableRequest.builder()
                .name("2025-1학기 기본 시간표")
                .openingYear(2025)
                .semester("1학기")
                .build();

        CreateScenarioRequest request = CreateScenarioRequest.builder()
                .name("Plan A - 기본 계획")
                .description("1지망 강의들로 구성된 기본 계획")
                .timetableRequest(timetableRequest)
                .build();

        mockMvc.perform(post("/scenarios")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$.name").value("Plan A - 기본 계획"))
                .andExpect(jsonPath("$.description").value("1지망 강의들로 구성된 기본 계획"))
                .andExpect(jsonPath("$.parentScenarioId").doesNotExist())
                .andExpect(jsonPath("$.failedCourseIds").isEmpty())
                .andExpect(jsonPath("$.timetable").exists())
                .andExpect(jsonPath("$.timetable.name").value("2025-1학기 기본 시간표"));
    }

    @Test
    @DisplayName("대안 시나리오 생성")
    void createAlternativeScenario() throws Exception {
        // Given: 부모 시나리오 생성
        Scenario parentScenario = createTestScenario(TEST_USER_ID, "Plan A", null, Set.of());

        CreateTimetableRequest timetableRequest = CreateTimetableRequest.builder()
                .name("2025-1학기 대안 시간표")
                .openingYear(2025)
                .semester("1학기")
                .build();

        CreateAlternativeScenarioRequest request = CreateAlternativeScenarioRequest.builder()
                .name("Plan B - CS101 실패 시")
                .description("CS101 수강신청 실패 시 대안")
                .failedCourseIds(Set.of(101L))
                .timetableRequest(timetableRequest)
                .orderIndex(1)
                .build();

        // When & Then
        mockMvc.perform(post("/scenarios/" + parentScenario.getId() + "/alternatives")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.name").value("Plan B - CS101 실패 시"))
                .andExpect(jsonPath("$.parentScenarioId").value(parentScenario.getId()))
                .andExpect(jsonPath("$.failedCourseIds", hasSize(1)))
                .andExpect(jsonPath("$.orderIndex").value(1));
    }

    @Test
    @DisplayName("루트 시나리오 목록 조회")
    void getRootScenarios() throws Exception {
        // Given
        createTestScenario(TEST_USER_ID, "Plan A", null, Set.of());
        createTestScenario(TEST_USER_ID, "Plan X", null, Set.of());
        createTestScenario(OTHER_USER_ID, "다른 사용자 시나리오", null, Set.of());

        // When & Then
        mockMvc.perform(get("/scenarios")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$[1].userId").value(TEST_USER_ID));
    }

    @Test
    @DisplayName("시나리오 상세 조회")
    void getScenario() throws Exception {
        // Given
        Scenario scenario = createTestScenario(TEST_USER_ID, "Plan A", null, Set.of());

        // When & Then
        mockMvc.perform(get("/scenarios/" + scenario.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(scenario.getId()))
                .andExpect(jsonPath("$.name").value("Plan A"))
                .andExpect(jsonPath("$.timetable").exists());
    }

    @Test
    @DisplayName("시나리오 트리 전체 조회")
    void getScenarioWithFullTree() throws Exception {
        // Given: 트리 구조 생성
        //   Root
        //   ├─ Child 1 (CS101 fail)
        //   └─ Child 2 (CS102 fail)
        Scenario root = createTestScenario(TEST_USER_ID, "Root", null, Set.of());
        createTestScenario(TEST_USER_ID, "Child 1", root, Set.of(101L));
        createTestScenario(TEST_USER_ID, "Child 2", root, Set.of(102L));

        // When & Then
        mockMvc.perform(get("/scenarios/" + root.getId() + "/tree")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(root.getId()))
                .andExpect(jsonPath("$.name").value("Root"))
                .andExpect(jsonPath("$.childScenarios", hasSize(2)));
    }

    @Test
    @DisplayName("시나리오 정보 수정")
    void updateScenario() throws Exception {
        // Given
        Scenario scenario = createTestScenario(TEST_USER_ID, "원래 이름", null, Set.of());

        UpdateScenarioRequest request = UpdateScenarioRequest.builder()
                .name("수정된 이름")
                .description("수정된 설명")
                .build();

        // When & Then
        mockMvc.perform(put("/scenarios/" + scenario.getId())
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(scenario.getId()))
                .andExpect(jsonPath("$.name").value("수정된 이름"))
                .andExpect(jsonPath("$.description").value("수정된 설명"));
    }

    @Test
    @DisplayName("시나리오 삭제")
    void deleteScenario() throws Exception {
        // Given
        Scenario scenario = createTestScenario(TEST_USER_ID, "삭제할 시나리오", null, Set.of());

        // When & Then
        mockMvc.perform(delete("/scenarios/" + scenario.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNoContent());

        // 삭제 확인
        mockMvc.perform(get("/scenarios/" + scenario.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("실시간 네비게이션 - 강의 실패 시 대안 시나리오 찾기")
    void navigate() throws Exception {
        // Given: 트리 구조
        //   Plan A
        //   ├─ Plan B (CS101 fail)
        //   └─ Plan C (CS102 fail)
        Scenario planA = createTestScenario(TEST_USER_ID, "Plan A", null, Set.of());
        Scenario planB = createTestScenario(TEST_USER_ID, "Plan B", planA, Set.of(101L));
        createTestScenario(TEST_USER_ID, "Plan C", planA, Set.of(102L));

        NavigationRequest request = NavigationRequest.builder()
                .failedCourseIds(Set.of(101L))
                .build();

        // When & Then: CS101 실패 시 Plan B로 이동
        mockMvc.perform(post("/scenarios/" + planA.getId() + "/navigate")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(planB.getId()))
                .andExpect(jsonPath("$.name").value("Plan B"))
                .andExpect(jsonPath("$.failedCourseIds", hasSize(1)));
    }

    @Test
    @DisplayName("자식 시나리오 목록 조회")
    void getChildScenarios() throws Exception {
        // Given
        Scenario parent = createTestScenario(TEST_USER_ID, "Parent", null, Set.of());
        createTestScenario(TEST_USER_ID, "Child 1", parent, Set.of(101L));
        createTestScenario(TEST_USER_ID, "Child 2", parent, Set.of(102L));

        // When & Then
        mockMvc.perform(get("/scenarios/" + parent.getId() + "/children")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)));
    }

    @Test
    @DisplayName("다른 사용자의 시나리오 접근 차단")
    void accessOtherUserScenario() throws Exception {
        // Given: 다른 사용자의 시나리오
        Scenario otherScenario = createTestScenario(OTHER_USER_ID, "다른 사용자 시나리오", null, Set.of());

        // When & Then: 접근 시도 -> 404
        mockMvc.perform(get("/scenarios/" + otherScenario.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNotFound());
    }

    // Helper methods
    private Scenario createTestScenario(Long userId, String name, Scenario parent, Set<Long> failedCourseIds) {
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
                .description(name + " 설명")
                .timetable(timetable)
                .parentScenario(parent)
                .failedCourseIds(failedCourseIds)
                .orderIndex(0)
                .build();
        return scenarioRepository.save(scenario);
    }
}