package com.uniplan.planner.domain.registration.service;

import com.uniplan.planner.domain.registration.dto.*;
import com.uniplan.planner.domain.registration.entity.Registration;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import com.uniplan.planner.domain.registration.entity.RegistrationStep;
import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.registration.repository.RegistrationStepRepository;
import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.exception.RegistrationNotFoundException;
import com.uniplan.planner.global.exception.ScenarioNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class RegistrationService {

    private final RegistrationRepository registrationRepository;
    private final RegistrationStepRepository registrationStepRepository;
    private final ScenarioRepository scenarioRepository;
    private final CatalogClient catalogClient;

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

        Set<Long> courseIds = new HashSet<>();
        collectCourseIdsFromScenarioTree(savedRegistration.getStartScenario(), courseIds);
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(courseIds));

        return RegistrationResponse.from(savedRegistration, courseMap);
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
            // 이전까지 누적된 실패 과목 (현재 단계 이전까지)
            Set<Long> previouslyFailed = new HashSet<>(registration.getAllFailedCourses());

            // 이번 단계에서 새로 실패한 과목만 추출
            Set<Long> newlyFailed = request.getFailedCourses().stream()
                    .filter(id -> !previouslyFailed.contains(id))
                    .collect(Collectors.toSet());

            log.debug("Previously failed: {}, Request failed: {}, Newly failed: {}",
                    previouslyFailed, request.getFailedCourses(), newlyFailed);

            if (!newlyFailed.isEmpty()) {
                Optional<Scenario> alternativeScenario = scenarioRepository
                        .findAlternativeScenario(currentScenario.getId(), newlyFailed);

                if (alternativeScenario.isPresent()) {
                    nextScenario = alternativeScenario.get();
                    registration.navigateToScenario(nextScenario);
                    log.info("Navigated from scenario {} to {} due to newly failed courses {}",
                            currentScenario.getId(), nextScenario.getId(), newlyFailed);
                } else {
                    log.warn("No alternative scenario found for newly failed courses {} in scenario {}",
                            newlyFailed, currentScenario.getId());
                }
            } else {
                log.debug("No newly failed courses (all were already failed in previous steps), staying at scenario {}",
                        currentScenario.getId());
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

        Set<Long> courseIds = new HashSet<>();
        collectCourseIdsFromScenarioTree(registration.getStartScenario(), courseIds);
        collectCourseIdsFromScenarioTree(registration.getCurrentScenario(), courseIds);
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(courseIds));

        return RegistrationResponse.from(registration, courseMap);
    }

    public RegistrationResponse getRegistration(Long userId, Long registrationId) {
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));

        // Collect all course IDs from start and current scenarios (including children)
        Set<Long> allCourseIds = new HashSet<>();
        collectCourseIdsFromScenarioTree(registration.getStartScenario(), allCourseIds);
        collectCourseIdsFromScenarioTree(registration.getCurrentScenario(), allCourseIds);

        // Fetch course details
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(allCourseIds));

        return RegistrationResponse.from(registration, courseMap);
    }

    public List<RegistrationResponse> getUserRegistrations(Long userId) {
        List<Registration> registrations = registrationRepository.findByUserId(userId);

        // Collect all course IDs (including children)
        Set<Long> allCourseIds = new HashSet<>();
        for (Registration reg : registrations) {
            collectCourseIdsFromScenarioTree(reg.getStartScenario(), allCourseIds);
            collectCourseIdsFromScenarioTree(reg.getCurrentScenario(), allCourseIds);
        }
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(allCourseIds));

        return registrations.stream()
                .map(r -> RegistrationResponse.from(r, courseMap))
                .collect(Collectors.toList());
    }

    public List<RegistrationResponse> getUserRegistrationsByStatus(Long userId, RegistrationStatus status) {
        List<Registration> registrations = registrationRepository.findByUserIdAndStatus(userId, status);

        // Collect all course IDs (including children)
        Set<Long> allCourseIds = new HashSet<>();
        for (Registration reg : registrations) {
            collectCourseIdsFromScenarioTree(reg.getStartScenario(), allCourseIds);
            collectCourseIdsFromScenarioTree(reg.getCurrentScenario(), allCourseIds);
        }
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(allCourseIds));

        return registrations.stream()
                .map(r -> RegistrationResponse.from(r, courseMap))
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

        Set<Long> courseIds = new HashSet<>();
        collectCourseIdsFromScenarioTree(registration.getStartScenario(), courseIds);
        collectCourseIdsFromScenarioTree(registration.getCurrentScenario(), courseIds);
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(courseIds));

        return RegistrationResponse.from(registration, courseMap);
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
     * 단일 수강신청 삭제
     */
    @Transactional
    public void deleteRegistration(Long userId, Long registrationId) {
        Registration registration = registrationRepository.findByIdAndUserId(registrationId, userId)
                .orElseThrow(() -> new RegistrationNotFoundException(registrationId));
        registrationRepository.delete(registration);
    }

    /**
     * 사용자의 모든 수강신청 삭제
     */
    @Transactional
    public void deleteAllUserRegistrations(Long userId) {
        List<Registration> registrations = registrationRepository.findByUserId(userId);
        registrationRepository.deleteAll(registrations);
    }

    /**
     * Helper method to collect course IDs from a scenario's timetable (items + excluded)
     */
    private void collectCourseIdsFromScenario(Scenario scenario, Set<Long> courseIds) {
        if (scenario != null && scenario.getTimetable() != null) {
            scenario.getTimetable().getItems().stream()
                    .map(TimetableItem::getCourseId)
                    .forEach(courseIds::add);
            courseIds.addAll(scenario.getTimetable().getExcludedCourseIds());
        }
    }

    /**
     * Helper method to recursively collect course IDs from a scenario tree (including children)
     */
    private void collectCourseIdsFromScenarioTree(Scenario scenario, Set<Long> courseIds) {
        if (scenario == null) {
            return;
        }

        // Collect from current scenario
        collectCourseIdsFromScenario(scenario, courseIds);

        // Recursively collect from child scenarios
        if (scenario.getChildScenarios() != null) {
            for (Scenario child : scenario.getChildScenarios()) {
                collectCourseIdsFromScenarioTree(child, courseIds);
            }
        }
    }
}