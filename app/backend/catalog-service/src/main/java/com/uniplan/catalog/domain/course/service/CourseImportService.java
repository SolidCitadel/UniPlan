package com.uniplan.catalog.domain.course.service;

import com.uniplan.catalog.domain.course.dto.CourseImportRequest;
import com.uniplan.catalog.domain.course.dto.ImportResponse;
import com.uniplan.catalog.domain.course.entity.ClassTime;
import com.uniplan.catalog.domain.course.entity.College;
import com.uniplan.catalog.domain.course.entity.Course;
import com.uniplan.catalog.domain.course.entity.CourseType;
import com.uniplan.catalog.domain.course.entity.Department;
import com.uniplan.catalog.domain.course.repository.CollegeRepository;
import com.uniplan.catalog.domain.course.repository.CourseRepository;
import com.uniplan.catalog.domain.course.repository.CourseTypeRepository;
import com.uniplan.catalog.domain.course.repository.DepartmentRepository;
import com.uniplan.catalog.domain.university.entity.University;
import com.uniplan.catalog.domain.university.repository.UniversityRepository;
import jakarta.persistence.EntityManager;
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
    private final CollegeRepository collegeRepository;
    private final UniversityRepository universityRepository;
    private final EntityManager entityManager;

    private static final int BATCH_SIZE = 100;
    private static final String UNKNOWN_COLLEGE_CODE = "UNKNOWN";
    private static final String UNKNOWN_COLLEGE_NAME = "Unknown College";

    @Transactional
    public ImportResponse importCourses(List<CourseImportRequest> requests) {
        int totalCount = requests.size();
        int successCount = 0;
        int failureCount = 0;
        int updatedCount = 0;

        // Cache for departments, course types, and universities to reduce DB queries
        Map<String, Department> departmentCache = new HashMap<>();
        Map<String, CourseType> courseTypeCache = new HashMap<>();
        Map<Long, University> universityCache = new HashMap<>();

        List<Course> courseBatch = new ArrayList<>();

        for (int i = 0; i < requests.size(); i++) {
            CourseImportRequest request = requests.get(i);

            try {
                // Check for existing course (courseCode + section + year + semester + professor)
                var existingCourse = courseRepository.findByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
                    request.getCourseCode(),
                    request.getSection(),
                    request.getOpeningYear(),
                    request.getSemester(),
                    request.getProfessor()
                );

                if (existingCourse.isPresent()) {
                    // Update existing course
                    Course course = existingCourse.get();
                    updateCourse(course, request, departmentCache, courseTypeCache);
                    courseRepository.save(course);
                    updatedCount++;
                    log.debug("Updated existing course: {} ({})", request.getCourseName(), request.getCourseCode());
                    continue;
                }

                // Get or create departments (auto-create if missing)
                List<Department> departments = new ArrayList<>();
                if (request.getDepartmentCodes() != null && !request.getDepartmentCodes().isEmpty()) {
                    for (String deptCode : request.getDepartmentCodes()) {
                        Department department = departmentCache.computeIfAbsent(
                            deptCode,
                            code -> getOrCreateDepartment(code)
                        );
                        departments.add(department);
                    }
                }

                // Get or create course type (auto-create if missing)
                CourseType courseType = courseTypeCache.computeIfAbsent(
                    request.getCourseTypeCode(),
                    code -> getOrCreateCourseType(code)
                );

                // Get university (required)
                Long universityId = request.getUniversityId();
                if (universityId == null) {
                    universityId = 1L; // Default to KHU
                }
                University university = universityCache.computeIfAbsent(
                    universityId,
                    id -> universityRepository.findById(id)
                        .orElseThrow(() -> new IllegalArgumentException("University not found: " + id))
                );

                // Build course entity
                Course course = Course.builder()
                    .university(university)
                    .openingYear(request.getOpeningYear())
                    .semester(request.getSemester())
                    .targetGrade(request.getTargetGrade())
                    .courseCode(request.getCourseCode())
                    .section(request.getSection())
                    .courseName(request.getCourseName())
                    .professor(request.getProfessor())
                    .credits(request.getCredits())
                    .classroom(request.getClassroom())
                    .campus(request.getCampus())
                    .notes(request.getNotes())
                    .departments(departments)
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
                    try {
                        courseRepository.saveAll(courseBatch);
                        entityManager.flush();  // Explicitly flush to database
                        entityManager.clear();  // Clear persistence context
                        courseBatch.clear();
                        log.info("Imported {} / {} courses (updated: {})", successCount, totalCount, updatedCount);
                    } catch (Exception batchError) {
                        // If batch save fails, clear the persistence context and retry one by one
                        entityManager.clear();
                        log.warn("Batch save failed, retrying courses one by one: {}", batchError.getMessage());

                        int batchFailures = 0;
                        for (Course failedCourse : courseBatch) {
                            try {
                                courseRepository.save(failedCourse);
                                entityManager.flush();
                            } catch (Exception individualError) {
                                batchFailures++;
                                failureCount++;
                                successCount--;  // Decrement since we counted it earlier
                                log.error("Failed to save course: {} - {}",
                                    failedCourse.getCourseCode(), individualError.getMessage());
                                entityManager.clear();  // Clear after each failure
                            }
                        }
                        courseBatch.clear();
                        log.info("Batch completed with {} failures", batchFailures);
                    }
                }

            } catch (Exception e) {
                failureCount++;
                log.error("Failed to process course: {} - {}", request.getCourseCode(), e.getMessage());
                entityManager.clear();  // Clear persistence context on error
            }
        }

        String message = String.format("Course import completed. Total: %d, Created: %d, Updated: %d, Failure: %d",
            totalCount, successCount, updatedCount, failureCount);
        log.info(message);

        return ImportResponse.builder()
            .message(message)
            .totalCount(totalCount)
            .successCount(successCount + updatedCount)  // Both created and updated are "success"
            .failureCount(failureCount)
            .build();
    }

    /**
     * Get or create department. If not found, create with Unknown college.
     */
    private Department getOrCreateDepartment(String code) {
        return departmentRepository.findByCode(code)
            .orElseGet(() -> {
                log.warn("Department not found: {}. Creating with Unknown college.", code);

                // Get or create Unknown college
                College unknownCollege = getOrCreateUnknownCollege();

                // Create new department
                Department newDepartment = Department.builder()
                    .code(code)
                    .name("Unknown - " + code)
                    .college(unknownCollege)
                    .build();

                Department saved = departmentRepository.save(newDepartment);
                log.info("Created missing department: {} ({})", saved.getName(), saved.getCode());

                return saved;
            });
    }

    /**
     * Get or create Unknown college for missing departments.
     */
    private College getOrCreateUnknownCollege() {
        return collegeRepository.findByCode(UNKNOWN_COLLEGE_CODE)
            .orElseGet(() -> {
                College unknownCollege = College.builder()
                    .code(UNKNOWN_COLLEGE_CODE)
                    .name(UNKNOWN_COLLEGE_NAME)
                    .build();

                College saved = collegeRepository.save(unknownCollege);
                log.info("Created Unknown college: {} ({})", saved.getName(), saved.getCode());

                return saved;
            });
    }

    /**
     * Get or create course type. If not found, create with placeholder name.
     */
    private CourseType getOrCreateCourseType(String code) {
        return courseTypeRepository.findByCode(code)
            .orElseGet(() -> {
                log.warn("CourseType not found: {}. Creating placeholder.", code);

                CourseType newCourseType = CourseType.builder()
                    .code(code)
                    .nameKr("Unknown - " + code)
                    .nameEn("Unknown - " + code)
                    .build();

                CourseType saved = courseTypeRepository.save(newCourseType);
                log.info("Created missing CourseType: {} ({})", saved.getNameKr(), saved.getCode());

                return saved;
            });
    }

    /**
     * Delete all courses from database
     */
    @Transactional
    public ImportResponse deleteAllCourses() {
        log.info("Deleting all courses...");

        long count = courseRepository.count();
        courseRepository.deleteAll();

        String message = String.format("Successfully deleted %d courses", count);
        log.info(message);

        return ImportResponse.builder()
            .message(message)
            .totalCount((int) count)
            .successCount((int) count)
            .failureCount(0)
            .build();
    }

    /**
     * Update existing course with new data from request
     */
    private void updateCourse(Course course, CourseImportRequest request,
                              Map<String, Department> departmentCache,
                              Map<String, CourseType> courseTypeCache) {
        // Get course type
        CourseType courseType = courseTypeCache.computeIfAbsent(
            request.getCourseTypeCode(),
            code -> getOrCreateCourseType(code)
        );

        // Get departments
        List<Department> departments = new ArrayList<>();
        if (request.getDepartmentCodes() != null && !request.getDepartmentCodes().isEmpty()) {
            for (String deptCode : request.getDepartmentCodes()) {
                Department department = departmentCache.computeIfAbsent(
                    deptCode,
                    code -> getOrCreateDepartment(code)
                );
                departments.add(department);
            }
        }

        // Update course using domain method
        course.update(
            request.getCourseName(),
            request.getCredits(),
            request.getClassroom(),
            request.getCampus(),
            request.getNotes(),
            request.getTargetGrade(),
            courseType,
            departments
        );

        // Update class times
        List<ClassTime> newClassTimes = new ArrayList<>();
        if (request.getClassTime() != null) {
            for (CourseImportRequest.ClassTimeDto timeDto : request.getClassTime()) {
                ClassTime classTime = ClassTime.builder()
                    .course(course)
                    .day(timeDto.getDay())
                    .startTime(LocalTime.parse(timeDto.getStartTime()))
                    .endTime(LocalTime.parse(timeDto.getEndTime()))
                    .build();
                newClassTimes.add(classTime);
            }
        }
        course.replaceClassTimes(newClassTimes);
    }
}
