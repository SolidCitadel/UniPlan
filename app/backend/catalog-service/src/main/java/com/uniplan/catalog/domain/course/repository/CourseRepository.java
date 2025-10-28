package com.uniplan.catalog.domain.course.repository;

import com.uniplan.catalog.domain.course.entity.Course;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseRepository extends JpaRepository<Course, Long> {
}
