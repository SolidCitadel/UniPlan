package com.uniplan.user.global.exception;

/**
 * 리소스를 찾을 수 없음 예외 (404 Not Found)
 */
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
