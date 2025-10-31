package com.uniplan.planner.global.exception;

public class DuplicateCourseException extends RuntimeException {
    public DuplicateCourseException(String message) {
        super(message);
    }

    public DuplicateCourseException(Long courseId) {
        super("이미 시간표에 추가된 강의입니다: " + courseId);
    }
}