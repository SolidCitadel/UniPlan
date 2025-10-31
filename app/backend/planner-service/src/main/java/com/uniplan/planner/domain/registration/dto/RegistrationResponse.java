package com.uniplan.planner.domain.registration.dto;

import com.uniplan.planner.domain.registration.entity.Registration;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationResponse {

    private Long id;
    private Long userId;
    private Long startScenarioId;
    private String startScenarioName;
    private Long currentScenarioId;
    private String currentScenarioName;
    private RegistrationStatus status;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private List<RegistrationStepResponse> steps;

    public static RegistrationResponse from(Registration registration) {
        return RegistrationResponse.builder()
                .id(registration.getId())
                .userId(registration.getUserId())
                .startScenarioId(registration.getStartScenario().getId())
                .startScenarioName(registration.getStartScenario().getName())
                .currentScenarioId(registration.getCurrentScenario().getId())
                .currentScenarioName(registration.getCurrentScenario().getName())
                .status(registration.getStatus())
                .startedAt(registration.getStartedAt())
                .completedAt(registration.getCompletedAt())
                .steps(registration.getSteps().stream()
                        .map(RegistrationStepResponse::from)
                        .collect(Collectors.toList()))
                .build();
    }
}