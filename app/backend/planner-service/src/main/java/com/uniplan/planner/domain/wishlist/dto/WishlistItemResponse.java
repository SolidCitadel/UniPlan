package com.uniplan.planner.domain.wishlist.dto;

import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
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
public class WishlistItemResponse {

    private Long id;
    private Long userId;
    private Long courseId;
    private String courseName;
    private String professor;
    private Integer priority;
    private String classroom;
    private List<ClassTimeDto> classTimes;
    private LocalDateTime addedAt;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ClassTimeDto {
        private String day;
        private String startTime;
        private String endTime;

        public static ClassTimeDto from(CourseFullResponse.ClassTimeResponse classTime) {
            return ClassTimeDto.builder()
                    .day(classTime.getDay())
                    .startTime(classTime.getStartTime())
                    .endTime(classTime.getEndTime())
                    .build();
        }
    }

    public static WishlistItemResponse from(WishlistItem item) {
        return WishlistItemResponse.builder()
                .id(item.getId())
                .userId(item.getUserId())
                .courseId(item.getCourseId())
                .priority(item.getPriority())
                .addedAt(item.getAddedAt())
                .build();
    }

    public static WishlistItemResponse from(WishlistItem item, CourseFullResponse course) {
        List<ClassTimeDto> classTimeDtos = null;
        if (course != null && course.getClassTimes() != null) {
            classTimeDtos = course.getClassTimes().stream()
                    .map(ClassTimeDto::from)
                    .toList();
        }

        return WishlistItemResponse.builder()
                .id(item.getId())
                .userId(item.getUserId())
                .courseId(item.getCourseId())
                .courseName(course != null ? course.getCourseName() : null)
                .professor(course != null ? course.getProfessor() : null)
                .classroom(course != null ? course.getClassroom() : null)
                .classTimes(classTimeDtos)
                .priority(item.getPriority())
                .addedAt(item.getAddedAt())
                .build();
    }
}