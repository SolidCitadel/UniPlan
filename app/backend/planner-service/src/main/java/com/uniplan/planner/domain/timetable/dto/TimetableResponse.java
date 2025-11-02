package com.uniplan.planner.domain.timetable.dto;

import com.uniplan.planner.domain.timetable.entity.Timetable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimetableResponse {

    private Long id;
    private Long userId;
    private String name;
    private Integer openingYear;
    private String semester;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<TimetableItemResponse> items;
    private Set<Long> excludedCourseIds;

    public static TimetableResponse from(Timetable timetable) {
        return TimetableResponse.builder()
                .id(timetable.getId())
                .userId(timetable.getUserId())
                .name(timetable.getName())
                .openingYear(timetable.getOpeningYear())
                .semester(timetable.getSemester())
                .createdAt(timetable.getCreatedAt())
                .updatedAt(timetable.getUpdatedAt())
                .items(timetable.getItems().stream()
                        .map(TimetableItemResponse::from)
                        .collect(Collectors.toList()))
                .excludedCourseIds(timetable.getExcludedCourseIds())
                .build();
    }
}