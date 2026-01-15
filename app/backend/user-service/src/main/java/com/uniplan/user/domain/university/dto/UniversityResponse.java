package com.uniplan.user.domain.university.dto;

import com.uniplan.user.domain.university.entity.University;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Schema(description = "대학 정보")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UniversityResponse {

    @Schema(description = "대학 ID")
    private Long id;

    @Schema(description = "대학 이름")
    private String name;

    @Schema(description = "대학 코드")
    private String code;

    public static UniversityResponse from(University university) {
        return UniversityResponse.builder()
                .id(university.getId())
                .name(university.getName())
                .code(university.getCode())
                .build();
    }
}
