package com.uniplan.planner.domain.registration.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StartRegistrationRequest {

    @NotNull(message = "시작 시나리오 ID는 필수입니다")
    private Long scenarioId;
}