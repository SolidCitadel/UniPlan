package com.uniplan.catalog.domain.course.service;

import com.uniplan.catalog.domain.course.dto.CourseResponse;
import com.uniplan.catalog.domain.course.dto.CourseSearchRequest;
import com.uniplan.catalog.domain.course.entity.Course;
import com.uniplan.catalog.domain.course.repository.CourseRepository;
import com.uniplan.catalog.domain.course.repository.CourseSpecification;
import com.uniplan.catalog.global.exception.CourseNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Service for querying courses with dynamic filtering
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional(readOnly = true)
public class CourseQueryService {

    private final CourseRepository courseRepository;

    /**
     * Search courses with dynamic filtering and pagination
     */
    public Page<CourseResponse> searchCourses(CourseSearchRequest request, Pageable pageable) {
        Specification<Course> spec = CourseSpecification.fromSearchRequest(request);

        log.info("Searching courses with filters: {}", request);

        Page<Course> courses = courseRepository.findAll(spec, pageable);

        log.info("Found {} courses (page {} of {})",
            courses.getNumberOfElements(),
            courses.getNumber() + 1,
            courses.getTotalPages());

        return courses.map(CourseResponse::from);
    }

    /**
     * Get single course by ID
     */
    public CourseResponse getCourseById(Long id) {
        Course course = courseRepository.findById(id)
            .orElseThrow(() -> new CourseNotFoundException(id));

        return CourseResponse.from(course);
    }

    /**
     * Get multiple courses by IDs (Batch)
     */
    public java.util.List<CourseResponse> getCoursesByIds(java.util.List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return java.util.List.of();
        }

        return courseRepository.findAllById(ids).stream()
                .map(CourseResponse::from)
                .collect(java.util.stream.Collectors.toList());
    }
}
