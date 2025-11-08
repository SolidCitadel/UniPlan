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
     * Get multiple simple courses by IDs
     * Returns a map of courseId -> CourseSimpleResponse
     */
    public Map<Long, CourseSimpleResponse> getCoursesByIds(List<Long> courseIds) {
        Map<Long, CourseSimpleResponse> result = new HashMap<>();

        for (Long courseId : courseIds) {
            CourseSimpleResponse course = getCourseById(courseId);
            if (course != null) {
                result.put(courseId, course);
            }
        }

        return result;
    }

    /**
     * Get multiple full courses by IDs
     * Returns a map of courseId -> CourseFullResponse
     */
    public Map<Long, CourseFullResponse> getFullCoursesByIds(List<Long> courseIds) {
        Map<Long, CourseFullResponse> result = new HashMap<>();

        for (Long courseId : courseIds) {
            CourseFullResponse course = getFullCourseById(courseId);
            if (course != null) {
                result.put(courseId, course);
            }
        }

        return result;
    }
}
