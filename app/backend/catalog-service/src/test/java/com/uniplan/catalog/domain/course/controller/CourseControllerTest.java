package com.uniplan.catalog.domain.course.controller;

import com.uniplan.catalog.domain.course.entity.*;
import com.uniplan.catalog.domain.course.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Integration tests for CourseController
 */
@SpringBootTest
@AutoConfigureMockMvc
class CourseControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private CourseRepository courseRepository;

    @Autowired
    private CollegeRepository collegeRepository;

    @Autowired
    private DepartmentRepository departmentRepository;

    @Autowired
    private CourseTypeRepository courseTypeRepository;

    private College testCollege;
    private Department testDepartment;
    private CourseType testCourseType;

    @BeforeEach
    void setUp() {
        // Clean up existing data
        courseRepository.deleteAll();
        departmentRepository.deleteAll();
        courseTypeRepository.deleteAll();
        collegeRepository.deleteAll();

        // Create test college
        testCollege = College.builder()
            .code("TEST_COLLEGE")
            .name("테스트대학")
            .nameEn("Test College")
            .build();
        testCollege = collegeRepository.save(testCollege);

        // Create test department
        testDepartment = Department.builder()
            .code("TEST_DEPT")
            .name("테스트학과")
            .nameEn("Test Department")
            .college(testCollege)
            .level("30")
            .build();
        testDepartment = departmentRepository.save(testDepartment);

        // Create test course type
        testCourseType = CourseType.builder()
            .code("04")
            .nameKr("전공필수")
            .nameEn("Major Required")
            .build();
        testCourseType = courseTypeRepository.save(testCourseType);

        // Create test courses
        createTestCourse("CSE101", "01", "컴퓨터개론", "김철수", 3, "국제", "월", "09:00", "10:15");
        createTestCourse("CSE102", "01", "자료구조", "이영희", 3, "국제", "화", "10:30", "11:45");
        createTestCourse("CSE201", "01", "알고리즘", "박민수", 3, "국제", "수", "13:00", "14:15");
        createTestCourse("ECON101", "01", "경영학개론", "최지훈", 3, "서울", "목", "14:30", "15:45");
        createTestCourse("ECON102", "01", "미시경제학", "정수진", 3, "서울", "금", "16:00", "17:15");
        createTestCourse("MATH101", "01", "미적분학", "강동훈", 4, "국제", "월", "15:00", "17:00");
        createTestCourse("MATH102", "01", "선형대수", "송미래", 4, "국제", "화", "13:00", "15:00");
        createTestCourse("PHYS101", "01", "물리학개론", "윤서연", 3, "서울", "수", "09:00", "10:15");
        createTestCourse("CHEM101", "01", "화학개론", "한지우", 3, "서울", "목", "10:30", "11:45");
        createTestCourse("BIO101", "01", "생물학개론", "임태양", 3, "국제", "금", "13:00", "14:15");
        createTestCourse("ENG101", "01", "영어회화", "조하늘", 2, "국제", "월", "11:00", "11:50");
        createTestCourse("KOR101", "01", "한국어작문", "배별", 2, "서울", "화", "11:00", "11:50");
    }

    private void createTestCourse(String courseCode, String section, String courseName,
                                  String professor, int credits, String campus,
                                  String day, String startTime, String endTime) {
        Course course = Course.builder()
            .openingYear(2025)
            .semester("2학기")
            .targetGrade(1)
            .courseCode(courseCode)
            .section(section)
            .courseName(courseName)
            .professor(professor)
            .credits(credits)
            .classroom("테스트강의실")
            .campus(campus)
            .notes("테스트 과목")
            .department(testDepartment)
            .courseType(testCourseType)
            .build();

        ClassTime classTime = ClassTime.builder()
            .day(day)
            .startTime(LocalTime.parse(startTime))
            .endTime(LocalTime.parse(endTime))
            .course(course)
            .build();

        course.addClassTime(classTime);
        courseRepository.save(course);
    }

    @Test
    @DisplayName("전체 과목 조회 - 기본 페이징")
    void searchCourses_withDefaultPagination() throws Exception {
        mockMvc.perform(get("/courses")
                .param("page", "0")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content.length()").value(10))
            .andExpect(jsonPath("$.totalElements").exists())
            .andExpect(jsonPath("$.totalPages").exists());
    }

    @Test
    @DisplayName("과목명으로 검색")
    void searchCourses_byCourseName() throws Exception {
        mockMvc.perform(get("/courses")
                .param("courseName", "컴퓨터")
                .param("page", "0")
                .param("size", "5"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content[0].courseName").exists());
    }

    @Test
    @DisplayName("교수명으로 검색")
    void searchCourses_byProfessor() throws Exception {
        mockMvc.perform(get("/courses")
                .param("professor", "이")
                .param("page", "0")
                .param("size", "5"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("학기와 년도로 검색")
    void searchCourses_byYearAndSemester() throws Exception {
        mockMvc.perform(get("/courses")
                .param("openingYear", "2025")
                .param("semester", "2학기")
                .param("page", "0")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content[0].openingYear").value(2025))
            .andExpect(jsonPath("$.content[0].semester").value("2학기"));
    }

    @Test
    @DisplayName("학점 범위로 검색")
    void searchCourses_byCreditRange() throws Exception {
        mockMvc.perform(get("/courses")
                .param("minCredits", "3")
                .param("maxCredits", "3")
                .param("page", "0")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content[0].credits").value(3));
    }

    @Test
    @DisplayName("캠퍼스로 검색")
    void searchCourses_byCampus() throws Exception {
        mockMvc.perform(get("/courses")
                .param("campus", "국제")
                .param("page", "0")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("요일로 검색")
    void searchCourses_byDayOfWeek() throws Exception {
        mockMvc.perform(get("/courses")
                .param("dayOfWeek", "월")
                .param("page", "0")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray());
    }

    @Test
    @DisplayName("복합 조건 검색 - 과목명, 학점, 캠퍼스")
    void searchCourses_withMultipleFilters() throws Exception {
        // Search for "컴퓨터", 3 credits, "국제" campus
        // Should match: CSE101 (컴퓨터개론), CSE102 (자료구조)
        mockMvc.perform(get("/courses")
                .param("courseName", "컴퓨터")
                .param("minCredits", "3")
                .param("maxCredits", "3")
                .param("campus", "국제")
                .param("page", "0")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content.length()").value(1))  // Only CSE101 matches all conditions
            .andExpect(jsonPath("$.content[0].courseName").value("컴퓨터개론"));
    }

    @Test
    @DisplayName("과목 ID로 단일 조회")
    void getCourseById() throws Exception {
        // Get first course from repository to get valid ID
        Course firstCourse = courseRepository.findAll().get(0);

        mockMvc.perform(get("/courses/" + firstCourse.getId()))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value(firstCourse.getId()))
            .andExpect(jsonPath("$.courseName").exists())
            .andExpect(jsonPath("$.courseCode").exists())
            .andExpect(jsonPath("$.departmentName").value("테스트학과"))
            .andExpect(jsonPath("$.collegeName").value("테스트대학"))
            .andExpect(jsonPath("$.courseTypeName").value("전공필수"))
            .andExpect(jsonPath("$.classTimes").isArray())
            .andExpect(jsonPath("$.classTimes[0].day").exists());
    }

    @Test
    @DisplayName("페이징 - 두 번째 페이지 조회")
    void searchCourses_secondPage() throws Exception {
        mockMvc.perform(get("/courses")
                .param("page", "1")
                .param("size", "10"))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content.length()").value(2))  // 12 total, page 1 has 2 items
            .andExpect(jsonPath("$.number").value(1))  // Page number
            .andExpect(jsonPath("$.size").value(10))
            .andExpect(jsonPath("$.totalElements").value(12))
            .andExpect(jsonPath("$.totalPages").value(2));
    }
}
