package com.uniplan.catalog.domain.course.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

public class MetadataResponse {

    @Data
    @Builder
    @AllArgsConstructor
    public static class CourseTypesResponse {
        @Schema(requiredMode = REQUIRED)
        private List<CourseTypeDto> courseTypes;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class DepartmentsResponse {
        @Schema(requiredMode = REQUIRED)
        private List<DepartmentDto> departments;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class CollegesResponse {
        @Schema(requiredMode = REQUIRED)
        private List<CollegeDto> colleges;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class CourseTypeDto {
        @Schema(requiredMode = REQUIRED)
        private Long id;
        @Schema(requiredMode = REQUIRED)
        private String code;
        @Schema(requiredMode = REQUIRED)
        private String nameKr;
        private String nameEn;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class DepartmentDto {
        @Schema(requiredMode = REQUIRED)
        private Long id;
        @Schema(requiredMode = REQUIRED)
        private String code;
        @Schema(requiredMode = REQUIRED)
        private String name;
        private String nameEn;
        private String level;
        private CollegeDto college;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class CollegeDto {
        @Schema(requiredMode = REQUIRED)
        private Long id;
        @Schema(requiredMode = REQUIRED)
        private String code;
        @Schema(requiredMode = REQUIRED)
        private String name;
        private String nameEn;
    }
}
