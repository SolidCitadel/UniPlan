package com.uniplan.planner.global.exception;

public class DuplicateWishlistItemException extends RuntimeException {

    public DuplicateWishlistItemException(String message) {
        super(message);
    }

    public DuplicateWishlistItemException(Long courseId) {
        super("이미 희망과목에 추가된 강의입니다: courseId=" + courseId);
    }
}