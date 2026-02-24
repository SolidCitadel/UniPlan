package com.uniplan.planner.global.client;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Facade for catalog-service API calls.
 * Delegates to CatalogFeignClient (OpenFeign) for actual HTTP communication.
 * Caches CourseFullResponse in Redis with 1-hour TTL.
 * All public methods return null (single) or empty map (batch) on failure — never throw.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class CatalogClient {

    private static final String CACHE_KEY_PREFIX = "course:";
    private static final Duration CACHE_TTL = Duration.ofHours(1);

    private final CatalogFeignClient feignClient;
    private final RedisTemplate<String, Object> redisTemplate;
    private final ObjectMapper objectMapper;

    /**
     * Get simple course information by ID (id, courseName, professor only).
     * Returns null if not found or on error.
     */
    public CourseSimpleResponse getCourseById(Long courseId) {
        CourseFullResponse full = getFullCourseById(courseId);
        return toSimple(full);
    }

    /**
     * Get full course information by ID (all fields including classTimes).
     * Returns null if not found or on error.
     */
    public CourseFullResponse getFullCourseById(Long courseId) {
        CourseFullResponse cached = getFromCache(courseId);
        if (cached != null) {
            log.debug("Cache hit for courseId={}", courseId);
            return cached;
        }

        try {
            CourseFullResponse course = feignClient.getCourseById(courseId);
            putToCache(courseId, course);
            return course;
        } catch (Exception e) {
            log.error("Failed to fetch course from catalog-service. courseId={}, error={}",
                courseId, e.getMessage());
            return null;
        }
    }

    /**
     * Get multiple simple courses by IDs (Batch).
     * Returns empty map on error.
     */
    public Map<Long, CourseSimpleResponse> getCoursesByIds(List<Long> courseIds) {
        Map<Long, CourseFullResponse> fullMap = getFullCoursesByIds(courseIds);
        Map<Long, CourseSimpleResponse> result = new HashMap<>();
        for (Map.Entry<Long, CourseFullResponse> entry : fullMap.entrySet()) {
            result.put(entry.getKey(), toSimple(entry.getValue()));
        }
        return result;
    }

    /**
     * Get multiple full courses by IDs (Batch).
     * Uses Redis MGET for efficient batch cache lookup, fetches only missing ones via Feign.
     */
    public Map<Long, CourseFullResponse> getFullCoursesByIds(List<Long> courseIds) {
        if (courseIds == null || courseIds.isEmpty()) {
            return new HashMap<>();
        }

        Map<Long, CourseFullResponse> result = new HashMap<>();
        List<Long> cacheMisses = new ArrayList<>();

        // Batch cache lookup with multiGet
        Map<Long, CourseFullResponse> cached = getMultiFromCache(courseIds);
        for (Long courseId : courseIds) {
            CourseFullResponse cachedCourse = cached.get(courseId);
            if (cachedCourse != null) {
                result.put(courseId, cachedCourse);
            } else {
                cacheMisses.add(courseId);
            }
        }

        if (!cacheMisses.isEmpty()) {
            log.debug("Cache miss for courseIds={}, fetching from catalog-service", cacheMisses);
            try {
                List<CourseFullResponse> fetched = feignClient.getCoursesByIds(cacheMisses);
                for (CourseFullResponse course : fetched) {
                    result.put(course.getId(), course);
                    putToCache(course.getId(), course);
                }
            } catch (Exception e) {
                log.error("Failed to fetch courses from catalog-service (batch). error={}", e.getMessage());
            }
        }

        return result;
    }

    private CourseFullResponse getFromCache(Long courseId) {
        try {
            ValueOperations<String, Object> ops = redisTemplate.opsForValue();
            Object cached = ops.get(CACHE_KEY_PREFIX + courseId);
            return convertToCourseFullResponse(cached);
        } catch (Exception e) {
            log.warn("Redis read failed for courseId={}, falling back to Feign. error={}", courseId, e.getMessage());
            return null;
        }
    }

    private Map<Long, CourseFullResponse> getMultiFromCache(List<Long> courseIds) {
        Map<Long, CourseFullResponse> result = new HashMap<>();
        try {
            List<String> keys = courseIds.stream()
                    .map(id -> CACHE_KEY_PREFIX + id)
                    .toList();
            List<Object> values = redisTemplate.opsForValue().multiGet(keys);
            if (values != null) {
                for (int i = 0; i < courseIds.size(); i++) {
                    CourseFullResponse converted = convertToCourseFullResponse(values.get(i));
                    if (converted != null) {
                        result.put(courseIds.get(i), converted);
                    }
                }
            }
        } catch (Exception e) {
            log.warn("Redis multiGet failed, falling back to Feign. error={}", e.getMessage());
        }
        return result;
    }

    private CourseFullResponse convertToCourseFullResponse(Object cached) {
        if (cached == null) return null;
        if (cached instanceof CourseFullResponse response) {
            return response;
        }
        // GenericJackson2JsonRedisSerializer may return LinkedHashMap
        try {
            return objectMapper.convertValue(cached, CourseFullResponse.class);
        } catch (Exception e) {
            log.warn("Failed to convert cached object to CourseFullResponse. error={}", e.getMessage());
            return null;
        }
    }

    private void putToCache(Long courseId, CourseFullResponse course) {
        if (course == null) return;
        try {
            ValueOperations<String, Object> ops = redisTemplate.opsForValue();
            ops.set(CACHE_KEY_PREFIX + courseId, course, CACHE_TTL);
        } catch (Exception e) {
            log.warn("Redis write failed for courseId={}. error={}", courseId, e.getMessage());
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
