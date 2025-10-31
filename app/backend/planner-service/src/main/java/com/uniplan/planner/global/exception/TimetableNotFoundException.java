package com.uniplan.planner.global.exception;

public class TimetableNotFoundException extends RuntimeException {
    public TimetableNotFoundException(String message) {
        super(message);
    }

    public TimetableNotFoundException(Long timetableId) {
        super("시간표를 찾을 수 없습니다: " + timetableId);
    }
}