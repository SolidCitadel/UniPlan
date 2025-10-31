package com.uniplan.planner.domain.timetable.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateTimetableRequest {

    @NotBlank(message = "시간표 이름은 필수입니다")
    private String name;
}