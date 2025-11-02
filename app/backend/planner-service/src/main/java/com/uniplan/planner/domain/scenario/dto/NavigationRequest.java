package com.uniplan.planner.domain.scenario.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NavigationRequest {

    @NotEmpty(message = "실패한 강의 ID 목록은 필수입니다")
    private Set<Long> failedCourseIds;
}