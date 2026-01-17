package com.uniplan.catalog.domain.course.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImportResponse {
    @Schema(requiredMode = REQUIRED)
    private String message;
    @Schema(requiredMode = REQUIRED)
    private Integer totalCount;
    @Schema(requiredMode = REQUIRED)
    private Integer successCount;
    @Schema(requiredMode = REQUIRED)
    private Integer failureCount;
}
