package com.uniplan.planner.domain.timetable.dto;

import com.uniplan.planner.global.client.dto.CourseFullResponse;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * Excluded course payload for timetable responses.
 * Keeps course PK under courseId to stay consistent with timetable item shape.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimetableCourseResponse {

    private Long courseId;
    private String courseCode;
    private String courseName;
    private String professor;
    private Integer credits;
    private String classroom;
    private String campus;
    private List<TimetableItemResponse.ClassTimeInfo> classTimes;

    public static TimetableCourseResponse from(CourseFullResponse course) {
        if (course == null) {
            return null;
        }

        List<TimetableItemResponse.ClassTimeInfo> classTimeInfos = course.getClassTimes() == null
                ? List.of()
                : course.getClassTimes().stream()
                        .filter(Objects::nonNull)
                        .map(ct -> TimetableItemResponse.ClassTimeInfo.builder()
                                .day(ct.getDay())
                                .startTime(ct.getStartTime())
                                .endTime(ct.getEndTime())
                                .build())
                        .collect(Collectors.toList());

        return TimetableCourseResponse.builder()
                .courseId(course.getId())
                .courseCode(course.getCourseCode())
                .courseName(course.getCourseName())
                .professor(course.getProfessor())
                .credits(course.getCredits())
                .classroom(course.getClassroom())
                .campus(course.getCampus())
                .classTimes(classTimeInfos)
                .build();
    }
}
