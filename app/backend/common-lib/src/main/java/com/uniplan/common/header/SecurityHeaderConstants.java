package com.uniplan.common.header;

/**
 * 마이크로서비스 간 통신에 사용되는 보안 헤더 상수
 * API Gateway가 JWT를 파싱한 후 내부 서비스로 전달하는 헤더들
 */
public class SecurityHeaderConstants {
    
    /**
     * 사용자 ID 헤더
     * API Gateway에서 JWT의 subject를 추출하여 전달
     */
    public static final String X_USER_ID = "X-User-Id";
    
    /**
     * 사용자 이메일 헤더
     * API Gateway에서 JWT의 email claim을 추출하여 전달
     */
    public static final String X_USER_EMAIL = "X-User-Email";
    
    /**
     * 사용자 권한(Role) 헤더
     * API Gateway에서 JWT의 role claim을 추출하여 전달
     */
    public static final String X_USER_ROLE = "X-User-Role";
    
    private SecurityHeaderConstants() {
        // 인스턴스화 방지
    }
}

