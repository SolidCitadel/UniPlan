package com.uniplan.user.domain.university.dto;

import com.uniplan.user.domain.university.entity.University;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Schema(description = "대학 정보")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UniversityResponse {

    @Schema(description = "대학 ID", requiredMode = REQUIRED)
    private Long id;

    @Schema(description = "대학 이름", requiredMode = REQUIRED)
    private String name;

    @Schema(description = "대학 코드", requiredMode = REQUIRED)
    private String code;

    public static UniversityResponse from(University university) {
        return UniversityResponse.builder()
                .id(university.getId())
                .name(university.getName())
                .code(university.getCode())
                .build();
    }
}
