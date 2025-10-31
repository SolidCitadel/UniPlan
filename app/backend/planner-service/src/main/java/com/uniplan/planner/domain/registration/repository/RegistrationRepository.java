package com.uniplan.planner.domain.registration.repository;

import com.uniplan.planner.domain.registration.entity.Registration;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RegistrationRepository extends JpaRepository<Registration, Long> {

    List<Registration> findByUserId(Long userId);

    List<Registration> findByUserIdAndStatus(Long userId, RegistrationStatus status);

    Optional<Registration> findByIdAndUserId(Long id, Long userId);
}