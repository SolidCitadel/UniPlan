package com.uniplan.planner.global.client.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Simplified course response from catalog-service
 * Contains only the fields needed for wishlist display
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@JsonIgnoreProperties(ignoreUnknown = true)
public class CourseSimpleResponse {
    private Long id;
    private String courseName;
    private String professor;
}
