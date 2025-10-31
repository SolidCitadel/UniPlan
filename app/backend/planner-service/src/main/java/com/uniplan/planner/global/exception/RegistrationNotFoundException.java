package com.uniplan.planner.global.exception;

public class RegistrationNotFoundException extends RuntimeException {
    public RegistrationNotFoundException(String message) {
        super(message);
    }

    public RegistrationNotFoundException(Long registrationId) {
        super("수강신청 세션을 찾을 수 없습니다: " + registrationId);
    }
}