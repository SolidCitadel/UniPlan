package com.uniplan.planner.domain.scenario.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NavigationRequest {

    @NotNull(message = "실패한 강의 ID는 필수입니다")
    private Long failedCourseId;
}