package com.uniplan.common.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * JWT 토큰 생성 및 파싱 유틸리티
 * 모든 마이크로서비스에서 공통으로 사용
 */
public class JwtTokenUtil {
    
    private final SecretKey secretKey;
    
    public JwtTokenUtil(String secret) {
        this.secretKey = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
    }
    
    /**
     * Access Token 생성
     */
    public String createAccessToken(JwtClaims jwtClaims, long expirationMillis) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expirationMillis);
        
        var builder = Jwts.builder()
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(secretKey, Jwts.SIG.HS256);
        
        jwtClaims.applyClaims(builder);
        
        return builder.compact();
    }
    
    /**
     * Refresh Token 생성
     */
    public String createRefreshToken(Long userId, long expirationMillis) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expirationMillis);
        
        return Jwts.builder()
                .subject(String.valueOf(userId))
                .claim(JwtConstants.CLAIM_TYPE, JwtConstants.TOKEN_TYPE_REFRESH)
                .issuedAt(now)
                .expiration(expiryDate)
                .signWith(secretKey, Jwts.SIG.HS256)
                .compact();
    }
    
    /**
     * JWT 토큰 파싱 및 Claims 추출
     */
    public Claims parseClaims(String token) {
        return Jwts.parser()
                .verifyWith(secretKey)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }
    
    /**
     * JWT 토큰에서 JwtClaims 객체 추출
     */
    public JwtClaims extractJwtClaims(String token) {
        Claims claims = parseClaims(token);
        return JwtClaims.fromClaims(claims);
    }
    
    /**
     * JWT 토큰 유효성 검증
     */
    public boolean validateToken(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Bearer 토큰에서 실제 토큰 추출
     */
    public static String extractBearerToken(String authorizationHeader) {
        if (authorizationHeader != null && authorizationHeader.startsWith(JwtConstants.BEARER_PREFIX)) {
            return authorizationHeader.substring(JwtConstants.BEARER_PREFIX.length());
        }
        return null;
    }
}

