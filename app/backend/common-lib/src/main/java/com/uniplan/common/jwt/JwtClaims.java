package com.uniplan.common.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtBuilder;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * JWT Claims를 표현하는 DTO
 * JWT 구조가 변경되어도 이 클래스만 수정하면 모든 서비스에 반영됨
 */
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JwtClaims {
    
    private Long userId;
    private String email;
    private String role;
    
    /**
     * JWT Claims에서 JwtClaims 객체 생성
     */
    public static JwtClaims fromClaims(Claims claims) {
        return JwtClaims.builder()
                .userId(parseLongSafely(claims.getSubject()))
                .email(claims.get(JwtConstants.CLAIM_EMAIL, String.class))
                .role(claims.get(JwtConstants.CLAIM_ROLE, String.class))
                .build();
    }
    
    /**
     * JwtBuilder에 Claims 적용
     */
    public void applyClaims(JwtBuilder builder) {
        builder.subject(String.valueOf(userId))
               .claim(JwtConstants.CLAIM_EMAIL, email)
               .claim(JwtConstants.CLAIM_ROLE, role);
    }
    
    /**
     * String을 Long으로 안전하게 변환
     */
    private static Long parseLongSafely(String value) {
        if (value == null || value.isEmpty()) {
            return null;
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    /**
     * 기본값을 포함한 값 반환
     */
    public String getEmailOrEmpty() {
        return email != null ? email : "";
    }
    
    public String getRoleOrDefault() {
        return role != null ? role : "USER";
    }
}

