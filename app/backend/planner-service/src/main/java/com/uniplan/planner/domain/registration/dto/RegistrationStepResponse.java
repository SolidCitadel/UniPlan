package com.uniplan.planner.domain.registration.dto;

import com.uniplan.planner.domain.registration.entity.RegistrationStep;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegistrationStepResponse {

    private Long id;
    private Long scenarioId;
    private String scenarioName;
    private List<Long> succeededCourses;
    private List<Long> failedCourses;
    private Long nextScenarioId;
    private String nextScenarioName;
    private String notes;
    private LocalDateTime timestamp;

    public static RegistrationStepResponse from(RegistrationStep step) {
        return RegistrationStepResponse.builder()
                .id(step.getId())
                .scenarioId(step.getScenario().getId())
                .scenarioName(step.getScenario().getName())
                .succeededCourses(step.getSucceededCourses())
                .failedCourses(step.getFailedCourses())
                .nextScenarioId(step.getNextScenario() != null ? step.getNextScenario().getId() : null)
                .nextScenarioName(step.getNextScenario() != null ? step.getNextScenario().getName() : null)
                .notes(step.getNotes())
                .timestamp(step.getTimestamp())
                .build();
    }
}