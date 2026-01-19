package com.uniplan.catalog.component.course;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.catalog.config.DockerRequiredExtension;
import com.uniplan.catalog.domain.course.dto.CourseImportRequest;
import com.uniplan.catalog.domain.course.dto.MetadataImportRequest;
import com.uniplan.catalog.domain.university.entity.University;
import com.uniplan.catalog.domain.university.repository.UniversityRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(DockerRequiredExtension.class)
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class CourseImportControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UniversityRepository universityRepository;

    private University testUniversity;

    @BeforeEach
    void setUp() {
        testUniversity = University.builder()
                .id(1L)
                .code("TEST")
                .build();
        universityRepository.save(testUniversity);
    }

    @Test
    @DisplayName("POST /metadata/import - 메타데이터 임포트 성공")
    void importMetadata() throws Exception {
        // given
        MetadataImportRequest request = new MetadataImportRequest();
        request.setYear(2025);
        request.setSemester(1);
        request.setCrawledAt("2025-01-20T10:00:00");

        MetadataImportRequest.CollegeDto college = new MetadataImportRequest.CollegeDto();
        college.setCode("ENG");
        college.setName("공과대학");
        college.setNameEn("College of Engineering");

        MetadataImportRequest.DepartmentDto dept = new MetadataImportRequest.DepartmentDto();
        dept.setCode("CSE");
        dept.setName("컴퓨터공학과");
        dept.setNameEn("Computer Science");
        dept.setCollegeCode("ENG");
        dept.setLevel("Undergraduate");

        MetadataImportRequest.CourseTypeDto type = new MetadataImportRequest.CourseTypeDto();
        type.setCode("MjReq");
        type.setNameKr("전공필수");
        type.setNameEn("Major Required");

        request.setColleges(Map.of("ENG", college));
        request.setDepartments(Map.of("CSE", dept));
        request.setCourseTypes(Map.of("MjReq", type));

        // when & then
        mockMvc.perform(post("/metadata/import")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.successCount").value(3));
    }

    @Test
    @DisplayName("POST /courses/import - 과목 데이터 임포트 성공")
    void importCourses() throws Exception {
        // given
        // 먼저 메타데이터가 있어야 함 (학과, 이수구분 등)
        importMetadata();

        CourseImportRequest request = new CourseImportRequest();
        request.setOpeningYear(2025);
        request.setSemester("1학기");
        request.setTargetGrade(3);
        request.setCourseCode("CSE301");
        request.setSection("01");
        request.setCourseName("운영체제");
        request.setProfessor("홍길동");
        request.setCredits(3);
        request.setClassroom("공학관 301호");
        request.setCampus("서울");
        request.setDepartmentCodes(List.of("CSE"));
        request.setCourseTypeCode("MjReq");
        request.setNotes("선수과목 있음");
        request.setUniversityId(testUniversity.getId());

        CourseImportRequest.ClassTimeDto time = new CourseImportRequest.ClassTimeDto();
        time.setDay("월");
        time.setStartTime("10:30");
        time.setEndTime("11:45");
        request.setClassTime(List.of(time));

        List<CourseImportRequest> requests = List.of(request);

        // when & then
        mockMvc.perform(post("/courses/import")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(requests)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.successCount").value(1));
    }
}
