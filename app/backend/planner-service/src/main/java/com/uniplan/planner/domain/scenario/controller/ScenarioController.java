package com.uniplan.planner.domain.scenario.controller;

import com.uniplan.planner.domain.scenario.dto.*;
import com.uniplan.planner.domain.scenario.service.ScenarioService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Scenario", description = "시나리오 및 의사결정 트리 관리 API")
@RestController
@RequestMapping("/scenarios")
@RequiredArgsConstructor
public class ScenarioController {

    private final ScenarioService scenarioService;

    @Operation(summary = "루트 시나리오 생성", description = "새로운 기본 시나리오를 생성합니다 (Plan A)")
    @PostMapping
    public ResponseEntity<ScenarioResponse> createRootScenario(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @Valid @RequestBody CreateScenarioRequest request) {
        ScenarioResponse response = scenarioService.createRootScenario(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "대안 시나리오 생성", description = "특정 강의 실패 시 사용할 대안 시나리오를 생성합니다 (Plan B, C, ...)")
    @PostMapping("/{parentScenarioId}/alternatives")
    public ResponseEntity<ScenarioResponse> createAlternativeScenario(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long parentScenarioId,
            @Valid @RequestBody CreateAlternativeScenarioRequest request) {
        ScenarioResponse response = scenarioService.createAlternativeScenario(userId, parentScenarioId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "루트 시나리오 목록 조회", description = "사용자의 모든 루트 시나리오를 조회합니다")
    @GetMapping
    public ResponseEntity<List<ScenarioResponse>> getRootScenarios(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId) {
        List<ScenarioResponse> responses = scenarioService.getRootScenarios(userId);
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "시나리오 상세 조회", description = "특정 시나리오의 상세 정보를 조회합니다 (직접 자식만)")
    @GetMapping("/{scenarioId}")
    public ResponseEntity<ScenarioResponse> getScenario(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long scenarioId) {
        ScenarioResponse response = scenarioService.getScenario(userId, scenarioId);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "시나리오 트리 전체 조회", description = "시나리오와 모든 하위 시나리오를 재귀적으로 조회합니다")
    @GetMapping("/{scenarioId}/tree")
    public ResponseEntity<ScenarioResponse> getScenarioWithFullTree(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long scenarioId) {
        ScenarioResponse response = scenarioService.getScenarioWithFullTree(userId, scenarioId);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "시나리오 정보 수정", description = "시나리오의 이름과 설명을 수정합니다")
    @PutMapping("/{scenarioId}")
    public ResponseEntity<ScenarioResponse> updateScenario(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long scenarioId,
            @Valid @RequestBody UpdateScenarioRequest request) {
        ScenarioResponse response = scenarioService.updateScenario(userId, scenarioId, request);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "시나리오 삭제", description = "시나리오를 삭제합니다 (자식 시나리오도 함께 삭제됨)")
    @DeleteMapping("/{scenarioId}")
    public ResponseEntity<Void> deleteScenario(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long scenarioId) {
        scenarioService.deleteScenario(userId, scenarioId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "실시간 네비게이션", description = "특정 강의 실패 시 다음 시나리오를 찾습니다")
    @PostMapping("/{scenarioId}/navigate")
    public ResponseEntity<ScenarioResponse> navigate(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long scenarioId,
            @Valid @RequestBody NavigationRequest request) {
        ScenarioResponse response = scenarioService.navigate(userId, scenarioId, request);
        return ResponseEntity.ok(response);
    }

    @Operation(summary = "자식 시나리오 목록 조회", description = "특정 시나리오의 모든 대안 시나리오를 조회합니다")
    @GetMapping("/{scenarioId}/children")
    public ResponseEntity<List<ScenarioResponse>> getChildScenarios(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long scenarioId) {
        List<ScenarioResponse> responses = scenarioService.getChildScenarios(userId, scenarioId);
        return ResponseEntity.ok(responses);
    }
}