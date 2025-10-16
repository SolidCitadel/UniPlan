package com.uniplan.user.domain.user.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "google_id", unique = true)
    private String googleId;  // OAuth2 sub (Google User ID) - nullable for local users

    @Column(unique = true, nullable = false)
    private String email;

    @Column(length = 100)
    private String name;

    @Column(length = 255)
    private String password;  // 로컬 회원가입 시 암호화된 비밀번호 (OAuth2 사용자는 null)

    @Column(columnDefinition = "TEXT")
    private String picture;

    @Column(name = "display_name", length = 50)
    private String displayName;  // 사용자 커스텀 닉네임

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private UserRole role = UserRole.USER;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    @Builder.Default
    private UserStatus status = UserStatus.ACTIVE;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * OAuth2 로그인 후 사용자 정보 업데이트
     */
    public void updateFromOAuth2(String name, String picture, String email) {
        this.name = name;
        this.picture = picture;
        this.email = email;
    }

    /**
     * 사용자 닉네임 변경
     */
    public void updateDisplayName(String displayName) {
        this.displayName = displayName;
    }

    /**
     * 사용자 상태 변경
     */
    public void updateStatus(UserStatus status) {
        this.status = status;
    }

    /**
     * 로컬 회원가입용 생성자 헬퍼
     */
    public static User createLocalUser(String email, String name, String password) {
        return User.builder()
                .email(email)
                .name(name)
                .password(password)
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();
    }

    /**
     * 비밀번호 변경
     */
    public void updatePassword(String newPassword) {
        this.password = newPassword;
    }
}
