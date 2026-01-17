package com.uniplan.catalog.domain.course.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.Map;

@Data
public class MetadataImportRequest {

    @NotNull
    private Integer year;
    @NotNull
    private Integer semester;

    @JsonProperty("crawled_at")
    private String crawledAt;

    private Map<String, CollegeDto> colleges;
    private Map<String, DepartmentDto> departments;
    private Map<String, CourseTypeDto> courseTypes;

    @Data
    public static class CollegeDto {
        private String code;
        private String name;
        private String nameEn;
    }

    @Data
    public static class DepartmentDto {
        private String code;
        private String name;
        private String nameEn;
        private String collegeCode;
        private String level;
    }

    @Data
    public static class CourseTypeDto {
        private String code;
        private String nameKr;
        private String nameEn;
    }
}
