package com.uniplan.user.domain.auth.service;

import com.uniplan.common.jwt.JwtClaims;
import com.uniplan.common.jwt.JwtTokenUtil;
import io.jsonwebtoken.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * JWT 토큰 생성 및 검증
 * common-lib의 JwtTokenUtil을 사용하여 JWT 구조를 중앙화
 */
@Component
@Slf4j
public class JwtTokenProvider {

    private final JwtTokenUtil jwtTokenUtil;
    private final long accessTokenExpiration;
    private final long refreshTokenExpiration;

    public JwtTokenProvider(
            @Value("${jwt.secret}") String secret,
            @Value("${jwt.expiration}") long accessTokenExpiration,
            @Value("${jwt.refresh-expiration}") long refreshTokenExpiration
    ) {
        this.jwtTokenUtil = new JwtTokenUtil(secret);
        this.accessTokenExpiration = accessTokenExpiration;
        this.refreshTokenExpiration = refreshTokenExpiration;
    }

    /**
     * Access Token 생성 (사용자 정보 포함)
     * common-lib의 JwtClaims와 JwtTokenUtil 사용
     */
    public String createAccessToken(Long userId, String email, String role) {
        JwtClaims jwtClaims = JwtClaims.builder()
                .userId(userId)
                .email(email)
                .role(role)
                .build();
        
        return jwtTokenUtil.createAccessToken(jwtClaims, accessTokenExpiration);
    }

    /**
     * Access Token 생성 (기본 - userId만)
     */
    public String generateAccessToken(Long userId) {
        JwtClaims jwtClaims = JwtClaims.builder()
                .userId(userId)
                .build();
        
        return jwtTokenUtil.createAccessToken(jwtClaims, accessTokenExpiration);
    }

    /**
     * Refresh Token 생성
     */
    public String createRefreshToken(Long userId) {
        return jwtTokenUtil.createRefreshToken(userId, refreshTokenExpiration);
    }

    /**
     * Refresh Token 생성 (기본)
     */
    public String generateRefreshToken(Long userId) {
        return jwtTokenUtil.createRefreshToken(userId, refreshTokenExpiration);
    }

    /**
     * 토큰에서 사용자 ID 추출
     * common-lib의 JwtTokenUtil 사용
     */
    public Long getUserIdFromToken(String token) {
        JwtClaims jwtClaims = jwtTokenUtil.extractJwtClaims(token);
        return jwtClaims.getUserId();
    }

    /**
     * 토큰 유효성 검증
     * common-lib의 JwtTokenUtil 사용
     */
    public boolean validateToken(String token) {
        try {
            return jwtTokenUtil.validateToken(token);
        } catch (SecurityException | MalformedJwtException e) {
            log.error("Invalid JWT signature: {}", e.getMessage());
        } catch (ExpiredJwtException e) {
            log.error("Expired JWT token: {}", e.getMessage());
        } catch (UnsupportedJwtException e) {
            log.error("Unsupported JWT token: {}", e.getMessage());
        } catch (IllegalArgumentException e) {
            log.error("JWT claims string is empty: {}", e.getMessage());
        }
        return false;
    }

    /**
     * Access Token 만료 시간 반환 (초 단위)
     */
    public long getAccessTokenExpirationInSeconds() {
        return accessTokenExpiration / 1000;
    }
}
