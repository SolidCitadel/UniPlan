package com.uniplan.catalog.unit.course;

import com.uniplan.catalog.domain.course.dto.CourseImportRequest;
import com.uniplan.catalog.domain.course.dto.ImportResponse;
import com.uniplan.catalog.domain.course.entity.College;
import com.uniplan.catalog.domain.course.entity.CourseType;
import com.uniplan.catalog.domain.course.entity.Department;
import com.uniplan.catalog.domain.course.repository.CollegeRepository;
import com.uniplan.catalog.domain.course.repository.CourseRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
import com.uniplan.catalog.domain.course.service.CourseImportService;
import com.uniplan.catalog.domain.university.entity.University;
import com.uniplan.catalog.domain.university.repository.UniversityRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.BDDMockito.*;

/**
 * CourseImportService 단위 테스트
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("CourseImportService 단위 테스트")
class CourseImportServiceTest {

    @Mock private CourseRepository courseRepository;
    @Mock private DepartmentRepository departmentRepository;
    @Mock private CourseTypeRepository courseTypeRepository;
    @Mock private CollegeRepository collegeRepository;
    @Mock private UniversityRepository universityRepository;
    @Mock private EntityManager entityManager;

    @InjectMocks
    private CourseImportService courseImportService;

    private University mockUniversity;
    private Department mockDepartment;
    private CourseType mockCourseType;

    @BeforeEach
    void setUp() {
        mockUniversity = University.builder().id(1L).code("KHU").build();
        mockDepartment = Department.builder().code("CS").name("Computer Science").build();
        mockCourseType = CourseType.builder().code("01").nameKr("전공필수").build();
    }

    @Nested
    @DisplayName("importCourses")
    class ImportCourses {

        @Test
        @DisplayName("정상 임포트 - 성공")
        void success() {
            // given
            CourseImportRequest request = createValidRequest();
            given(universityRepository.findById(1L)).willReturn(Optional.of(mockUniversity));
            given(departmentRepository.findByCode("CS")).willReturn(Optional.of(mockDepartment));
            given(courseTypeRepository.findByCode("01")).willReturn(Optional.of(mockCourseType));
            given(courseRepository.existsByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
                anyString(), anyString(), any(), anyString(), anyString())).willReturn(false);

            // when
            ImportResponse response = courseImportService.importCourses(List.of(request));

            // then
            assertThat(response.getSuccessCount()).isEqualTo(1);
            assertThat(response.getFailureCount()).isEqualTo(0);
            verify(courseRepository).saveAll(any());
        }

        @Test
        @DisplayName("중복 과목 - 스킵됨")
        void duplicate_skipped() {
            // given
            CourseImportRequest request = createValidRequest();
            given(courseRepository.existsByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
                anyString(), anyString(), any(), anyString(), anyString())).willReturn(true);

            // when
            ImportResponse response = courseImportService.importCourses(List.of(request));

            // then
            assertThat(response.getSuccessCount()).isEqualTo(0);
            assertThat(response.getFailureCount()).isEqualTo(0);
            verify(courseRepository, never()).saveAll(any());
        }

        @Test
        @DisplayName("빈 리스트 - 빈 결과 반환")
        void emptyList_returnsEmptyResult() {
            // when
            ImportResponse response = courseImportService.importCourses(List.of());

            // then
            assertThat(response.getTotalCount()).isEqualTo(0);
            assertThat(response.getSuccessCount()).isEqualTo(0);
            verify(courseRepository, never()).saveAll(any());
        }

        @Test
        @DisplayName("존재하지 않는 대학 - 예외 발생")
        void universityNotFound_throwsException() {
            // given
            CourseImportRequest request = createValidRequest();
            given(universityRepository.findById(1L)).willReturn(Optional.empty());
            given(courseRepository.existsByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
                anyString(), anyString(), any(), anyString(), anyString())).willReturn(false);
            given(departmentRepository.findByCode("CS")).willReturn(Optional.of(mockDepartment));
            given(courseTypeRepository.findByCode("01")).willReturn(Optional.of(mockCourseType));

            // when
            ImportResponse response = courseImportService.importCourses(List.of(request));

            // then - 예외가 잡히고 실패로 처리됨
            assertThat(response.getFailureCount()).isEqualTo(1);
        }

        @Test
        @DisplayName("새 학과 자동 생성")
        void newDepartment_autoCreated() {
            // given
            CourseImportRequest request = createValidRequest();
            College unknownCollege = College.builder().code("UNKNOWN").name("Unknown College").build();
            Department newDepartment = Department.builder().code("CS").name("Unknown - CS").build();

            given(universityRepository.findById(1L)).willReturn(Optional.of(mockUniversity));
            given(departmentRepository.findByCode("CS")).willReturn(Optional.empty());
            given(collegeRepository.findByCode("UNKNOWN")).willReturn(Optional.of(unknownCollege));
            given(departmentRepository.save(any())).willReturn(newDepartment);
            given(courseTypeRepository.findByCode("01")).willReturn(Optional.of(mockCourseType));
            given(courseRepository.existsByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
                anyString(), anyString(), any(), anyString(), anyString())).willReturn(false);

            // when
            ImportResponse response = courseImportService.importCourses(List.of(request));

            // then
            assertThat(response.getSuccessCount()).isEqualTo(1);
            verify(departmentRepository).save(any());
        }
    }

    @Nested
    @DisplayName("deleteAllCourses")
    class DeleteAllCourses {

        @Test
        @DisplayName("전체 삭제 성공")
        void success() {
            // given
            given(courseRepository.count()).willReturn(100L);

            // when
            ImportResponse response = courseImportService.deleteAllCourses();

            // then
            assertThat(response.getTotalCount()).isEqualTo(100);
            assertThat(response.getSuccessCount()).isEqualTo(100);
            verify(courseRepository).deleteAll();
        }
    }

    private CourseImportRequest createValidRequest() {
        CourseImportRequest request = new CourseImportRequest();
        request.setUniversityId(1L);
        request.setCourseCode("CS101");
        request.setSection("001");
        request.setCourseName("자료구조");
        request.setProfessor("김교수");
        request.setCredits(3);
        request.setOpeningYear(2026);
        request.setSemester("1학기");
        request.setCourseTypeCode("01");
        request.setDepartmentCodes(List.of("CS"));
        return request;
    }
}
