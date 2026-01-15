package com.uniplan.user.domain.university.repository;

import com.uniplan.user.domain.university.entity.University;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UniversityRepository extends JpaRepository<University, Long> {
    Optional<University> findByCode(String code);
}
