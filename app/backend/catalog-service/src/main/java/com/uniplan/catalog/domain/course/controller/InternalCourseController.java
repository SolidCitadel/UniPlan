package com.uniplan.catalog.domain.course.controller;

import com.uniplan.catalog.domain.course.dto.CourseResponse;
import com.uniplan.catalog.domain.course.service.CourseQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Internal API for Service-to-Service communication.
 * These endpoints should only be accessed by internal microservices (e.g., planner-service).
 * Access from external clients (Gateway) must be blocked.
 */
@RestController
@RequestMapping("/internal/courses")
@RequiredArgsConstructor
@Tag(name = "Internal Course", description = "Internal APIs for microservice communication")
public class InternalCourseController {

    private final CourseQueryService courseQueryService;

    @GetMapping
    @Operation(summary = "Get courses by IDs (Batch)", description = "Get multiple courses by their IDs. Used for N+1 optimization.")
    public ResponseEntity<List<CourseResponse>> getCoursesByIds(@RequestParam List<Long> ids) {
        List<CourseResponse> courses = courseQueryService.getCoursesByIds(ids);
        return ResponseEntity.ok(courses);
    }
}
