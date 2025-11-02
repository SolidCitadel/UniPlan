package com.uniplan.planner.domain.scenario.dto;

import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.timetable.dto.TimetableResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScenarioResponse {

    private Long id;
    private Long userId;
    private String name;
    private String description;
    private Long parentScenarioId;
    private Set<Long> failedCourseIds;
    private Integer orderIndex;
    private TimetableResponse timetable;
    private List<ScenarioResponse> childScenarios;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static ScenarioResponse from(Scenario scenario) {
        return from(scenario, true);
    }

    public static ScenarioResponse from(Scenario scenario, boolean includeChildren) {
        ScenarioResponseBuilder builder = ScenarioResponse.builder()
                .id(scenario.getId())
                .userId(scenario.getUserId())
                .name(scenario.getName())
                .description(scenario.getDescription())
                .parentScenarioId(scenario.getParentScenario() != null ? scenario.getParentScenario().getId() : null)
                .failedCourseIds(scenario.getFailedCourseIds())
                .orderIndex(scenario.getOrderIndex())
                .timetable(TimetableResponse.from(scenario.getTimetable()))
                .createdAt(scenario.getCreatedAt())
                .updatedAt(scenario.getUpdatedAt());

        if (includeChildren && scenario.getChildScenarios() != null) {
            builder.childScenarios(scenario.getChildScenarios().stream()
                    .map(child -> ScenarioResponse.from(child, false))  // 자식의 자식은 포함하지 않음
                    .collect(Collectors.toList()));
        }

        return builder.build();
    }

    public static ScenarioResponse fromWithFullTree(Scenario scenario) {
        return ScenarioResponse.builder()
                .id(scenario.getId())
                .userId(scenario.getUserId())
                .name(scenario.getName())
                .description(scenario.getDescription())
                .parentScenarioId(scenario.getParentScenario() != null ? scenario.getParentScenario().getId() : null)
                .failedCourseIds(scenario.getFailedCourseIds())
                .orderIndex(scenario.getOrderIndex())
                .timetable(TimetableResponse.from(scenario.getTimetable()))
                .childScenarios(scenario.getChildScenarios().stream()
                        .map(ScenarioResponse::fromWithFullTree)  // 재귀적으로 모든 자식 포함
                        .collect(Collectors.toList()))
                .createdAt(scenario.getCreatedAt())
                .updatedAt(scenario.getUpdatedAt())
                .build();
    }
}