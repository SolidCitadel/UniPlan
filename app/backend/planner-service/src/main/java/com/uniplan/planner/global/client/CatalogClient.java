package com.uniplan.planner.global.client;

import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Client for calling catalog-service APIs
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class CatalogClient {

    private final RestTemplate restTemplate;

    @Value("${services.catalog.url}")
    private String catalogServiceUrl;

    /**
     * Get simple course information by ID (id, courseName, professor only)
     */
    public CourseSimpleResponse getCourseById(Long courseId) {
        String url = catalogServiceUrl + "/courses/" + courseId;

        try {
            return restTemplate.getForObject(url, CourseSimpleResponse.class);
        } catch (Exception e) {
            log.error("Failed to fetch course from catalog-service. courseId={}, error={}",
                courseId, e.getMessage());
            return null;
        }
    }

    /**
     * Get full course information by ID (all fields including classTimes)
     */
    public CourseFullResponse getFullCourseById(Long courseId) {
        String url = catalogServiceUrl + "/courses/" + courseId;

        try {
            return restTemplate.getForObject(url, CourseFullResponse.class);
        } catch (Exception e) {
            log.error("Failed to fetch course from catalog-service. courseId={}, error={}",
                courseId, e.getMessage());
            return null;
        }
    }

    /**
     * Get multiple simple courses by IDs (Batch)
     * Calls internal API /internal/courses?ids=...
     */
    public Map<Long, CourseSimpleResponse> getCoursesByIds(List<Long> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return new HashMap<>();
        }

        // Use internal batch API
        String url = catalogServiceUrl + "/internal/courses?ids=" + String.join(",", 
            courseIds.stream().map(String::valueOf).toArray(String[]::new));

        try {
            CourseSimpleResponse[] response = restTemplate.getForObject(url, CourseSimpleResponse[].class);
            if (response == null) {
                return new HashMap<>();
            }

            Map<Long, CourseSimpleResponse> result = new HashMap<>();
            for (CourseSimpleResponse course : response) {
                result.put(course.getId(), course);
            }
            return result;

        } catch (Exception e) {
            log.error("Failed to fetch courses from catalog-service (batch). error={}", e.getMessage());
            return new HashMap<>();
        }
    }

    /**
     * Get multiple full courses by IDs (Batch)
     * Calls internal API /internal/courses?ids=...
     */
    public Map<Long, CourseFullResponse> getFullCoursesByIds(List<Long> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return new HashMap<>();
        }

        // Use internal batch API
        String url = catalogServiceUrl + "/internal/courses?ids=" + String.join(",", 
            courseIds.stream().map(String::valueOf).toArray(String[]::new));

        try {
            CourseFullResponse[] response = restTemplate.getForObject(url, CourseFullResponse[].class);
            if (response == null) {
                return new HashMap<>();
            }

            Map<Long, CourseFullResponse> result = new HashMap<>();
            for (CourseFullResponse course : response) {
                result.put(course.getId(), course);
            }
            return result;

        } catch (Exception e) {
            log.error("Failed to fetch courses from catalog-service (batch). error={}", e.getMessage());
            return new HashMap<>();
        }
    }
}
