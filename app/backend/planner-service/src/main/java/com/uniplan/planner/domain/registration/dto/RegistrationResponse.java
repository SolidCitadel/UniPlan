package com.uniplan.planner.domain.registration.dto;

import com.uniplan.planner.domain.registration.entity.Registration;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import com.uniplan.planner.domain.scenario.dto.ScenarioResponse;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationResponse {

    private Long id;
    private Long userId;
    private ScenarioResponse startScenario;
    private ScenarioResponse currentScenario;
    private RegistrationStatus status;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private List<Long> succeededCourses;
    private List<Long> failedCourses;
    private List<Long> canceledCourses;
    private List<RegistrationStepResponse> steps;

    public static RegistrationResponse from(Registration registration, Map<Long, CourseFullResponse> courseMap) {
        return RegistrationResponse.builder()
                .id(registration.getId())
                .userId(registration.getUserId())
                .startScenario(ScenarioResponse.fromWithFullTree(registration.getStartScenario(), courseMap))
                .currentScenario(ScenarioResponse.fromWithFullTree(registration.getCurrentScenario(), courseMap))
                .status(registration.getStatus())
                .startedAt(registration.getStartedAt())
                .completedAt(registration.getCompletedAt())
                .succeededCourses(registration.getAllSucceededCourses())
                .failedCourses(registration.getAllFailedCourses())
                .canceledCourses(registration.getAllCanceledCourses())
                .steps(registration.getSteps().stream()
                        .map(RegistrationStepResponse::from)
                        .collect(Collectors.toList()))
                .build();
    }
}