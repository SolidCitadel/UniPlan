package com.uniplan.planner.domain.scenario.dto;

import com.uniplan.planner.domain.timetable.dto.CreateTimetableRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateScenarioRequest {

    @NotBlank(message = "시나리오 이름은 필수입니다")
    private String name;

    private String description;

    // 시간표 생성 정보
    @NotNull(message = "시간표 정보는 필수입니다")
    @Valid
    private CreateTimetableRequest timetableRequest;

    // 기존 시간표 ID 사용 (timetableRequest와 둘 중 하나만 사용)
    private Long existingTimetableId;
}