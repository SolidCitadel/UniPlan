package com.uniplan.user.global.exception;

/**
 * 리소스 중복 예외 (409 Conflict)
 */
public class DuplicateResourceException extends RuntimeException {
    public DuplicateResourceException(String message) {
        super(message);
    }
}

