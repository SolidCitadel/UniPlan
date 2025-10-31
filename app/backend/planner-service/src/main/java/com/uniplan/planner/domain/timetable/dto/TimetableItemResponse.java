package com.uniplan.planner.domain.timetable.dto;

import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimetableItemResponse {

    private Long id;
    private Long courseId;
    private LocalDateTime addedAt;

    public static TimetableItemResponse from(TimetableItem item) {
        return TimetableItemResponse.builder()
                .id(item.getId())
                .courseId(item.getCourseId())
                .addedAt(item.getAddedAt())
                .build();
    }
}