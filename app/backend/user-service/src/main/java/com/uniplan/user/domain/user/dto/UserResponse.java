package com.uniplan.user.domain.user.dto;

import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.entity.UserStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

import static io.swagger.v3.oas.annotations.media.Schema.RequiredMode.REQUIRED;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserResponse {

    @Schema(requiredMode = REQUIRED)
    private Long id;
    private String googleId;
    @Schema(requiredMode = REQUIRED)
    private String email;
    private String name;
    private String picture;
    private String displayName;
    @Schema(requiredMode = REQUIRED)
    private UserRole role;
    @Schema(requiredMode = REQUIRED)
    private UserStatus status;
    @Schema(requiredMode = REQUIRED)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    @Schema(requiredMode = REQUIRED, description = "사용자 소속 대학 ID")
    private Long universityId;

    /**
     * Entity -> DTO 변환
     */
    public static UserResponse from(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .googleId(user.getGoogleId())
                .email(user.getEmail())
                .name(user.getName())
                .picture(user.getPicture())
                .displayName(user.getDisplayName())
                .role(user.getRole())
                .status(user.getStatus())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .universityId(user.getUniversity() != null ? user.getUniversity().getId() : null)
                .build();
    }
}

