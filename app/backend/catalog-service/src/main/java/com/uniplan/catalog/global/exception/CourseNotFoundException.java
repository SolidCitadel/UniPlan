package com.uniplan.catalog.global.exception;

public class CourseNotFoundException extends RuntimeException {
    public CourseNotFoundException(Long id) {
        super("강의를 찾을 수 없습니다: " + id);
    }
}
