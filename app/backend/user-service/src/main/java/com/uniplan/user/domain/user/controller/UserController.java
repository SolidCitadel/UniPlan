package com.uniplan.user.domain.user.controller;

import com.uniplan.user.domain.user.dto.UserResponse;
import com.uniplan.user.domain.user.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

/**
 * 사용자 정보 조회 및 관리 API
 * API Gateway에서 JWT를 검증하고 X-User-Id, X-User-Email, X-User-Role 헤더로 사용자 정보 전달
 */
@Tag(name = "사용자 (User)", description = "사용자 정보 조회 및 관리 API")
@RestController
@RequestMapping("/users")  // API Gateway가 /api/v1/users → /users로 변환하여 전달
@RequiredArgsConstructor
@Slf4j
public class UserController {

    private final UserService userService;

    @Operation(
            summary = "내 정보 조회",
            description = "JWT 토큰으로 인증된 사용자의 정보를 조회합니다. API Gateway가 JWT 검증 후 X-User-Id 헤더로 사용자 ID를 전달합니다.",
            security = @SecurityRequirement(name = "bearer-jwt")
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "조회 성공",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = UserResponse.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "401",
                    description = "인증되지 않은 사용자 (JWT 토큰 누락 또는 유효하지 않음)"
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "사용자를 찾을 수 없음"
            )
    })
    @GetMapping("/me")
    public UserResponse getMyInfo(
            @Parameter(hidden = true)  // Swagger UI에서 숨김
            @RequestHeader(value = "X-User-Id") Long userId,
            @Parameter(hidden = true)
            @RequestHeader(value = "X-User-Email", required = false) String email,
            @Parameter(hidden = true)
            @RequestHeader(value = "X-User-Role", required = false) String role
    ) {
        log.info("내 정보 조회 - userId: {}, email: {}, role: {}", userId, email, role);
        return userService.getUserInfo(userId);
    }

    @Operation(
            summary = "사용자 정보 조회 (ID로)",
            description = "특정 사용자의 정보를 ID로 조회합니다.",
            security = @SecurityRequirement(name = "bearer-jwt")
    )
    @ApiResponses(value = {
            @ApiResponse(
                    responseCode = "200",
                    description = "조회 성공",
                    content = @Content(
                            mediaType = "application/json",
                            schema = @Schema(implementation = UserResponse.class)
                    )
            ),
            @ApiResponse(
                    responseCode = "404",
                    description = "사용자를 찾을 수 없음"
            )
    })
    @GetMapping("/{userId}")
    public UserResponse getUserById(@PathVariable Long userId) {
        log.info("사용자 정보 조회 (ID) - userId: {}", userId);
        return userService.getUserInfo(userId);
    }
}
