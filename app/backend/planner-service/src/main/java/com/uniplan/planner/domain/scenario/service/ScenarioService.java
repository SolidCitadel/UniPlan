package com.uniplan.planner.domain.scenario.service;

import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.scenario.dto.*;
import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import com.uniplan.planner.global.exception.ScenarioNotFoundException;
import com.uniplan.planner.global.exception.TimetableNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ScenarioService {

    private final ScenarioRepository scenarioRepository;
    private final TimetableRepository timetableRepository;
    private final RegistrationRepository registrationRepository;
    private final CatalogClient catalogClient;

    @Transactional
    public ScenarioResponse createRootScenario(Long userId, CreateScenarioRequest request) {
        // 시간표 정보 검증
        if (request.getExistingTimetableId() == null && request.getTimetableRequest() == null) {
            throw new IllegalArgumentException("existingTimetableId 또는 timetableRequest 중 하나는 필수입니다");
        }

        // 시간표 생성 또는 기존 시간표 사용
        Timetable timetable = createOrGetTimetable(userId, request);

        Scenario scenario = Scenario.builder()
                .userId(userId)
                .name(request.getName())
                .description(request.getDescription())
                .timetable(timetable)
                .parentScenario(null)  // 루트 시나리오
                .failedCourseIds(new java.util.HashSet<>())  // 기본 시나리오
                .orderIndex(0)
                .build();

        Scenario savedScenario = scenarioRepository.save(scenario);
        return ScenarioResponse.from(savedScenario);
    }

    @Transactional
    public ScenarioResponse createAlternativeScenario(Long userId, Long parentScenarioId,
                                                     CreateAlternativeScenarioRequest request) {
        // 시간표 정보 검증
        if (request.getExistingTimetableId() == null && request.getTimetableRequest() == null) {
            throw new IllegalArgumentException("existingTimetableId 또는 timetableRequest 중 하나는 필수입니다");
        }

        // 부모 시나리오 조회
        Scenario parentScenario = scenarioRepository.findByIdAndUserId(parentScenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(parentScenarioId));

        // 시간표 생성 또는 기존 시간표 사용
        Timetable timetable;
        if (request.getExistingTimetableId() != null) {
            timetable = timetableRepository.findByIdAndUserId(request.getExistingTimetableId(), userId)
                    .orElseThrow(() -> new TimetableNotFoundException(request.getExistingTimetableId()));
        } else {
            timetable = createTimetableFromRequest(userId, request.getTimetableRequest());
        }

        Scenario alternativeScenario = Scenario.builder()
                .userId(userId)
                .name(request.getName())
                .description(request.getDescription())
                .timetable(timetable)
                .parentScenario(parentScenario)
                .failedCourseIds(request.getFailedCourseIds())
                .orderIndex(request.getOrderIndex() != null ? request.getOrderIndex() : 0)
                .build();

        Scenario savedScenario = scenarioRepository.save(alternativeScenario);
        return ScenarioResponse.from(savedScenario);
    }

    public List<ScenarioResponse> getRootScenarios(Long userId) {
        List<Scenario> rootScenarios = scenarioRepository.findByUserIdAndParentScenarioIsNull(userId);
        return rootScenarios.stream()
                .map(ScenarioResponse::from)
                .collect(Collectors.toList());
    }

    public ScenarioResponse getScenario(Long userId, Long scenarioId) {
        Scenario scenario = scenarioRepository.findByIdAndUserId(scenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(scenarioId));
        return ScenarioResponse.from(scenario);
    }

    public ScenarioResponse getScenarioWithFullTree(Long userId, Long scenarioId) {
        Scenario scenario = scenarioRepository.findByIdAndUserId(scenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(scenarioId));

        // Collect all course IDs from the entire scenario tree
        Set<Long> allCourseIds = new HashSet<>();
        collectCourseIds(scenario, allCourseIds);

        // Fetch all courses with full details at once
        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(new ArrayList<>(allCourseIds));

        return ScenarioResponse.fromWithFullTreeAndCourses(scenario, courseMap);
    }

    @Transactional
    public ScenarioResponse updateScenario(Long userId, Long scenarioId, UpdateScenarioRequest request) {
        Scenario scenario = scenarioRepository.findByIdAndUserId(scenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(scenarioId));

        scenario.updateInfo(request.getName(), request.getDescription());
        return ScenarioResponse.from(scenario);
    }

    @Transactional
    public void deleteScenario(Long userId, Long scenarioId) {
        Scenario scenario = scenarioRepository.findByIdAndUserId(scenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(scenarioId));

        // 이 시나리오를 사용하는 Registration이 있는지 체크
        long countAsStart = registrationRepository.countByStartScenarioId(scenarioId);
        long countAsCurrent = registrationRepository.countByCurrentScenarioId(scenarioId);

        if (countAsStart > 0 || countAsCurrent > 0) {
            throw new IllegalStateException(
                    String.format("시나리오를 삭제할 수 없습니다. %d개의 수강신청이 이 시나리오를 참조하고 있습니다. " +
                            "먼저 해당 수강신청들을 삭제해주세요.", countAsStart + countAsCurrent)
            );
        }

        // 자식 시나리오도 함께 삭제 (CASCADE)
        List<Scenario> children = scenarioRepository.findByParentScenarioIdOrderByOrderIndexAsc(scenarioId);
        for (Scenario child : children) {
            deleteScenario(userId, child.getId());  // 재귀적으로 삭제
        }

        scenarioRepository.delete(scenario);
    }

    /**
     * 실시간 네비게이션: 특정 강의(들) 실패 시 다음 시나리오 찾기
     */
    public ScenarioResponse navigate(Long userId, Long currentScenarioId, NavigationRequest request) {
        Scenario currentScenario = scenarioRepository.findByIdAndUserId(currentScenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(currentScenarioId));

        // 실패한 강의들에 대한 대안 시나리오 찾기
        Scenario nextScenario = scenarioRepository.findAlternativeScenario(
                currentScenarioId, request.getFailedCourseIds()
        ).orElseThrow(() -> new RuntimeException(
                "강의 " + request.getFailedCourseIds() + " 실패에 대한 대안 시나리오가 없습니다"
        ));

        return ScenarioResponse.from(nextScenario);
    }

    /**
     * 시나리오의 모든 자식(대안 시나리오들) 조회
     */
    public List<ScenarioResponse> getChildScenarios(Long userId, Long parentScenarioId) {
        // 권한 체크
        scenarioRepository.findByIdAndUserId(parentScenarioId, userId)
                .orElseThrow(() -> new ScenarioNotFoundException(parentScenarioId));

        List<Scenario> children = scenarioRepository.findByParentScenarioIdOrderByOrderIndexAsc(parentScenarioId);
        return children.stream()
                .map(ScenarioResponse::from)
                .collect(Collectors.toList());
    }

    // Helper methods
    private Timetable createOrGetTimetable(Long userId, CreateScenarioRequest request) {
        if (request.getExistingTimetableId() != null) {
            return timetableRepository.findByIdAndUserId(request.getExistingTimetableId(), userId)
                    .orElseThrow(() -> new TimetableNotFoundException(request.getExistingTimetableId()));
        } else {
            return createTimetableFromRequest(userId, request.getTimetableRequest());
        }
    }

    private Timetable createTimetableFromRequest(Long userId, com.uniplan.planner.domain.timetable.dto.CreateTimetableRequest request) {
        Timetable timetable = Timetable.builder()
                .userId(userId)
                .name(request.getName())
                .openingYear(request.getOpeningYear())
                .semester(request.getSemester())
                .build();
        return timetableRepository.save(timetable);
    }

    /**
     * Recursively collect all course IDs from scenario tree
     */
    private void collectCourseIds(Scenario scenario, Set<Long> courseIds) {
        // Add course IDs from current scenario's timetable
        scenario.getTimetable().getItems().stream()
                .map(TimetableItem::getCourseId)
                .forEach(courseIds::add);

        // Recursively collect from child scenarios
        if (scenario.getChildScenarios() != null) {
            for (Scenario child : scenario.getChildScenarios()) {
                collectCourseIds(child, courseIds);
            }
        }
    }
}