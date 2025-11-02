package com.uniplan.planner.domain.registration.service;

import com.uniplan.planner.domain.registration.dto.*;
import com.uniplan.planner.domain.registration.entity.Registration;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import com.uniplan.planner.domain.registration.entity.RegistrationStep;
import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.registration.repository.RegistrationStepRepository;
import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.global.exception.RegistrationNotFoundException;
import com.uniplan.planner.global.exception.ScenarioNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RegistrationService {

    private final RegistrationRepository registrationRepository;
    private final RegistrationStepRepository registrationStepRepository;
    private final ScenarioRepository scenarioRepository;

    @Transactional
    public RegistrationResponse startRegistration(Long userId, StartRegistrationRequest request) {
        // 시나리오 조회
        Scenario startScenario = scenarioRepository.findByIdAndUserId(request.getScenarioId(), userId)
                .orElseThrow(() -> new ScenarioNotFoundException(request.getScenarioId()));

        // 수강신청 세션 생성
        Registration registration = Registration.builder()
                .userId(userId)
                .startScenario(startScenario)
                .currentScenario(startScenario)
                .status(RegistrationStatus.IN_PROGRESS)
                .build();

        Registration savedRegistration = registrationRepository.save(registration);
        return RegistrationResponse.from(savedRegistration);
    }

    @Transactional
    public RegistrationResponse addStep(Long userId, Long registrationId, AddStepRequest request) {
        // 수강신청 세션 조회
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));

        if (!registration.isInProgress()) {
            throw new IllegalStateException("진행 중인 수강신청이 아닙니다");
        }

        Scenario currentScenario = registration.getCurrentScenario();
        Scenario nextScenario = null;

        // 자동 네비게이션: 실패한 과목이 있으면 대안 시나리오 찾기
        if (!request.getFailedCourses().isEmpty()) {
            // 실패한 과목들의 Set을 만들어서 네비게이션
            java.util.Set<Long> failedCourseSet = new java.util.HashSet<>(request.getFailedCourses());

            Optional<Scenario> alternativeScenario = scenarioRepository
                    .findAlternativeScenario(currentScenario.getId(), failedCourseSet);

            if (alternativeScenario.isPresent()) {
                nextScenario = alternativeScenario.get();
                registration.navigateToScenario(nextScenario);
                log.info("Navigated from scenario {} to {} due to failed courses {}",
                        currentScenario.getId(), nextScenario.getId(), failedCourseSet);
            } else {
                log.warn("No alternative scenario found for failed courses {} in scenario {}",
                        failedCourseSet, currentScenario.getId());
            }
        }

        // 단계 기록
        RegistrationStep step = RegistrationStep.builder()
                .registration(registration)
                .scenario(currentScenario)
                .succeededCourses(request.getSucceededCourses())
                .failedCourses(request.getFailedCourses())
                .canceledCourses(request.getCanceledCourses())
                .nextScenario(nextScenario)
                .notes(request.getNotes())
                .build();

        registration.addStep(step);
        registrationStepRepository.save(step);

        return RegistrationResponse.from(registration);
    }

    public RegistrationResponse getRegistration(Long userId, Long registrationId) {
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));
        return RegistrationResponse.from(registration);
    }

    public List<RegistrationResponse> getUserRegistrations(Long userId) {
        List<Registration> registrations = registrationRepository.findByUserId(userId);
        return registrations.stream()
                .map(RegistrationResponse::from)
                .collect(Collectors.toList());
    }

    public List<RegistrationResponse> getUserRegistrationsByStatus(Long userId, RegistrationStatus status) {
        List<Registration> registrations = registrationRepository.findByUserIdAndStatus(userId, status);
        return registrations.stream()
                .map(RegistrationResponse::from)
                .collect(Collectors.toList());
    }

    @Transactional
    public RegistrationResponse completeRegistration(Long userId, Long registrationId) {
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));

        if (!registration.isInProgress()) {
            throw new IllegalStateException("이미 완료되었거나 취소된 수강신청입니다");
        }

        registration.complete();
        return RegistrationResponse.from(registration);
    }

    @Transactional
    public void cancelRegistration(Long userId, Long registrationId) {
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));

        if (!registration.isInProgress()) {
            throw new IllegalStateException("이미 완료되었거나 취소된 수강신청입니다");
        }

        registration.cancel();
    }

    /**
     * 지금까지 성공한 모든 과목 조회
     */
    public List<Long> getAllSucceededCourses(Long userId, Long registrationId) {
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));

        return registration.getSteps().stream()
                .flatMap(step -> step.getSucceededCourses().stream())
                .distinct()
                .collect(Collectors.toList());
    }

    /**
     * 사용자의 모든 수강신청 삭제
     */
    @Transactional
    public void deleteAllUserRegistrations(Long userId) {
        List<Registration> registrations = registrationRepository.findByUserId(userId);
        registrationRepository.deleteAll(registrations);
    }
}