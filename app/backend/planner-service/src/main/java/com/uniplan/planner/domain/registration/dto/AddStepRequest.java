package com.uniplan.planner.domain.registration.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddStepRequest {

    @NotNull(message = "성공한 과목 목록은 필수입니다 (빈 리스트 가능)")
    private List<Long> succeededCourses;

    @NotNull(message = "실패한 과목 목록은 필수입니다 (빈 리스트 가능)")
    private List<Long> failedCourses;

    @NotNull(message = "취소한 과목 목록은 필수입니다 (빈 리스트 가능)")
    private List<Long> canceledCourses;

    private String notes;
}