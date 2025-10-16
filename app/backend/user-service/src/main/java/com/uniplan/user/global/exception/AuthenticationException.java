package com.uniplan.user.global.exception;

/**
 * 인증 실패 예외 (401 Unauthorized)
 */
public class AuthenticationException extends RuntimeException {
    public AuthenticationException(String message) {
        super(message);
    }
}

