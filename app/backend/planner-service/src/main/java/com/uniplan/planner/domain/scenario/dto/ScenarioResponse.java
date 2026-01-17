package com.uniplan.planner.domain.scenario.dto;

import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.timetable.dto.TimetableResponse;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScenarioResponse {

    @Schema(requiredMode = REQUIRED)
    private Long id;
    @Schema(requiredMode = REQUIRED)
    private Long userId;
    @Schema(requiredMode = REQUIRED)
    private String name;
    private String description;
    private Long parentScenarioId;
    @Schema(requiredMode = REQUIRED)
    private Set<Long> failedCourseIds;
    private Integer orderIndex;
    @Schema(requiredMode = REQUIRED)
    private TimetableResponse timetable;
    @Schema(requiredMode = REQUIRED)
    private List<ScenarioResponse> childScenarios;
    @Schema(requiredMode = REQUIRED)
    private LocalDateTime createdAt;
    @Schema(requiredMode = REQUIRED)
    private LocalDateTime updatedAt;

    public static ScenarioResponse from(Scenario scenario, Map<Long, CourseFullResponse> courseMap) {
        return from(scenario, courseMap, true);
    }

    public static ScenarioResponse from(Scenario scenario, Map<Long, CourseFullResponse> courseMap, boolean includeChildren) {
        ScenarioResponseBuilder builder = ScenarioResponse.builder()
                .id(scenario.getId())
                .userId(scenario.getUserId())
                .name(scenario.getName())
                .description(scenario.getDescription())
                .parentScenarioId(scenario.getParentScenario() != null ? scenario.getParentScenario().getId() : null)
                .failedCourseIds(scenario.getFailedCourseIds())
                .orderIndex(scenario.getOrderIndex())
                .timetable(TimetableResponse.from(scenario.getTimetable(), courseMap))
                .createdAt(scenario.getCreatedAt())
                .updatedAt(scenario.getUpdatedAt());

        if (includeChildren && scenario.getChildScenarios() != null) {
            builder.childScenarios(scenario.getChildScenarios().stream()
                    .map(child -> ScenarioResponse.from(child, courseMap, false))
                    .collect(Collectors.toList()));
        } else {
            builder.childScenarios(List.of());
        }

        return builder.build();
    }

    public static ScenarioResponse fromWithFullTree(Scenario scenario, Map<Long, CourseFullResponse> courseMap) {
        return ScenarioResponse.builder()
                .id(scenario.getId())
                .userId(scenario.getUserId())
                .name(scenario.getName())
                .description(scenario.getDescription())
                .parentScenarioId(scenario.getParentScenario() != null ? scenario.getParentScenario().getId() : null)
                .failedCourseIds(scenario.getFailedCourseIds())
                .orderIndex(scenario.getOrderIndex())
                .timetable(TimetableResponse.from(scenario.getTimetable(), courseMap))
                .childScenarios(scenario.getChildScenarios().stream()
                        .map(child -> ScenarioResponse.fromWithFullTree(child, courseMap))
                        .collect(Collectors.toList()))
                .createdAt(scenario.getCreatedAt())
                .updatedAt(scenario.getUpdatedAt())
                .build();
    }
}