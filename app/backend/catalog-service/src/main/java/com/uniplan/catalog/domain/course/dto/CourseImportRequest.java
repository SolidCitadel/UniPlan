package com.uniplan.catalog.domain.course.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class CourseImportRequest {

    @NotNull
    private Integer openingYear;
    @NotBlank
    private String semester;
    private Integer targetGrade;
    @NotBlank
    private String courseCode;
    private String section;
    @NotBlank
    private String courseName;
    private String professor;
    @NotNull
    private Integer credits;
    private String classroom;
    private String campus;
    private List<String> departmentCodes;
    @NotBlank
    private String courseTypeCode;
    private String notes;
    @Valid
    private List<ClassTimeDto> classTime;
    @NotNull
    private Long universityId;

    @Data
    public static class ClassTimeDto {
        @NotBlank
        private String day;
        @NotBlank
        private String startTime;
        @NotBlank
        private String endTime;
    }
}
