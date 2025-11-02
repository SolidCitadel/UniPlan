package com.uniplan.planner.domain.timetable.service;

import com.uniplan.planner.domain.timetable.dto.*;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import com.uniplan.planner.domain.timetable.repository.TimetableItemRepository;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.global.exception.DuplicateCourseException;
import com.uniplan.planner.global.exception.ExcludedCourseException;
import com.uniplan.planner.global.exception.TimetableNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TimetableService {

    private final TimetableRepository timetableRepository;
    private final TimetableItemRepository timetableItemRepository;

    @Transactional
    public TimetableResponse createTimetable(Long userId, CreateTimetableRequest request) {
        Timetable timetable = Timetable.builder()
                .userId(userId)
                .name(request.getName())
                .openingYear(request.getOpeningYear())
                .semester(request.getSemester())
                .build();

        Timetable savedTimetable = timetableRepository.save(timetable);
        return TimetableResponse.from(savedTimetable);
    }

    public List<TimetableResponse> getUserTimetables(Long userId) {
        List<Timetable> timetables = timetableRepository.findByUserId(userId);
        return timetables.stream()
                .map(TimetableResponse::from)
                .collect(Collectors.toList());
    }

    public List<TimetableResponse> getUserTimetablesBySemester(Long userId, Integer openingYear, String semester) {
        List<Timetable> timetables = timetableRepository.findByUserIdAndOpeningYearAndSemester(userId, openingYear, semester);
        return timetables.stream()
                .map(TimetableResponse::from)
                .collect(Collectors.toList());
    }

    public TimetableResponse getTimetable(Long userId, Long timetableId) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));
        return TimetableResponse.from(timetable);
    }

    @Transactional
    public TimetableResponse updateTimetable(Long userId, Long timetableId, UpdateTimetableRequest request) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));

        timetable.updateName(request.getName());
        return TimetableResponse.from(timetable);
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
        return TimetableResponse.from(savedTimetable);
    }

    @Transactional
    public TimetableItemResponse addCourse(Long userId, Long timetableId, AddCourseRequest request) {
        Timetable timetable = timetableRepository.findByIdAndUserId(timetableId, userId)
                .orElseThrow(() -> new TimetableNotFoundException(timetableId));

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
        return TimetableItemResponse.from(savedItem);
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