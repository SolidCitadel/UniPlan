package com.uniplan.catalog.domain.course.repository;

import com.uniplan.catalog.domain.course.entity.CourseType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CourseTypeRepository extends JpaRepository<CourseType, Long> {
    Optional<CourseType> findByCode(String code);
    boolean existsByCode(String code);
}
