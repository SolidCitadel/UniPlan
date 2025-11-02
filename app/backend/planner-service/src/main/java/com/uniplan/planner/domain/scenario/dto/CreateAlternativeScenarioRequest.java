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
public class CreateAlternativeScenarioRequest {

    @NotBlank(message = "시나리오 이름은 필수입니다")
    private String name;

    private String description;

    // 어떤 강의가 실패했을 때 이 시나리오로 이동하는가
    @NotNull(message = "실패 강의 ID는 필수입니다")
    private Long failedCourseId;

    // 시간표 생성 정보 (timetableRequest 또는 existingTimetableId 둘 중 하나만 사용)
    @Valid
    private CreateTimetableRequest timetableRequest;

    // 기존 시간표 ID 사용
    private Long existingTimetableId;

    // 형제 노드 간 순서
    private Integer orderIndex;
}