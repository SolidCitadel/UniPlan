package com.uniplan.catalog.component.course;

import com.uniplan.catalog.config.DockerRequiredExtension;
import com.uniplan.catalog.domain.course.entity.Course;
import com.uniplan.catalog.domain.course.repository.CourseRepository;
import com.uniplan.catalog.domain.course.repository.CollegeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.university.repository.UniversityRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(DockerRequiredExtension.class)
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class InternalCourseComponentTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private UniversityRepository universityRepository;
    @Autowired
    private CollegeRepository collegeRepository;
    @Autowired
    private DepartmentRepository departmentRepository;
    @Autowired
    private CourseTypeRepository courseTypeRepository;

    private Long courseId1;
    private Long courseId2;

    @BeforeEach
    void setUp() {
        // Setup data dependencies
        var university = universityRepository.save(com.uniplan.catalog.domain.university.entity.University.builder()
                .id(1L).code("TEST").build());
        
        var college = collegeRepository.save(com.uniplan.catalog.domain.course.entity.College.builder()
                .code("TEST_COL").name("Test College").nameEn("Test College").build());
                
        var department = departmentRepository.save(com.uniplan.catalog.domain.course.entity.Department.builder()
                .code("TEST_DEPT").name("Test Dept").nameEn("Test Dept")
                .college(college).level("30").build());
                
        var courseType = courseTypeRepository.save(com.uniplan.catalog.domain.course.entity.CourseType.builder()
                .code("01").nameKr("Type").nameEn("Type").build());

        // Setup minimal course data for testing
        Course c1 = Course.builder()
                .courseName("Integration Test Course 1")
                .courseCode("ITC101")
                .openingYear(2025)
                .semester("1학기")
                .credits(3)
                .university(university)
                .departments(List.of(department))
                .courseType(courseType)
                .build();
        Course c2 = Course.builder()
                .courseName("Integration Test Course 2")
                .courseCode("ITC102")
                .openingYear(2025)
                .semester("1학기")
                .credits(3)
                .university(university)
                .departments(List.of(department))
                .courseType(courseType)
                .build();

        courseId1 = courseRepository.save(c1).getId();
        courseId2 = courseRepository.save(c2).getId();
    }

    @Test
    @DisplayName("Batch course retrieval - Success Integration")
    void getCoursesByIds_integrationSuccess() throws Exception {
        mockMvc.perform(get("/internal/courses")
                .param("ids", courseId1 + "," + courseId2))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[0].courseName").value("Integration Test Course 1"))
                .andExpect(jsonPath("$[1].courseName").value("Integration Test Course 2"));
    }

    @Test
    @DisplayName("Batch course retrieval - Empty IDs")
    void getCoursesByIds_emptyIds() throws Exception {
        mockMvc.perform(get("/internal/courses")
                .param("ids", ""))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(0));
    }
}
