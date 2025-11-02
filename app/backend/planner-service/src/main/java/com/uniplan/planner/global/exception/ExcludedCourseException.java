package com.uniplan.planner.global.exception;

public class ExcludedCourseException extends RuntimeException {
    public ExcludedCourseException(String message) {
        super(message);
    }

    public ExcludedCourseException(Long courseId) {
        super("제외된 과목은 추가할 수 없습니다: " + courseId);
    }
}
