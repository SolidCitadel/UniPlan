package com.uniplan.planner.global.client;

import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Facade for catalog-service API calls.
 * Delegates to CatalogFeignClient (OpenFeign) for actual HTTP communication.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class CatalogClient {

    private final CatalogFeignClient feignClient;

    /**
     * Get simple course information by ID (id, courseName, professor only)
     */
    public CourseSimpleResponse getCourseById(Long courseId) {
        try {
            CourseFullResponse full = feignClient.getCourseById(courseId);
            return toSimple(full);
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
        try {
            return feignClient.getCourseById(courseId);
        } catch (Exception e) {
            log.error("Failed to fetch course from catalog-service. courseId={}, error={}",
                courseId, e.getMessage());
            return null;
        }
    }

    /**
     * Get multiple simple courses by IDs (Batch)
     */
    public Map<Long, CourseSimpleResponse> getCoursesByIds(List<Long> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return new HashMap<>();
        }

        try {
            List<CourseFullResponse> courses = feignClient.getCoursesByIds(courseIds);
            Map<Long, CourseSimpleResponse> result = new HashMap<>();
            for (CourseFullResponse course : courses) {
                result.put(course.getId(), toSimple(course));
            }
            return result;

        } catch (Exception e) {
            log.error("Failed to fetch courses from catalog-service (batch). error={}", e.getMessage());
            return new HashMap<>();
        }
    }

    /**
     * Get multiple full courses by IDs (Batch)
     */
    public Map<Long, CourseFullResponse> getFullCoursesByIds(List<Long> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return new HashMap<>();
        }

        try {
            List<CourseFullResponse> courses = feignClient.getCoursesByIds(courseIds);
            Map<Long, CourseFullResponse> result = new HashMap<>();
            for (CourseFullResponse course : courses) {
                result.put(course.getId(), course);
            }
            return result;

        } catch (Exception e) {
            log.error("Failed to fetch courses from catalog-service (batch). error={}", e.getMessage());
            return new HashMap<>();
        }
    }

    private CourseSimpleResponse toSimple(CourseFullResponse full) {
        if (full == null) return null;
        return CourseSimpleResponse.builder()
            .id(full.getId())
            .courseName(full.getCourseName())
            .professor(full.getProfessor())
            .build();
    }
}

