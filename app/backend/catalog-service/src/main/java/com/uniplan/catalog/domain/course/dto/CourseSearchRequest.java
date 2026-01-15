package com.uniplan.catalog.domain.course.dto;

import lombok.Data;

/**
 * Course search request DTO with dynamic filtering
 */
@Data
public class CourseSearchRequest {

    // University filter (required)
    private Long universityId;

    // Basic filters
    private Integer openingYear;
    private String semester;
    private String courseName;         // partial match
    private String courseCode;         // partial match
    private String professor;          // partial match
    private Integer targetGrade;
    private String departmentCode;
    private String departmentName;     // partial match
    private String courseTypeCode;
    private String campus;

    // Time filters
    private String dayOfWeek;          // 월, 화, 수, 목, 금, 토, 일
    private String startTimeAfter;     // HH:mm (courses starting after this time)
    private String startTimeBefore;    // HH:mm (courses starting before this time)

    // Credit filter
    private Integer minCredits;
    private Integer maxCredits;
}
