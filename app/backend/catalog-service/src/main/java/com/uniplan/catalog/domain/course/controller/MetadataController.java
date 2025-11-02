package com.uniplan.catalog.domain.course.controller;

import com.uniplan.catalog.domain.course.dto.MetadataResponse;
import com.uniplan.catalog.domain.course.service.MetadataQueryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Metadata query API controller
 */
@RestController
@RequestMapping("/metadata")
@RequiredArgsConstructor
@Tag(name = "Metadata", description = "Metadata query APIs")
public class MetadataController {

    private final MetadataQueryService metadataQueryService;

    @GetMapping("/course-types")
    @Operation(summary = "Get all course types", description = "Get list of all course types (전공필수, 전공선택, etc.)")
    public ResponseEntity<MetadataResponse.CourseTypesResponse> getCourseTypes() {
        return ResponseEntity.ok(metadataQueryService.getAllCourseTypes());
    }

    @GetMapping("/departments")
    @Operation(summary = "Get all departments", description = "Get list of all departments with their colleges")
    public ResponseEntity<MetadataResponse.DepartmentsResponse> getDepartments() {
        return ResponseEntity.ok(metadataQueryService.getAllDepartments());
    }

    @GetMapping("/colleges")
    @Operation(summary = "Get all colleges", description = "Get list of all colleges (단과대학)")
    public ResponseEntity<MetadataResponse.CollegesResponse> getColleges() {
        return ResponseEntity.ok(metadataQueryService.getAllColleges());
    }
}