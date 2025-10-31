package com.uniplan.planner.domain.timetable.dto;

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
public class CreateTimetableRequest {

    @NotBlank(message = "시간표 이름은 필수입니다")
    private String name;

    @NotNull(message = "개설 년도는 필수입니다")
    private Integer openingYear;

    @NotBlank(message = "학기는 필수입니다")
    private String semester;
}