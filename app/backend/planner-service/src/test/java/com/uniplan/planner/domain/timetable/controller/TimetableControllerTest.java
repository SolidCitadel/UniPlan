package com.uniplan.planner.domain.timetable.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.timetable.dto.AddCourseRequest;
import com.uniplan.planner.domain.timetable.dto.CreateTimetableRequest;
import com.uniplan.planner.domain.timetable.dto.UpdateTimetableRequest;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.entity.TimetableItem;
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

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class TimetableControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private TimetableRepository timetableRepository;

    @Autowired
    private TimetableItemRepository timetableItemRepository;

    @Autowired
    private ScenarioRepository scenarioRepository;

    private static final Long TEST_USER_ID = 1L;
    private static final Long OTHER_USER_ID = 2L;

    @BeforeEach
    void setUp() {
        scenarioRepository.deleteAll();  // Scenario가 Timetable을 참조하므로 먼저 삭제
        timetableItemRepository.deleteAll();
        timetableRepository.deleteAll();
    }

    @Test
    @DisplayName("시간표 생성")
    void createTimetable() throws Exception {
        CreateTimetableRequest request = CreateTimetableRequest.builder()
                .name("2025-1학기 시간표")
                .openingYear(2025)
                .semester("1학기")
                .build();

        mockMvc.perform(post("/timetables")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$.name").value("2025-1학기 시간표"))
                .andExpect(jsonPath("$.openingYear").value(2025))
                .andExpect(jsonPath("$.semester").value("1학기"))
                .andExpect(jsonPath("$.items").isArray())
                .andExpect(jsonPath("$.items").isEmpty());
    }

    @Test
    @DisplayName("시간표 생성 - 유효성 검증 실패 (이름 없음)")
    void createTimetable_withoutName() throws Exception {
        CreateTimetableRequest request = CreateTimetableRequest.builder()
                .openingYear(2025)
                .semester("1학기")
                .build();

        mockMvc.perform(post("/timetables")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("사용자의 모든 시간표 조회")
    void getUserTimetables() throws Exception {
        // Given: 테스트 시간표 생성
        createTestTimetable(TEST_USER_ID, "시간표 1", 2025, "1학기");
        createTestTimetable(TEST_USER_ID, "시간표 2", 2025, "1학기");
        createTestTimetable(OTHER_USER_ID, "다른 사용자 시간표", 2025, "1학기");

        // When & Then
        mockMvc.perform(get("/timetables")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$[1].userId").value(TEST_USER_ID));
    }

    @Test
    @DisplayName("학기별 시간표 조회")
    void getUserTimetablesBySemester() throws Exception {
        // Given
        createTestTimetable(TEST_USER_ID, "2025-1학기", 2025, "1학기");
        createTestTimetable(TEST_USER_ID, "2025-2학기", 2025, "2학기");
        createTestTimetable(TEST_USER_ID, "2024-1학기", 2024, "1학기");

        // When & Then: 2025-1학기만 조회
        mockMvc.perform(get("/timetables")
                        .header("X-User-Id", TEST_USER_ID)
                        .param("openingYear", "2025")
                        .param("semester", "1학기"))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].openingYear").value(2025))
                .andExpect(jsonPath("$[0].semester").value("1학기"));
    }

    @Test
    @DisplayName("특정 시간표 조회")
    void getTimetable() throws Exception {
        // Given
        Timetable timetable = createTestTimetable(TEST_USER_ID, "내 시간표", 2025, "1학기");

        // When & Then
        mockMvc.perform(get("/timetables/" + timetable.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(timetable.getId()))
                .andExpect(jsonPath("$.name").value("내 시간표"));
    }

    @Test
    @DisplayName("다른 사용자의 시간표 조회 실패")
    void getTimetable_otherUser() throws Exception {
        // Given: 다른 사용자의 시간표
        Timetable otherTimetable = createTestTimetable(OTHER_USER_ID, "다른 사용자 시간표", 2025, "1학기");

        // When & Then: 내 계정으로 조회 시도 -> 404
        mockMvc.perform(get("/timetables/" + otherTimetable.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("시간표 이름 수정")
    void updateTimetable() throws Exception {
        // Given
        Timetable timetable = createTestTimetable(TEST_USER_ID, "원래 이름", 2025, "1학기");

        UpdateTimetableRequest request = UpdateTimetableRequest.builder()
                .name("수정된 이름")
                .build();

        // When & Then
        mockMvc.perform(put("/timetables/" + timetable.getId())
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(timetable.getId()))
                .andExpect(jsonPath("$.name").value("수정된 이름"));
    }

    @Test
    @DisplayName("시간표 삭제")
    void deleteTimetable() throws Exception {
        // Given
        Timetable timetable = createTestTimetable(TEST_USER_ID, "삭제할 시간표", 2025, "1학기");

        // When & Then
        mockMvc.perform(delete("/timetables/" + timetable.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNoContent());

        // 삭제 확인
        mockMvc.perform(get("/timetables/" + timetable.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("시간표에 강의 추가")
    void addCourseToTimetable() throws Exception {
        // Given
        Timetable timetable = createTestTimetable(TEST_USER_ID, "내 시간표", 2025, "1학기");

        AddCourseRequest request = AddCourseRequest.builder()
                .courseId(101L)
                .build();

        // When & Then
        mockMvc.perform(post("/timetables/" + timetable.getId() + "/courses")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.courseId").value(101L))
                .andExpect(jsonPath("$.addedAt").exists());
    }

    @Test
    @DisplayName("시간표에 중복 강의 추가 실패")
    void addCourseToTimetable_duplicate() throws Exception {
        // Given: 이미 강의가 추가된 시간표
        Timetable timetable = createTestTimetable(TEST_USER_ID, "내 시간표", 2025, "1학기");
        addCourseToTestTimetable(timetable, 101L);

        AddCourseRequest request = AddCourseRequest.builder()
                .courseId(101L)
                .build();

        // When & Then: 같은 강의 다시 추가 시도 -> 409 Conflict
        mockMvc.perform(post("/timetables/" + timetable.getId() + "/courses")
                        .header("X-User-Id", TEST_USER_ID)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isConflict());
    }

    @Test
    @DisplayName("시간표에서 강의 삭제")
    void removeCourseFromTimetable() throws Exception {
        // Given: 강의가 추가된 시간표
        Timetable timetable = createTestTimetable(TEST_USER_ID, "내 시간표", 2025, "1학기");
        addCourseToTestTimetable(timetable, 101L);

        // When & Then
        mockMvc.perform(delete("/timetables/" + timetable.getId() + "/courses/101")
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNoContent());
    }

    @Test
    @DisplayName("시간표에 여러 강의 추가 후 조회")
    void addMultipleCoursesAndRetrieve() throws Exception {
        // Given
        Timetable timetable = createTestTimetable(TEST_USER_ID, "내 시간표", 2025, "1학기");
        addCourseToTestTimetable(timetable, 101L);
        addCourseToTestTimetable(timetable, 102L);
        addCourseToTestTimetable(timetable, 103L);

        // When & Then
        mockMvc.perform(get("/timetables/" + timetable.getId())
                        .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.items", hasSize(3)))
                .andExpect(jsonPath("$.items[0].courseId").exists())
                .andExpect(jsonPath("$.items[1].courseId").exists())
                .andExpect(jsonPath("$.items[2].courseId").exists());
    }

    // Helper methods
    private Timetable createTestTimetable(Long userId, String name, Integer openingYear, String semester) {
        Timetable timetable = Timetable.builder()
                .userId(userId)
                .name(name)
                .openingYear(openingYear)
                .semester(semester)
                .build();
        return timetableRepository.save(timetable);
    }

    private void addCourseToTestTimetable(Timetable timetable, Long courseId) {
        TimetableItem item = TimetableItem.builder()
                .timetable(timetable)
                .courseId(courseId)
                .build();
        timetableItemRepository.save(item);
    }
}