package com.uniplan.catalog.component.course;

import com.uniplan.catalog.config.DockerRequiredExtension;
import com.uniplan.catalog.domain.course.entity.College;
import com.uniplan.catalog.domain.course.entity.CourseType;
import com.uniplan.catalog.domain.course.entity.Department;
import com.uniplan.catalog.domain.course.repository.CollegeRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(DockerRequiredExtension.class)
@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class MetadataControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private CollegeRepository collegeRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    @Autowired
    private CourseTypeRepository courseTypeRepository;

    @Autowired
    private UniversityRepository universityRepository;

    @BeforeEach
    void setUp() {
        // Clean up
        departmentRepository.deleteAll();
        courseTypeRepository.deleteAll();
        collegeRepository.deleteAll();
        universityRepository.deleteAll();

        // Setup Test Data
        University university = University.builder()
                .id(1L)
                .code("TEST")
                .build();
        universityRepository.save(university);

        College college = College.builder()
                .code("ENG")
                .name("공과대학")
                .nameEn("College of Engineering")
                .build();
        collegeRepository.save(college);

        Department dept1 = Department.builder()
                .code("CSE")
                .name("컴퓨터공학과")
                .nameEn("Computer Science")
                .college(college)
                .level("Undergraduate")
                .build();
        Department dept2 = Department.builder()
                .code("ME")
                .name("기계공학과")
                .nameEn("Mechanical Engineering")
                .college(college)
                .level("Undergraduate")
                .build();
        departmentRepository.save(dept1);
        departmentRepository.save(dept2);

        CourseType type1 = CourseType.builder()
                .code("MjReq")
                .nameKr("전공필수")
                .nameEn("Major Required")
                .build();
        CourseType type2 = CourseType.builder()
                .code("MjSel")
                .nameKr("전공선택")
                .nameEn("Major Selected")
                .build();
        courseTypeRepository.save(type1);
        courseTypeRepository.save(type2);
    }

    @Test
    @DisplayName("GET /metadata/colleges - 전체 단과대학 조회")
    void getColleges() throws Exception {
        mockMvc.perform(get("/metadata/colleges")
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.colleges").isArray())
                .andExpect(jsonPath("$.colleges[0].name").value("공과대학"))
                .andExpect(jsonPath("$.colleges[0].code").value("ENG"));
    }

    @Test
    @DisplayName("GET /metadata/departments - 전체 학과 조회")
    void getDepartments() throws Exception {
        mockMvc.perform(get("/metadata/departments")
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.departments").isArray())
                .andExpect(jsonPath("$.departments.length()").value(2))
                .andExpect(jsonPath("$.departments[?(@.code == 'CSE')].name").value("컴퓨터공학과"))
                .andExpect(jsonPath("$.departments[?(@.code == 'ME')].name").value("기계공학과"));
    }

    @Test
    @DisplayName("GET /metadata/course-types - 전체 이수구분 조회")
    void getCourseTypes() throws Exception {
        mockMvc.perform(get("/metadata/course-types")
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.courseTypes").isArray())
                .andExpect(jsonPath("$.courseTypes.length()").value(2))
                .andExpect(jsonPath("$.courseTypes[?(@.code == 'MjReq')].nameKr").value("전공필수"))
                .andExpect(jsonPath("$.courseTypes[?(@.code == 'MjSel')].nameKr").value("전공선택"));
    }
}
