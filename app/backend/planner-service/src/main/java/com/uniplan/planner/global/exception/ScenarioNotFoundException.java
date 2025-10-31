package com.uniplan.planner.global.exception;

public class ScenarioNotFoundException extends RuntimeException {
    public ScenarioNotFoundException(String message) {
        super(message);
    }

    public ScenarioNotFoundException(Long scenarioId) {
        super("시나리오를 찾을 수 없습니다: " + scenarioId);
    }
}