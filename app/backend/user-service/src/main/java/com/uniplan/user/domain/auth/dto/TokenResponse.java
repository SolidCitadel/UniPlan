package com.uniplan.user.domain.auth.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TokenResponse {

    @Schema(requiredMode = REQUIRED)
    private String accessToken;
    @Schema(requiredMode = REQUIRED)
    private String refreshToken;
    @Schema(requiredMode = REQUIRED)
    private String tokenType;
    @Schema(requiredMode = REQUIRED)
    private Long expiresIn;  // 초 단위

    public static TokenResponse of(String accessToken, String refreshToken, Long expiresIn) {
        return TokenResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(expiresIn)
                .build();
    }
}

