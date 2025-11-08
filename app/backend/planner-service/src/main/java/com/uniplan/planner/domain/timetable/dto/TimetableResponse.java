package com.uniplan.planner.domain.timetable.dto;

import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
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

    public static TimetableResponse from(Timetable timetable, Map<Long, CourseSimpleResponse> courseMap) {
        return TimetableResponse.builder()
                .id(timetable.getId())
                .userId(timetable.getUserId())
                .name(timetable.getName())
                .openingYear(timetable.getOpeningYear())
                .semester(timetable.getSemester())
                .createdAt(timetable.getCreatedAt())
                .updatedAt(timetable.getUpdatedAt())
                .items(timetable.getItems().stream()
                        .map(item -> {
                            CourseSimpleResponse course = courseMap.get(item.getCourseId());
                            if (course != null) {
                                return TimetableItemResponse.from(item, course.getCourseName(), course.getProfessor());
                            } else {
                                return TimetableItemResponse.from(item, null, null);
                            }
                        })
                        .collect(Collectors.toList()))
                .excludedCourseIds(timetable.getExcludedCourseIds())
                .build();
    }

    public static TimetableResponse fromWithFullCourses(Timetable timetable, Map<Long, CourseFullResponse> courseMap) {
        return TimetableResponse.builder()
                .id(timetable.getId())
                .userId(timetable.getUserId())
                .name(timetable.getName())
                .openingYear(timetable.getOpeningYear())
                .semester(timetable.getSemester())
                .createdAt(timetable.getCreatedAt())
                .updatedAt(timetable.getUpdatedAt())
                .items(timetable.getItems().stream()
                        .map(item -> {
                            CourseFullResponse course = courseMap.get(item.getCourseId());
                            if (course != null) {
                                List<TimetableItemResponse.ClassTimeInfo> classTimes = course.getClassTimes().stream()
                                        .map(ct -> TimetableItemResponse.ClassTimeInfo.builder()
                                                .day(ct.getDay())
                                                .startTime(ct.getStartTime())
                                                .endTime(ct.getEndTime())
                                                .build())
                                        .collect(Collectors.toList());

                                return TimetableItemResponse.builder()
                                        .id(item.getId())
                                        .courseId(item.getCourseId())
                                        .courseCode(course.getCourseCode())
                                        .courseName(course.getCourseName())
                                        .professor(course.getProfessor())
                                        .credits(course.getCredits())
                                        .classroom(course.getClassroom())
                                        .campus(course.getCampus())
                                        .classTimes(classTimes)
                                        .addedAt(item.getAddedAt())
                                        .build();
                            } else {
                                return TimetableItemResponse.from(item);
                            }
                        })
                        .collect(Collectors.toList()))
                .excludedCourseIds(timetable.getExcludedCourseIds())
                .build();
    }
}