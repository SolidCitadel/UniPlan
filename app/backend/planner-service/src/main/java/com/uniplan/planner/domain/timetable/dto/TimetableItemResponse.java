package com.uniplan.planner.domain.timetable.dto;

import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimetableItemResponse {

    private Long id;
    private Long courseId;
    private String courseCode;
    private String courseName;
    private String professor;
    private Integer credits;
    private String classroom;
    private String campus;
    private List<ClassTimeInfo> classTimes;
    private LocalDateTime addedAt;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ClassTimeInfo {
        private String day;
        private String startTime;
        private String endTime;
    }

    public static TimetableItemResponse from(TimetableItem item) {
        return TimetableItemResponse.builder()
                .id(item.getId())
                .courseId(item.getCourseId())
                .addedAt(item.getAddedAt())
                .build();
    }

    public static TimetableItemResponse from(TimetableItem item, String courseName, String professor) {
        return TimetableItemResponse.builder()
                .id(item.getId())
                .courseId(item.getCourseId())
                .courseName(courseName)
                .professor(professor)
                .addedAt(item.getAddedAt())
                .build();
    }
}