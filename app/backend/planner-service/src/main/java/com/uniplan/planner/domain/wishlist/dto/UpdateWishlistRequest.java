package com.uniplan.planner.domain.wishlist.dto;

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
public class UpdateWishlistRequest {

    @NotNull(message = "우선순위는 필수입니다")
    @Min(value = 1, message = "우선순위는 1 이상이어야 합니다")
    private Integer priority;
}
