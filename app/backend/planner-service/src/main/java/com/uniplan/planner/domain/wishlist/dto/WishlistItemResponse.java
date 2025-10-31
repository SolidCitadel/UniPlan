package com.uniplan.planner.domain.wishlist.dto;

import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WishlistItemResponse {

    private Long id;
    private Long userId;
    private Long courseId;
    private Integer priority;
    private LocalDateTime addedAt;

    public static WishlistItemResponse from(WishlistItem item) {
        return WishlistItemResponse.builder()
                .id(item.getId())
                .userId(item.getUserId())
                .courseId(item.getCourseId())
                .priority(item.getPriority())
                .addedAt(item.getAddedAt())
                .build();
    }
}