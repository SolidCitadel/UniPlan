package com.uniplan.catalog.domain.course.dto;

import lombok.Data;

import java.util.List;

@Data
public class CourseImportRequest {

    private Integer openingYear;
    private String semester;
    private String targetGrade;
    private String courseCode;
    private String courseName;
    private String professor;
    private Integer credits;
    private String classroom;
    private String campus;
    private String departmentCode;
    private String courseTypeCode;
    private String notes;
    private List<ClassTimeDto> classTime;

    @Data
    public static class ClassTimeDto {
        private String day;
        private String startTime;
        private String endTime;
    }
}
