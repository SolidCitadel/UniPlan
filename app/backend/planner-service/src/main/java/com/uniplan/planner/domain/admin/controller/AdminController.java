package com.uniplan.planner.domain.admin.controller;

import com.uniplan.planner.domain.admin.service.AdminService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Admin API Controller (개발 환경 전용)
 * 테스트 데이터 초기화 등 관리 기능 제공
 */
@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
@Slf4j
@Profile("local")  // 개발 환경에서만 활성화
@Tag(name = "Admin", description = "관리자 API (개발 환경 전용)")
public class AdminController {

    private final AdminService adminService;

    @DeleteMapping("/reset")
    @Operation(
        summary = "플래너 데이터 초기화",
        description = "모든 희망과목, 시간표, 시나리오, 등록 데이터를 삭제하고 ID를 1부터 다시 시작합니다. (개발 환경 전용)"
    )
    public ResponseEntity<ResetResponse> resetPlannerData() {
        log.warn("=== 플래너 데이터 초기화 요청 ===");

        ResetStats stats = adminService.resetAllPlannerData();

        log.warn("=== 플래너 데이터 초기화 완료 ===");
        log.warn("Registration: {} 건 삭제", stats.registrationCount());
        log.warn("Scenario: {} 건 삭제", stats.scenarioCount());
        log.warn("Timetable: {} 건 삭제", stats.timetableCount());
        log.warn("WishlistItem: {} 건 삭제", stats.wishlistCount());

        return ResponseEntity.ok(new ResetResponse(
            "플래너 데이터가 초기화되었습니다.",
            stats
        ));
    }

    public record ResetResponse(String message, ResetStats stats) {}

    public record ResetStats(
        int registrationCount,
        int scenarioCount,
        int timetableCount,
        int wishlistCount
    ) {}
}
