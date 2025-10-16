package com.uniplan.user.domain.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Schema(description = "인증 응답 (회원가입/로그인)")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponse {

    @Schema(description = "액세스 토큰 (JWT)")
    private String accessToken;

    @Schema(description = "리프레시 토큰 (JWT)")
    private String refreshToken;

    @Schema(description = "토큰 타입", example = "Bearer")
    @Builder.Default
    private String tokenType = "Bearer";

    @Schema(description = "사용자 ID")
    private Long userId;

    @Schema(description = "사용자 이메일")
    private String email;

    @Schema(description = "사용자 이름")
    private String name;
}
