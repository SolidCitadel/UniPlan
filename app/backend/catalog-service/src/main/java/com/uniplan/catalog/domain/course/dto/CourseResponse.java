package com.uniplan.catalog.domain.course.dto;

import com.uniplan.catalog.domain.course.entity.Course;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.stream.Collectors;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

/**
 * Course response DTO
 */
@Data
@Builder
public class CourseResponse {

    @Schema(requiredMode = REQUIRED)
    private Long id;
    @Schema(requiredMode = REQUIRED)
    private Integer openingYear;
    @Schema(requiredMode = REQUIRED)
    private String semester;
    private Integer targetGrade;
    @Schema(requiredMode = REQUIRED)
    private String courseCode;
    private String section;
    @Schema(requiredMode = REQUIRED)
    private String courseName;
    private String professor;
    @Schema(requiredMode = REQUIRED)
    private Integer credits;
    private String classroom;
    private String campus;
    private String notes;

    // Related entities
    private String departmentCode;
    private String departmentName;
    private String collegeCode;
    private String collegeName;
    @Schema(requiredMode = REQUIRED)
    private String courseTypeCode;
    @Schema(requiredMode = REQUIRED)
    private String courseTypeName;

    // Class times
    @Schema(requiredMode = REQUIRED)
    private List<ClassTimeResponse> classTimes;

    @Data
    @Builder
    public static class ClassTimeResponse {
        @Schema(requiredMode = REQUIRED)
        private String day;
        @Schema(requiredMode = REQUIRED)
        private String startTime;
        @Schema(requiredMode = REQUIRED)
        private String endTime;

        public static ClassTimeResponse from(com.uniplan.catalog.domain.course.entity.ClassTime classTime) {
            return ClassTimeResponse.builder()
                .day(classTime.getDay())
                .startTime(classTime.getStartTime().toString())
                .endTime(classTime.getEndTime().toString())
                .build();
        }
    }

    /**
     * Convert Course entity to CourseResponse DTO
     * Note: Returns only the first department for backward compatibility
     */
    public static CourseResponse from(Course course) {
        // Get first department (backward compatibility)
        var department = course.getDepartments().isEmpty() ? null : course.getDepartments().get(0);

        return CourseResponse.builder()
            .id(course.getId())
            .openingYear(course.getOpeningYear())
            .semester(course.getSemester())
            .targetGrade(course.getTargetGrade())
            .courseCode(course.getCourseCode())
            .section(course.getSection())
            .courseName(course.getCourseName())
            .professor(course.getProfessor())
            .credits(course.getCredits())
            .classroom(course.getClassroom())
            .campus(course.getCampus())
            .notes(course.getNotes())
            .departmentCode(department != null ? department.getCode() : null)
            .departmentName(department != null ? department.getName() : null)
            .collegeCode(department != null && department.getCollege() != null ? department.getCollege().getCode() : null)
            .collegeName(department != null && department.getCollege() != null ? department.getCollege().getName() : null)
            .courseTypeCode(course.getCourseType().getCode())
            .courseTypeName(course.getCourseType().getNameKr())
            .classTimes(course.getClassTimes().stream()
                .map(ClassTimeResponse::from)
                .collect(Collectors.toList()))
            .build();
    }
}
