package com.uniplan.user.domain.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Schema(description = "인증 응답 (회원가입/로그인)")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponse {

    @Schema(description = "액세스 토큰 (JWT)", requiredMode = REQUIRED)
    private String accessToken;

    @Schema(description = "리프레시 토큰 (JWT)", requiredMode = REQUIRED)
    private String refreshToken;

    @Schema(description = "사용자 정보", requiredMode = REQUIRED)
    private UserInfo user;

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class UserInfo {
        @Schema(description = "사용자 ID", requiredMode = REQUIRED)
        private Long id;

        @Schema(description = "사용자 이메일", requiredMode = REQUIRED)
        private String email;

        @Schema(description = "사용자 이름", requiredMode = REQUIRED)
        private String name;

        @Schema(description = "사용자 역할", example = "USER", requiredMode = REQUIRED)
        private String role;

        @Schema(description = "대학 ID", requiredMode = REQUIRED)
        private Long universityId;

        @Schema(description = "대학 이름", requiredMode = REQUIRED)
        private String universityName;
    }
}
