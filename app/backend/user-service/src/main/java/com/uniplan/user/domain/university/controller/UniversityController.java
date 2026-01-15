package com.uniplan.user.domain.university.controller;

import com.uniplan.user.domain.university.dto.UniversityResponse;
import com.uniplan.user.domain.university.repository.UniversityRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "University", description = "대학 API")
@RestController
@RequestMapping("/universities")
@RequiredArgsConstructor
public class UniversityController {

    private final UniversityRepository universityRepository;

    @Operation(summary = "대학 목록 조회", description = "회원가입 시 선택 가능한 대학 목록을 조회합니다")
    @GetMapping
    public ResponseEntity<List<UniversityResponse>> getUniversities() {
        List<UniversityResponse> universities = universityRepository.findAll().stream()
                .map(UniversityResponse::from)
                .toList();
        return ResponseEntity.ok(universities);
    }
}
