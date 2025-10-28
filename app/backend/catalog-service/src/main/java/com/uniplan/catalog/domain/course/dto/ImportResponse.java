package com.uniplan.catalog.domain.course.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ImportResponse {
    private String message;
    private Integer totalCount;
    private Integer successCount;
    private Integer failureCount;
}
