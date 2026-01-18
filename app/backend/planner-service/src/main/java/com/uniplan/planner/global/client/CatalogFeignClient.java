package com.uniplan.planner.global.client;

import com.uniplan.planner.global.client.dto.CourseFullResponse;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * OpenFeign client for catalog-service APIs.
 * Declarative HTTP client that replaces RestTemplate-based calls.
 */
@FeignClient(name = "catalog-service", url = "${services.catalog.url}")
public interface CatalogFeignClient {

    /**
     * Get course by ID (public API)
     */
    @GetMapping("/courses/{id}")
    CourseFullResponse getCourseById(@PathVariable("id") Long id);

    /**
     * Get multiple courses by IDs (internal batch API)
     */
    @GetMapping("/internal/courses")
    List<CourseFullResponse> getCoursesByIds(@RequestParam("ids") List<Long> ids);
}
