package com.uniplan.planner.domain.timetable.service;

import com.uniplan.planner.domain.timetable.dto.*;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import com.uniplan.planner.domain.timetable.repository.TimetableItemRepository;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.exception.CourseNotFoundException;
import com.uniplan.planner.global.exception.DuplicateCourseException;
import com.uniplan.planner.global.exception.ExcludedCourseException;
import com.uniplan.planner.global.exception.TimetableNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TimetableService {

    private final TimetableRepository timetableRepository;
    private final TimetableItemRepository timetableItemRepository;
    private final CatalogClient catalogClient;

    @Transactional
    public TimetableResponse createTimetable(Long userId, CreateTimetableRequest request) {
        Timetable timetable = Timetable.builder()
                .userId(userId)
                .name(request.getName())
                .openingYear(request.getOpeningYear())
                .semester(request.getSemester())
                .build();

        Timetable savedTimetable = timetableRepository.save(timetable);
        // 새 시간표는 강좌가 없으므로 빈 맵 전달
        return TimetableResponse.from(savedTimetable, Map.of());
    }

    public List<TimetableResponse> getUserTimetables(Long userId) {
        List<Timetable> timetables = timetableRepository.findByUserId(userId);

        // Collect all course IDs from all timetables (items + excluded)
        List<Long> allCourseIds = new ArrayList<>();
        for (Timetable t : timetables) {
            t.getItems().forEach(item -> allCourseIds.add(item.getCourseId()));
            allCourseIds.addAll(t.getExcludedCourseIds());
        }

        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(
                allCourseIds.stream().distinct().collect(Collectors.toList()));

        return timetables.stream()
                .map(t -> TimetableResponse.from(t, courseMap))
                .collect(Collectors.toList());
    }

    public List<TimetableResponse> getUserTimetablesBySemester(Long userId, Integer openingYear, String semester) {
        List<Timetable> timetables = timetableRepository.findByUserIdAndOpeningYearAndSemester(userId, openingYear, semester);

        // Collect all course IDs from all timetables (items + excluded)
        List<Long> allCourseIds = new ArrayList<>();
        for (Timetable t : timetables) {
            t.getItems().forEach(item -> allCourseIds.add(item.getCourseId()));
            allCourseIds.addAll(t.getExcludedCourseIds());
        }

        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(
                allCourseIds.stream().distinct().collect(Collectors.toList()));

        return timetables.stream()
                .map(t -> TimetableResponse.from(t, courseMap))
                .collect(Collectors.toList());
    }

    public TimetableResponse getTimetable(Long userId, Long timetableId) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));

        // Fetch full course details (items + excluded)
        List<Long> courseIds = new ArrayList<>();
        timetable.getItems().forEach(item -> courseIds.add(item.getCourseId()));
        courseIds.addAll(timetable.getExcludedCourseIds());

        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(courseIds);

        return TimetableResponse.from(timetable, courseMap);
    }

    @Transactional
    public TimetableResponse updateTimetable(Long userId, Long timetableId, UpdateTimetableRequest request) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));

        timetable.updateName(request.getName());

        // Fetch course details (items + excluded)
        List<Long> courseIds = new ArrayList<>();
        timetable.getItems().forEach(item -> courseIds.add(item.getCourseId()));
        courseIds.addAll(timetable.getExcludedCourseIds());

        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(courseIds);

        return TimetableResponse.from(timetable, courseMap);
    }

    @Transactional
    public void deleteTimetable(Long userId, Long timetableId) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));
        timetableRepository.delete(timetable);
    }

    @Transactional
    public TimetableResponse createAlternative(Long userId, Long baseTimetableId, CreateAlternativeTimetableRequest request) {
        // 원본 시간표 조회
        Timetable baseTimetable = timetableRepository.findByIdAndUserId(baseTimetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(baseTimetableId));

        // 대안 시간표 생성
        Timetable alternativeTimetable = Timetable.builder()
                .userId(userId)
                .name(request.getName())
                .openingYear(baseTimetable.getOpeningYear())
                .semester(baseTimetable.getSemester())
                .excludedCourseIds(request.getExcludedCourseIds())
                .build();

        // 원본 시간표의 강의들을 복사 (excluded 제외)
        for (TimetableItem item : baseTimetable.getItems()) {
            if (!request.getExcludedCourseIds().contains(item.getCourseId())) {
                TimetableItem newItem = TimetableItem.builder()
                        .timetable(alternativeTimetable)
                        .courseId(item.getCourseId())
                        .build();
                alternativeTimetable.addItem(newItem);
            }
        }

        Timetable savedTimetable = timetableRepository.save(alternativeTimetable);

        // Fetch course details (items + excluded)
        List<Long> courseIds = new ArrayList<>();
        savedTimetable.getItems().forEach(item -> courseIds.add(item.getCourseId()));
        courseIds.addAll(savedTimetable.getExcludedCourseIds());

        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(courseIds);

        return TimetableResponse.from(savedTimetable, courseMap);
    }

    @Transactional
    public TimetableItemResponse addCourse(Long userId, Long timetableId, AddCourseRequest request) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));

        // 강의 존재 확인
        CourseFullResponse course = catalogClient.getFullCourseById(request.getCourseId());
        if (course == null) {
            throw new CourseNotFoundException(request.getCourseId());
        }

        // 제외된 과목 체크
        if (timetable.getExcludedCourseIds().contains(request.getCourseId())) {
            throw new ExcludedCourseException(request.getCourseId());
        }

        // 중복 체크
        if (timetableItemRepository.existsByTimetableIdAndCourseId(timetableId, request.getCourseId())) {
            throw new DuplicateCourseException(request.getCourseId());
        }

        TimetableItem item = TimetableItem.builder()
                .timetable(timetable)
                .courseId(request.getCourseId())
                .build();

        TimetableItem savedItem = timetableItemRepository.save(item);

        // course details 사용 (이미 조회됨)
        List<TimetableItemResponse.ClassTimeInfo> classTimes = List.of();
        if (course.getClassTimes() != null) {
            classTimes = course.getClassTimes().stream()
                    .map(ct -> TimetableItemResponse.ClassTimeInfo.builder()
                            .day(ct.getDay())
                            .startTime(ct.getStartTime())
                            .endTime(ct.getEndTime())
                            .build())
                    .collect(Collectors.toList());
        }

        return TimetableItemResponse.builder()
                .id(savedItem.getId())
                .courseId(savedItem.getCourseId())
                .courseCode(course.getCourseCode())
                .courseName(course.getCourseName())
                .professor(course.getProfessor())
                .credits(course.getCredits())
                .classroom(course.getClassroom())
                .campus(course.getCampus())
                .classTimes(classTimes)
                .addedAt(savedItem.getAddedAt())
                .build();
    }

    @Transactional
    public void removeCourse(Long userId, Long timetableId, Long courseId) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));

        TimetableItem item = timetableItemRepository.findByTimetableIdAndCourseId(timetableId, courseId)
                .orElseThrow(() -> new RuntimeException("강의를 찾을 수 없습니다: " + courseId));

        timetableItemRepository.delete(item);
    }
}