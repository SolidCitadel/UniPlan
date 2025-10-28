package com.uniplan.catalog.domain.course.service;

import com.uniplan.catalog.domain.course.dto.CourseImportRequest;
import com.uniplan.catalog.domain.course.dto.ImportResponse;
import com.uniplan.catalog.domain.course.entity.ClassTime;
import com.uniplan.catalog.domain.course.entity.Course;
import com.uniplan.catalog.domain.course.entity.CourseType;
import com.uniplan.catalog.domain.course.entity.Department;
import com.uniplan.catalog.domain.course.repository.CourseRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class CourseImportService {

    private final CourseRepository courseRepository;
    private final DepartmentRepository departmentRepository;
    private final CourseTypeRepository courseTypeRepository;

    private static final int BATCH_SIZE = 100;

    @Transactional
    public ImportResponse importCourses(List<CourseImportRequest> requests) {
        int totalCount = requests.size();
        int successCount = 0;
        int failureCount = 0;

        // Cache for departments and course types to reduce DB queries
        Map<String, Department> departmentCache = new HashMap<>();
        Map<String, CourseType> courseTypeCache = new HashMap<>();

        List<Course> courseBatch = new ArrayList<>();

        for (int i = 0; i < requests.size(); i++) {
            CourseImportRequest request = requests.get(i);

            try {
                // Get or fetch department
                Department department = departmentCache.computeIfAbsent(
                    request.getDepartmentCode(),
                    code -> departmentRepository.findByCode(code)
                        .orElseThrow(() -> new IllegalArgumentException("Department not found: " + code))
                );

                // Get or fetch course type
                CourseType courseType = courseTypeCache.computeIfAbsent(
                    request.getCourseTypeCode(),
                    code -> courseTypeRepository.findByCode(code)
                        .orElseThrow(() -> new IllegalArgumentException("CourseType not found: " + code))
                );

                // Build course entity
                Course course = Course.builder()
                    .openingYear(request.getOpeningYear())
                    .semester(request.getSemester())
                    .targetGrade(request.getTargetGrade())
                    .courseCode(request.getCourseCode())
                    .courseName(request.getCourseName())
                    .professor(request.getProfessor())
                    .credits(request.getCredits())
                    .classroom(request.getClassroom())
                    .campus(request.getCampus())
                    .notes(request.getNotes())
                    .department(department)
                    .courseType(courseType)
                    .classTimes(new ArrayList<>())
                    .build();

                // Add class times
                if (request.getClassTime() != null) {
                    for (CourseImportRequest.ClassTimeDto timeDto : request.getClassTime()) {
                        ClassTime classTime = ClassTime.builder()
                            .course(course)
                            .day(timeDto.getDay())
                            .startTime(LocalTime.parse(timeDto.getStartTime()))
                            .endTime(LocalTime.parse(timeDto.getEndTime()))
                            .build();
                        course.getClassTimes().add(classTime);
                    }
                }

                courseBatch.add(course);
                successCount++;

                // Save in batches
                if (courseBatch.size() >= BATCH_SIZE || i == requests.size() - 1) {
                    courseRepository.saveAll(courseBatch);
                    courseBatch.clear();
                    log.info("Imported {} / {} courses", i + 1, totalCount);
                }

            } catch (Exception e) {
                failureCount++;
                log.error("Failed to import course: {} - {}", request.getCourseCode(), e.getMessage());
            }
        }

        String message = String.format("Course import completed. Total: %d, Success: %d, Failure: %d",
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
