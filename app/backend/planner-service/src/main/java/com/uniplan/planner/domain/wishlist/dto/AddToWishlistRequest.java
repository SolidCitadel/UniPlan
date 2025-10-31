package com.uniplan.planner.domain.wishlist.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddToWishlistRequest {

    @NotNull(message = "강의 ID는 필수입니다")
    private Long courseId;

    @NotNull(message = "우선순위는 필수입니다")
    @Min(value = 1, message = "우선순위는 1 이상이어야 합니다")
    @Max(value = 5, message = "우선순위는 5 이하여야 합니다")
    private Integer priority;
}