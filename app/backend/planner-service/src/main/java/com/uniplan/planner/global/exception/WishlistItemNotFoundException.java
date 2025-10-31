package com.uniplan.planner.global.exception;

public class WishlistItemNotFoundException extends RuntimeException {

    public WishlistItemNotFoundException(String message) {
        super(message);
    }

    public WishlistItemNotFoundException(Long courseId) {
        super("희망과목을 찾을 수 없습니다: courseId=" + courseId);
    }
}