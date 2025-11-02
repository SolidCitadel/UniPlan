package com.uniplan.planner.domain.timetable.controller;

import com.uniplan.planner.domain.timetable.dto.*;
import com.uniplan.planner.domain.timetable.service.TimetableService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Timetable", description = "시간표 관리 API")
@RestController
@RequestMapping("/timetables")
@RequiredArgsConstructor
public class TimetableController {

    private final TimetableService timetableService;

    @Operation(summary = "시간표 생성", description = "새로운 시간표를 생성합니다")
    @PostMapping
    public ResponseEntity<TimetableResponse> createTimetable(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @Valid @RequestBody CreateTimetableRequest request) {
        TimetableResponse response = timetableService.createTimetable(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "사용자의 모든 시간표 조회", description = "현재 사용자의 모든 시간표를 조회합니다")
    @GetMapping
    public ResponseEntity<List<TimetableResponse>> getUserTimetables(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @RequestParam(required = false) Integer openingYear,
            @RequestParam(required = false) String semester) {
        List<TimetableResponse> responses;
        if (openingYear != null && semester != null) {
            responses = timetableService.getUserTimetablesBySemester(userId, openingYear, semester);
        } else {
            responses = timetableService.getUserTimetables(userId);
        }
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "시간표 상세 조회", description = "특정 시간표의 상세 정보를 조회합니다")
    @GetMapping("/{timetableId}")
    public ResponseEntity<TimetableResponse> getTimetable(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long timetableId) {
        TimetableResponse response = timetableService.getTimetable(userId, timetableId);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "시간표 이름 수정", description = "시간표의 이름을 수정합니다")
    @PutMapping("/{timetableId}")
    public ResponseEntity<TimetableResponse> updateTimetable(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long timetableId,
            @Valid @RequestBody UpdateTimetableRequest request) {
        TimetableResponse response = timetableService.updateTimetable(userId, timetableId, request);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "시간표 삭제", description = "시간표를 삭제합니다")
    @DeleteMapping("/{timetableId}")
    public ResponseEntity<Void> deleteTimetable(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long timetableId) {
        timetableService.deleteTimetable(userId, timetableId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "대안 시간표 생성",
               description = "원본 시간표를 복사하여 대안 시간표를 생성합니다. 제외할 과목은 복사되지 않으며 excludedCourseIds에 추가됩니다.")
    @PostMapping("/{timetableId}/alternatives")
    public ResponseEntity<TimetableResponse> createAlternative(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long timetableId,
            @Valid @RequestBody CreateAlternativeTimetableRequest request) {
        TimetableResponse response = timetableService.createAlternative(userId, timetableId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "시간표에 강의 추가", description = "시간표에 강의를 추가합니다")
    @PostMapping("/{timetableId}/courses")
    public ResponseEntity<TimetableItemResponse> addCourse(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long timetableId,
            @Valid @RequestBody AddCourseRequest request) {
        TimetableItemResponse response = timetableService.addCourse(userId, timetableId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "시간표에서 강의 삭제", description = "시간표에서 강의를 삭제합니다")
    @DeleteMapping("/{timetableId}/courses/{courseId}")
    public ResponseEntity<Void> removeCourse(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long timetableId,
            @PathVariable Long courseId) {
        timetableService.removeCourse(userId, timetableId, courseId);
        return ResponseEntity.noContent().build();
    }
}