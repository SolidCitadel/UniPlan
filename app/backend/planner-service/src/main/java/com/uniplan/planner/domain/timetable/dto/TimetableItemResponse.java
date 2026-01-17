package com.uniplan.planner.domain.timetable.dto;

import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimetableItemResponse {

    @Schema(requiredMode = REQUIRED)
    private Long id;
    @Schema(requiredMode = REQUIRED)
    private Long courseId;
    private String courseCode;
    private String courseName;
    private String professor;
    private Integer credits;
    private String classroom;
    private String campus;
    @Schema(requiredMode = REQUIRED)
    private List<ClassTimeInfo> classTimes;
    @Schema(requiredMode = REQUIRED)
    private LocalDateTime addedAt;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ClassTimeInfo {
        @Schema(requiredMode = REQUIRED)
        private String day;
        @Schema(requiredMode = REQUIRED)
        private String startTime;
        @Schema(requiredMode = REQUIRED)
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