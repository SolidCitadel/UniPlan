package com.uniplan.catalog.domain.course.controller;

import com.uniplan.catalog.domain.course.dto.CourseResponse;
import com.uniplan.catalog.domain.course.dto.CourseSearchRequest;
import com.uniplan.catalog.domain.course.service.CourseQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Course query API controller
 */
@RestController
@RequestMapping("/courses")
@RequiredArgsConstructor
@Tag(name = "Course", description = "Course query APIs")
public class CourseController {

    private final CourseQueryService courseQueryService;

    @GetMapping
    @Operation(summary = "Search courses", description = "Search courses with dynamic filtering and pagination")
    public ResponseEntity<Page<CourseResponse>> searchCourses(
        @Parameter(description = "Search filters") @ModelAttribute CourseSearchRequest request,
        @PageableDefault(size = 20, sort = "id", direction = Sort.Direction.ASC) Pageable pageable
    ) {
        Page<CourseResponse> courses = courseQueryService.searchCourses(request, pageable);
        return ResponseEntity.ok(courses);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Get course by ID", description = "Get single course details by ID")
    public ResponseEntity<CourseResponse> getCourseById(
        @Parameter(description = "Course ID") @PathVariable Long id
    ) {
        CourseResponse course = courseQueryService.getCourseById(id);
        return ResponseEntity.ok(course);
    }
}
