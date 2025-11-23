package com.uniplan.planner.global.client.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Full course response from catalog-service
 * Contains all fields needed for timetable display
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true)
public class CourseFullResponse {
    private Long id;
    private String courseCode;
    private String courseName;
    private String professor;
    private Integer credits;
    private String classroom;
    private String campus;
    private List<ClassTimeResponse> classTimes;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ClassTimeResponse {
        private String day;
        private String startTime;
        private String endTime;
    }
}
