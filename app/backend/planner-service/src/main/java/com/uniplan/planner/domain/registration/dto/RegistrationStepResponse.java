package com.uniplan.planner.domain.registration.dto;

import com.uniplan.planner.domain.registration.entity.RegistrationStep;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationStepResponse {

    @Schema(requiredMode = REQUIRED)
    private Long id;
    @Schema(requiredMode = REQUIRED)
    private Long scenarioId;
    @Schema(requiredMode = REQUIRED)
    private String scenarioName;
    @Schema(requiredMode = REQUIRED)
    private List<Long> succeededCourses;
    @Schema(requiredMode = REQUIRED)
    private List<Long> failedCourses;
    @Schema(requiredMode = REQUIRED)
    private List<Long> canceledCourses;
    private Long nextScenarioId;
    private String nextScenarioName;
    private String notes;
    @Schema(requiredMode = REQUIRED)
    private LocalDateTime timestamp;

    public static RegistrationStepResponse from(RegistrationStep step) {
        return RegistrationStepResponse.builder()
                .id(step.getId())
                .scenarioId(step.getScenario().getId())
                .scenarioName(step.getScenario().getName())
                .succeededCourses(step.getSucceededCourses())
                .failedCourses(step.getFailedCourses())
                .canceledCourses(step.getCanceledCourses())
                .nextScenarioId(step.getNextScenario() != null ? step.getNextScenario().getId() : null)
                .nextScenarioName(step.getNextScenario() != null ? step.getNextScenario().getName() : null)
                .notes(step.getNotes())
                .timestamp(step.getTimestamp())
                .build();
    }
}