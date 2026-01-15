package com.uniplan.catalog.domain.course.repository;

import com.uniplan.catalog.domain.course.dto.CourseSearchRequest;
import com.uniplan.catalog.domain.course.entity.ClassTime;
import com.uniplan.catalog.domain.course.entity.Course;
import jakarta.persistence.criteria.*;
import org.springframework.data.jpa.domain.Specification;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Dynamic query specification for Course entity
 */
public class CourseSpecification {

    /**
     * Build specification from search request
     */
    public static Specification<Course> fromSearchRequest(CourseSearchRequest request) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // University filter (required for proper data isolation)
            if (request.getUniversityId() != null) {
                predicates.add(criteriaBuilder.equal(root.get("university").get("id"), request.getUniversityId()));
            }

            // Basic filters
            if (request.getOpeningYear() != null) {
                predicates.add(criteriaBuilder.equal(root.get("openingYear"), request.getOpeningYear()));
            }

            if (request.getSemester() != null && !request.getSemester().isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("semester"), request.getSemester()));
            }

            if (request.getCourseName() != null && !request.getCourseName().isBlank()) {
                predicates.add(criteriaBuilder.like(
                    root.get("courseName"),
                    "%" + request.getCourseName() + "%"
                ));
            }

            if (request.getCourseCode() != null && !request.getCourseCode().isBlank()) {
                predicates.add(criteriaBuilder.like(
                    root.get("courseCode"),
                    "%" + request.getCourseCode() + "%"
                ));
            }

            if (request.getProfessor() != null && !request.getProfessor().isBlank()) {
                predicates.add(criteriaBuilder.like(
                    root.get("professor"),
                    "%" + request.getProfessor() + "%"
                ));
            }

            if (request.getTargetGrade() != null) {
                predicates.add(criteriaBuilder.equal(root.get("targetGrade"), request.getTargetGrade()));
            }

            if (request.getCampus() != null && !request.getCampus().isBlank()) {
                predicates.add(criteriaBuilder.equal(root.get("campus"), request.getCampus()));
            }

            // Department filter (join)
            if ((request.getDepartmentCode() != null && !request.getDepartmentCode().isBlank())
                || (request.getDepartmentName() != null && !request.getDepartmentName().isBlank())) {
                Join<Object, Object> department = root.join("departments");

                if (request.getDepartmentCode() != null && !request.getDepartmentCode().isBlank()) {
                    predicates.add(criteriaBuilder.equal(department.get("code"), request.getDepartmentCode()));
                }

                if (request.getDepartmentName() != null && !request.getDepartmentName().isBlank()) {
                    predicates.add(criteriaBuilder.like(
                        department.get("name"),
                        "%" + request.getDepartmentName() + "%"
                    ));
                }
            }

            // Course type filter (join)
            if (request.getCourseTypeCode() != null && !request.getCourseTypeCode().isBlank()) {
                Join<Object, Object> courseType = root.join("courseType");
                predicates.add(criteriaBuilder.equal(courseType.get("code"), request.getCourseTypeCode()));
            }

            // Credit filters
            if (request.getMinCredits() != null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(
                    root.get("credits"),
                    request.getMinCredits()
                ));
            }

            if (request.getMaxCredits() != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(
                    root.get("credits"),
                    request.getMaxCredits()
                ));
            }

            // Time filters (join with ClassTime)
            if (request.getDayOfWeek() != null && !request.getDayOfWeek().isBlank()) {
                Subquery<Long> subquery = query.subquery(Long.class);
                Root<ClassTime> classTimeRoot = subquery.from(ClassTime.class);
                subquery.select(classTimeRoot.get("course").get("id"));
                subquery.where(criteriaBuilder.and(
                    criteriaBuilder.equal(classTimeRoot.get("course"), root),
                    criteriaBuilder.equal(classTimeRoot.get("day"), request.getDayOfWeek())
                ));
                predicates.add(criteriaBuilder.exists(subquery));
            }

            if (request.getStartTimeAfter() != null && !request.getStartTimeAfter().isBlank()) {
                LocalTime time = LocalTime.parse(request.getStartTimeAfter());
                Subquery<Long> subquery = query.subquery(Long.class);
                Root<ClassTime> classTimeRoot = subquery.from(ClassTime.class);
                subquery.select(classTimeRoot.get("course").get("id"));
                subquery.where(criteriaBuilder.and(
                    criteriaBuilder.equal(classTimeRoot.get("course"), root),
                    criteriaBuilder.greaterThanOrEqualTo(classTimeRoot.get("startTime"), time)
                ));
                predicates.add(criteriaBuilder.exists(subquery));
            }

            if (request.getStartTimeBefore() != null && !request.getStartTimeBefore().isBlank()) {
                LocalTime time = LocalTime.parse(request.getStartTimeBefore());
                Subquery<Long> subquery = query.subquery(Long.class);
                Root<ClassTime> classTimeRoot = subquery.from(ClassTime.class);
                subquery.select(classTimeRoot.get("course").get("id"));
                subquery.where(criteriaBuilder.and(
                    criteriaBuilder.equal(classTimeRoot.get("course"), root),
                    criteriaBuilder.lessThanOrEqualTo(classTimeRoot.get("startTime"), time)
                ));
                predicates.add(criteriaBuilder.exists(subquery));
            }

            // Combine all predicates with AND
            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
    }
}
