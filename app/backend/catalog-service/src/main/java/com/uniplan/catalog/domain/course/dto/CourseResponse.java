package com.uniplan.catalog.domain.course.dto;

import com.uniplan.catalog.domain.course.entity.Course;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Course response DTO
 */
@Data
@Builder
public class CourseResponse {

    private Long id;
    private Integer openingYear;
    private String semester;
    private String targetGrade;
    private String courseCode;
    private String section;
    private String courseName;
    private String professor;
    private Integer credits;
    private String classroom;
    private String campus;
    private String notes;

    // Related entities
    private String departmentCode;
    private String departmentName;
    private String collegeCode;
    private String collegeName;
    private String courseTypeCode;
    private String courseTypeName;

    // Class times
    private List<ClassTimeResponse> classTimes;

    @Data
    @Builder
    public static class ClassTimeResponse {
        private String day;
        private String startTime;
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
     */
    public static CourseResponse from(Course course) {
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
            .departmentCode(course.getDepartment().getCode())
            .departmentName(course.getDepartment().getName())
            .collegeCode(course.getDepartment().getCollege().getCode())
            .collegeName(course.getDepartment().getCollege().getName())
            .courseTypeCode(course.getCourseType().getCode())
            .courseTypeName(course.getCourseType().getNameKr())
            .classTimes(course.getClassTimes().stream()
                .map(ClassTimeResponse::from)
                .collect(Collectors.toList()))
            .build();
    }
}
