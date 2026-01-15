package com.uniplan.planner.global.exception;

import java.util.Set;

public class AlternativeScenarioNotFoundException extends RuntimeException {
    public AlternativeScenarioNotFoundException(Set<Long> failedCourseIds) {
        super("강의 " + failedCourseIds + " 실패에 대한 대안 시나리오가 없습니다");
    }
}
