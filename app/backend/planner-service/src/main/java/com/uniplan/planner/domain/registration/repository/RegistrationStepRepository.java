package com.uniplan.planner.domain.registration.repository;

import com.uniplan.planner.domain.registration.entity.RegistrationStep;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RegistrationStepRepository extends JpaRepository<RegistrationStep, Long> {

    List<RegistrationStep> findByRegistrationIdOrderByTimestampAsc(Long registrationId);
}