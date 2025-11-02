package com.uniplan.catalog.domain.course.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

public class MetadataResponse {

    @Data
    @Builder
    @AllArgsConstructor
    public static class CourseTypesResponse {
        private List<CourseTypeDto> courseTypes;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class DepartmentsResponse {
        private List<DepartmentDto> departments;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class CollegesResponse {
        private List<CollegeDto> colleges;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class CourseTypeDto {
        private Long id;
        private String code;
        private String nameKr;
        private String nameEn;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class DepartmentDto {
        private Long id;
        private String code;
        private String name;
        private String nameEn;
        private String level;
        private CollegeDto college;
    }

    @Data
    @Builder
    @AllArgsConstructor
    public static class CollegeDto {
        private Long id;
        private String code;
        private String name;
        private String nameEn;
    }
}
