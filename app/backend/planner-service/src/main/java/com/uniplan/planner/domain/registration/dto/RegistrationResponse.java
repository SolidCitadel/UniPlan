package com.uniplan.planner.domain.registration.dto;

import com.uniplan.planner.domain.registration.entity.Registration;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import com.uniplan.planner.domain.scenario.dto.ScenarioResponse;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationResponse {

    @Schema(requiredMode = REQUIRED)
    private Long id;
    @Schema(requiredMode = REQUIRED)
    private Long userId;
    @Schema(requiredMode = REQUIRED)
    private String name;
    @Schema(requiredMode = REQUIRED)
    private ScenarioResponse startScenario;
    @Schema(requiredMode = REQUIRED)
    private ScenarioResponse currentScenario;
    @Schema(requiredMode = REQUIRED)
    private RegistrationStatus status;
    @Schema(requiredMode = REQUIRED)
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    @Schema(requiredMode = REQUIRED)
    private List<Long> succeededCourses;
    @Schema(requiredMode = REQUIRED)
    private List<Long> failedCourses;
    @Schema(requiredMode = REQUIRED)
    private List<Long> canceledCourses;
    @Schema(requiredMode = REQUIRED)
    private List<RegistrationStepResponse> steps;

    public static RegistrationResponse from(Registration registration, Map<Long, CourseFullResponse> courseMap) {
        return RegistrationResponse.builder()
                .id(registration.getId())
                .userId(registration.getUserId())
                .name(registration.getName())
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