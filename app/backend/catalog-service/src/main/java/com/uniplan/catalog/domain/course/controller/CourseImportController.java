package com.uniplan.catalog.domain.course.controller;

import com.uniplan.catalog.domain.course.dto.CourseImportRequest;
import com.uniplan.catalog.domain.course.dto.ImportResponse;
import com.uniplan.catalog.domain.course.dto.MetadataImportRequest;
import com.uniplan.catalog.domain.course.service.CourseImportService;
import com.uniplan.catalog.domain.course.service.MetadataImportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Course Import", description = "Course data import APIs")
public class CourseImportController {

    private final MetadataImportService metadataImportService;
    private final CourseImportService courseImportService;

    @PostMapping("/metadata/import")
    @Operation(summary = "Import metadata (colleges, departments, course types)")
    public ResponseEntity<ImportResponse> importMetadata(@RequestBody MetadataImportRequest request) {
        log.info("Received metadata import request for year: {}, semester: {}", request.getYear(), request.getSemester());
        ImportResponse response = metadataImportService.importMetadata(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/courses/import")
    @Operation(summary = "Import course data (bulk)")
    public ResponseEntity<ImportResponse> importCourses(@RequestBody List<CourseImportRequest> requests) {
        log.info("Received course import request with {} courses", requests.size());
        ImportResponse response = courseImportService.importCourses(requests);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/courses")
    @Operation(summary = "Delete all courses", description = "Delete all courses from database (use with caution)")
    public ResponseEntity<ImportResponse> deleteAllCourses() {
        log.warn("Received request to delete all courses");
        ImportResponse response = courseImportService.deleteAllCourses();
        return ResponseEntity.ok(response);
    }
}
