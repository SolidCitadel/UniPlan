package com.uniplan.planner.domain.timetable.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.HashSet;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateAlternativeTimetableRequest {

    @NotBlank(message = "시간표 이름은 필수입니다")
    private String name;

    @NotNull(message = "제외할 과목 목록은 필수입니다")
    @Builder.Default
    private Set<Long> excludedCourseIds = new HashSet<>();
}
