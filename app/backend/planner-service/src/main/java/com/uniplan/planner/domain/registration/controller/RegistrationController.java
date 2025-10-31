package com.uniplan.planner.domain.registration.controller;

import com.uniplan.planner.domain.registration.dto.*;
import com.uniplan.planner.domain.registration.entity.RegistrationStatus;
import com.uniplan.planner.domain.registration.service.RegistrationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Registration", description = "수강신청 실시간 네비게이션 API")
@RestController
@RequestMapping("/registrations")
@RequiredArgsConstructor
public class RegistrationController {

    private final RegistrationService registrationService;

    @Operation(summary = "수강신청 시작", description = "시나리오를 선택하고 수강신청 세션을 시작합니다")
    @PostMapping
    public ResponseEntity<RegistrationResponse> startRegistration(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @Valid @RequestBody StartRegistrationRequest request) {
        RegistrationResponse response = registrationService.startRegistration(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "단계 추가 (자동 네비게이션)", description = "성공/실패 과목을 입력하면 자동으로 다음 시나리오로 네비게이션됩니다")
    @PostMapping("/{registrationId}/steps")
    public ResponseEntity<RegistrationResponse> addStep(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long registrationId,
            @Valid @RequestBody AddStepRequest request) {
        RegistrationResponse response = registrationService.addStep(userId, registrationId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "수강신청 조회", description = "수강신청 세션의 상세 정보를 조회합니다")
    @GetMapping("/{registrationId}")
    public ResponseEntity<RegistrationResponse> getRegistration(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long registrationId) {
        RegistrationResponse response = registrationService.getRegistration(userId, registrationId);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "사용자의 수강신청 목록", description = "사용자의 모든 수강신청 세션을 조회합니다")
    @GetMapping
    public ResponseEntity<List<RegistrationResponse>> getUserRegistrations(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @RequestParam(required = false) RegistrationStatus status) {
        List<RegistrationResponse> responses;
        if (status != null) {
            responses = registrationService.getUserRegistrationsByStatus(userId, status);
        } else {
            responses = registrationService.getUserRegistrations(userId);
        }
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "수강신청 완료", description = "수강신청 세션을 완료 상태로 변경합니다")
    @PostMapping("/{registrationId}/complete")
    public ResponseEntity<RegistrationResponse> completeRegistration(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long registrationId) {
        RegistrationResponse response = registrationService.completeRegistration(userId, registrationId);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "수강신청 취소", description = "수강신청 세션을 취소합니다")
    @DeleteMapping("/{registrationId}")
    public ResponseEntity<Void> cancelRegistration(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long registrationId) {
        registrationService.cancelRegistration(userId, registrationId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "성공한 과목 목록", description = "지금까지 성공한 모든 과목의 ID를 조회합니다")
    @GetMapping("/{registrationId}/succeeded-courses")
    public ResponseEntity<List<Long>> getAllSucceededCourses(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long registrationId) {
        List<Long> succeededCourses = registrationService.getAllSucceededCourses(userId, registrationId);
        return ResponseEntity.ok(succeededCourses);
    }
}