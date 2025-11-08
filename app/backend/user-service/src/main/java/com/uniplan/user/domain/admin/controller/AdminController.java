package com.uniplan.user.domain.admin.controller;

import com.uniplan.user.domain.admin.service.AdminService;
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
        summary = "사용자 데이터 초기화",
        description = "모든 사용자 계정을 삭제하고 ID를 1부터 다시 시작합니다. (개발 환경 전용)"
    )
    public ResponseEntity<ResetResponse> resetUserData() {
        log.warn("=== 사용자 데이터 초기화 요청 ===");

        int deletedCount = adminService.resetAllUsers();

        log.warn("=== 사용자 데이터 초기화 완료: {} 건 삭제 ===", deletedCount);

        return ResponseEntity.ok(new ResetResponse(
            "사용자 데이터가 초기화되었습니다.",
            deletedCount
        ));
    }

    public record ResetResponse(String message, int deletedCount) {}
}
