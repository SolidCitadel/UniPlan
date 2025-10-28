package com.uniplan.user.domain.user.repository;

import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.entity.UserStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;

@DataJpaTest
@ActiveProfiles("test")
@DisplayName("UserRepository 테스트")
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    private User localUser;
    private User googleUser;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();

        // 로컬 회원가입 사용자
        localUser = User.builder()
                .email("local@example.com")
                .name("로컬사용자")
                .password("encodedPassword")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();

        // Google OAuth2 사용자
        googleUser = User.builder()
                .googleId("google123")
                .email("google@example.com")
                .name("구글사용자")
                .picture("https://example.com/picture.jpg")
                .displayName("구글닉네임")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();
    }

    @Test
    @DisplayName("사용자 저장 및 조회")
    void save_AndFind() {
        // when
        User savedUser = userRepository.save(localUser);

        // then
        assertThat(savedUser.getId()).isNotNull();
        assertThat(savedUser.getEmail()).isEqualTo("local@example.com");
        assertThat(savedUser.getName()).isEqualTo("로컬사용자");
        assertThat(savedUser.getCreatedAt()).isNotNull();
        assertThat(savedUser.getUpdatedAt()).isNotNull();

        // 조회
        Optional<User> found = userRepository.findById(savedUser.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getEmail()).isEqualTo("local@example.com");
    }

    @Test
    @DisplayName("이메일로 사용자 조회 성공")
    void findByEmail_Success() {
        // given
        userRepository.save(localUser);

        // when
        Optional<User> found = userRepository.findByEmail("local@example.com");

        // then
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("로컬사용자");
    }

    @Test
    @DisplayName("이메일로 사용자 조회 실패 - 존재하지 않음")
    void findByEmail_NotFound() {
        // when
        Optional<User> found = userRepository.findByEmail("nonexistent@example.com");

        // then
        assertThat(found).isEmpty();
    }

    @Test
    @DisplayName("Google ID로 사용자 조회 성공")
    void findByGoogleId_Success() {
        // given
        userRepository.save(googleUser);

        // when
        Optional<User> found = userRepository.findByGoogleId("google123");

        // then
        assertThat(found).isPresent();
        assertThat(found.get().getEmail()).isEqualTo("google@example.com");
        assertThat(found.get().getName()).isEqualTo("구글사용자");
        assertThat(found.get().getPicture()).isEqualTo("https://example.com/picture.jpg");
    }

    @Test
    @DisplayName("Google ID로 사용자 조회 실패 - 존재하지 않음")
    void findByGoogleId_NotFound() {
        // when
        Optional<User> found = userRepository.findByGoogleId("nonexistent");

        // then
        assertThat(found).isEmpty();
    }

    @Test
    @DisplayName("이메일 존재 여부 확인 - 존재함")
    void existsByEmail_True() {
        // given
        userRepository.save(localUser);

        // when
        boolean exists = userRepository.existsByEmail("local@example.com");

        // then
        assertThat(exists).isTrue();
    }

    @Test
    @DisplayName("이메일 존재 여부 확인 - 존재하지 않음")
    void existsByEmail_False() {
        // when
        boolean exists = userRepository.existsByEmail("nonexistent@example.com");

        // then
        assertThat(exists).isFalse();
    }

    @Test
    @DisplayName("Google ID 존재 여부 확인 - 존재함")
    void existsByGoogleId_True() {
        // given
        userRepository.save(googleUser);

        // when
        boolean exists = userRepository.existsByGoogleId("google123");

        // then
        assertThat(exists).isTrue();
    }

    @Test
    @DisplayName("Google ID 존재 여부 확인 - 존재하지 않음")
    void existsByGoogleId_False() {
        // when
        boolean exists = userRepository.existsByGoogleId("nonexistent");

        // then
        assertThat(exists).isFalse();
    }

    @Test
    @DisplayName("사용자 정보 업데이트 (OAuth2)")
    void updateFromOAuth2() {
        // given
        User savedUser = userRepository.save(googleUser);

        // when
        savedUser.updateFromOAuth2(
                "업데이트된 이름",
                "https://example.com/new_picture.jpg",
                "newemail@example.com"
        );
        User updatedUser = userRepository.save(savedUser);

        // then
        assertThat(updatedUser.getName()).isEqualTo("업데이트된 이름");
        assertThat(updatedUser.getPicture()).isEqualTo("https://example.com/new_picture.jpg");
        assertThat(updatedUser.getEmail()).isEqualTo("newemail@example.com");
        assertThat(updatedUser.getUpdatedAt()).isNotNull();
    }

    @Test
    @DisplayName("사용자 닉네임 변경")
    void updateDisplayName() {
        // given
        User savedUser = userRepository.save(localUser);

        // when
        savedUser.updateDisplayName("새로운닉네임");
        User updatedUser = userRepository.save(savedUser);

        // then
        assertThat(updatedUser.getDisplayName()).isEqualTo("새로운닉네임");
    }

    @Test
    @DisplayName("사용자 상태 변경")
    void updateStatus() {
        // given
        User savedUser = userRepository.save(localUser);
        assertThat(savedUser.getStatus()).isEqualTo(UserStatus.ACTIVE);

        // when
        savedUser.updateStatus(UserStatus.INACTIVE);
        User updatedUser = userRepository.save(savedUser);

        // then
        assertThat(updatedUser.getStatus()).isEqualTo(UserStatus.INACTIVE);
    }

    @Test
    @DisplayName("사용자 삭제")
    void deleteUser() {
        // given
        User savedUser = userRepository.save(localUser);
        Long userId = savedUser.getId();

        // when
        userRepository.delete(savedUser);

        // then
        Optional<User> found = userRepository.findById(userId);
        assertThat(found).isEmpty();
    }

    @Test
    @DisplayName("로컬 사용자와 OAuth2 사용자 구분")
    void distinguishLocalAndOAuthUser() {
        // given
        userRepository.save(localUser);
        userRepository.save(googleUser);

        // when
        User foundLocal = userRepository.findByEmail("local@example.com").orElseThrow();
        User foundGoogle = userRepository.findByEmail("google@example.com").orElseThrow();

        // then
        // 로컬 사용자는 password가 있고 googleId가 null
        assertThat(foundLocal.getPassword()).isNotNull();
        assertThat(foundLocal.getGoogleId()).isNull();

        // OAuth2 사용자는 googleId가 있고 password가 null
        assertThat(foundGoogle.getGoogleId()).isNotNull();
        assertThat(foundGoogle.getPassword()).isNull();
    }
}