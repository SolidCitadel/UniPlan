package com.uniplan.catalog.domain.course.service;

import com.uniplan.catalog.domain.course.dto.ImportResponse;
import com.uniplan.catalog.domain.course.dto.MetadataImportRequest;
import com.uniplan.catalog.domain.course.entity.College;
import com.uniplan.catalog.domain.course.entity.CourseType;
import com.uniplan.catalog.domain.course.entity.Department;
import com.uniplan.catalog.domain.course.repository.CollegeRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class MetadataImportService {

    private final CollegeRepository collegeRepository;
    private final DepartmentRepository departmentRepository;
    private final CourseTypeRepository courseTypeRepository;

    @Transactional
    public ImportResponse importMetadata(MetadataImportRequest request) {
        int totalCount = 0;
        int successCount = 0;
        int failureCount = 0;

        // 1. Import Colleges
        Map<String, College> collegeMap = new HashMap<>();
        if (request.getColleges() != null) {
            for (MetadataImportRequest.CollegeDto dto : request.getColleges().values()) {
                totalCount++;
                try {
                    College college = collegeRepository.findByCode(dto.getCode())
                        .orElseGet(() -> College.builder()
                            .code(dto.getCode())
                            .name(dto.getName())
                            .nameEn(dto.getNameEn())
                            .build());

                    college = collegeRepository.save(college);
                    collegeMap.put(dto.getCode(), college);
                    successCount++;
                    log.debug("Imported college: {} ({})", dto.getName(), dto.getCode());
                } catch (Exception e) {
                    failureCount++;
                    log.error("Failed to import college: {} - {}", dto.getCode(), e.getMessage());
                }
            }
        }

        // 2. Import Course Types
        if (request.getCourseTypes() != null) {
            for (MetadataImportRequest.CourseTypeDto dto : request.getCourseTypes().values()) {
                totalCount++;
                try {
                    CourseType courseType = courseTypeRepository.findByCode(dto.getCode())
                        .orElseGet(() -> CourseType.builder()
                            .code(dto.getCode())
                            .nameKr(dto.getNameKr())
                            .nameEn(dto.getNameEn())
                            .build());

                    courseTypeRepository.save(courseType);
                    successCount++;
                    log.debug("Imported course type: {} ({})", dto.getNameKr(), dto.getCode());
                } catch (Exception e) {
                    failureCount++;
                    log.error("Failed to import course type: {} - {}", dto.getCode(), e.getMessage());
                }
            }
        }

        // 3. Import Departments (depends on Colleges)
        if (request.getDepartments() != null) {
            for (MetadataImportRequest.DepartmentDto dto : request.getDepartments().values()) {
                totalCount++;
                try {
                    College college = collegeMap.get(dto.getCollegeCode());
                    if (college == null) {
                        college = collegeRepository.findByCode(dto.getCollegeCode())
                            .orElseThrow(() -> new IllegalArgumentException("College not found: " + dto.getCollegeCode()));
                    }

                    final College finalCollege = college;
                    Department department = departmentRepository.findByCode(dto.getCode())
                        .orElseGet(() -> Department.builder()
                            .code(dto.getCode())
                            .name(dto.getName())
                            .nameEn(dto.getNameEn())
                            .college(finalCollege)
                            .level(dto.getLevel())
                            .build());

                    departmentRepository.save(department);
                    successCount++;
                    log.debug("Imported department: {} ({})", dto.getName(), dto.getCode());
                } catch (Exception e) {
                    failureCount++;
                    log.error("Failed to import department: {} - {}", dto.getCode(), e.getMessage());
                }
            }
        }

        String message = String.format("Metadata import completed. Total: %d, Success: %d, Failure: %d",
            totalCount, successCount, failureCount);
        log.info(message);

        return ImportResponse.builder()
            .message(message)
            .totalCount(totalCount)
            .successCount(successCount)
            .failureCount(failureCount)
            .build();
    }
}
