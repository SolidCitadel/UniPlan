package com.uniplan.common.jwt;

/**
 * JWT 관련 상수 정의
 */
public class JwtConstants {
    
    // JWT Claims 키
    public static final String CLAIM_EMAIL = "email";
    public static final String CLAIM_ROLE = "role";
    public static final String CLAIM_TYPE = "type";
    
    // Token Types
    public static final String TOKEN_TYPE_ACCESS = "access";
    public static final String TOKEN_TYPE_REFRESH = "refresh";
    
    // Authorization 헤더
    public static final String AUTHORIZATION_HEADER = "Authorization";
    public static final String BEARER_PREFIX = "Bearer ";
    
    private JwtConstants() {
        // 인스턴스화 방지
    }
}

