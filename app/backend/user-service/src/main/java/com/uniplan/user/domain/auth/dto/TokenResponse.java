package com.uniplan.user.domain.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TokenResponse {

    private String accessToken;
    private String refreshToken;
    private String tokenType;
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

