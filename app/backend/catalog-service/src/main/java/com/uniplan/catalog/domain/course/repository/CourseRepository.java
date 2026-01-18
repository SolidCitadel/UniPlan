package com.uniplan.catalog.domain.course.repository;

import com.uniplan.catalog.domain.course.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface CourseRepository extends JpaRepository<Course, Long>, JpaSpecificationExecutor<Course> {

    /**
     * Check if a course exists by courseCode, section, openingYear, semester, and professor.
     * Used for duplicate detection during import.
     * Note: Same course can be taught by different professors (different sections)
     */
    boolean existsByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
        String courseCode,
        String section,
        Integer openingYear,
        String semester,
        String professor
    );

    /**
     * Find a course by courseCode, section, openingYear, semester, and professor.
     * Used for upsert during import.
     */
    java.util.Optional<Course> findByCourseCodeAndSectionAndOpeningYearAndSemesterAndProfessor(
        String courseCode,
        String section,
        Integer openingYear,
        String semester,
        String professor
    );
}
