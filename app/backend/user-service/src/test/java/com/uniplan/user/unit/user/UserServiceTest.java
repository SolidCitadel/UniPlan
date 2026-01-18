package com.uniplan.user.unit.user;

import com.uniplan.user.domain.user.dto.UserResponse;
import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.entity.UserStatus;
import com.uniplan.user.domain.user.repository.UserRepository;
import com.uniplan.user.domain.user.service.UserService;
import com.uniplan.user.global.exception.ResourceNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserService 단위 테스트")
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    void setUp() {
        user = User.builder()
                .id(1L)
                .email("test@example.com")
                .name("테스트사용자")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();
    }

    @Test
    @DisplayName("Google OAuth2 사용자 찾기 또는 생성 - 기존 사용자")
    void findOrCreateUser_ExistingUser() {
        // given
        String googleId = "google123";
        String email = "test@example.com";
        String name = "업데이트된 이름";
        String picture = "http://example.com/picture.jpg";

        User existingUser = User.builder()
                .id(1L)
                .googleId(googleId)
                .email("old@example.com")
                .name("기존 이름")
                .picture("old_picture.jpg")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();

        given(userRepository.findByGoogleId(googleId)).willReturn(Optional.of(existingUser));
        given(userRepository.save(any(User.class))).willReturn(existingUser);

        // when
        User result = userService.findOrCreateUser(googleId, email, name, picture);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getEmail()).isEqualTo(email);
        assertThat(result.getName()).isEqualTo(name);
        assertThat(result.getPicture()).isEqualTo(picture);

        then(userRepository).should().findByGoogleId(googleId);
        then(userRepository).should().save(any(User.class));
    }

    @Test
    @DisplayName("Google OAuth2 사용자 찾기 또는 생성 - 신규 사용자")
    void findOrCreateUser_NewUser() {
        // given
        String googleId = "google123";
        String email = "test@example.com";
        String name = "신규사용자";
        String picture = "http://example.com/picture.jpg";

        User newUser = User.builder()
                .id(1L)
                .googleId(googleId)
                .email(email)
                .name(name)
                .picture(picture)
                .displayName(name)
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();

        given(userRepository.findByGoogleId(googleId)).willReturn(Optional.empty());
        given(userRepository.save(any(User.class))).willReturn(newUser);

        // when
        User result = userService.findOrCreateUser(googleId, email, name, picture);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getGoogleId()).isEqualTo(googleId);
        assertThat(result.getEmail()).isEqualTo(email);
        assertThat(result.getName()).isEqualTo(name);
        assertThat(result.getPicture()).isEqualTo(picture);
        assertThat(result.getDisplayName()).isEqualTo(name);
        assertThat(result.getRole()).isEqualTo(UserRole.USER);
        assertThat(result.getStatus()).isEqualTo(UserStatus.ACTIVE);

        then(userRepository).should().findByGoogleId(googleId);
        then(userRepository).should().save(any(User.class));
    }

    @Test
    @DisplayName("사용자 ID로 조회 성공")
    void findById_Success() {
        // given
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        // when
        User result = userService.findById(1L);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getEmail()).isEqualTo("test@example.com");

        then(userRepository).should().findById(1L);
    }

    @Test
    @DisplayName("사용자 ID로 조회 실패 - 사용자 없음")
    void findById_Fail_UserNotFound() {
        // given
        given(userRepository.findById(anyLong())).willReturn(Optional.empty());

        // when & then
        assertThatThrownBy(() -> userService.findById(1L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("사용자를 찾을 수 없습니다");

        then(userRepository).should().findById(1L);
    }

    @Test
    @DisplayName("사용자 정보를 DTO로 변환하여 반환")
    void getUserInfo_Success() {
        // given
        given(userRepository.findById(1L)).willReturn(Optional.of(user));

        // when
        UserResponse response = userService.getUserInfo(1L);

        // then
        assertThat(response).isNotNull();
        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getEmail()).isEqualTo("test@example.com");
        assertThat(response.getName()).isEqualTo("테스트사용자");

        then(userRepository).should().findById(1L);
    }

    @Test
    @DisplayName("Google ID로 사용자 조회 성공")
    void findByGoogleId_Success() {
        // given
        String googleId = "google123";
        User googleUser = User.builder()
                .id(1L)
                .googleId(googleId)
                .email("test@example.com")
                .name("구글사용자")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .build();

        given(userRepository.findByGoogleId(googleId)).willReturn(Optional.of(googleUser));

        // when
        User result = userService.findByGoogleId(googleId);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getGoogleId()).isEqualTo(googleId);
        assertThat(result.getEmail()).isEqualTo("test@example.com");

        then(userRepository).should().findByGoogleId(googleId);
    }

    @Test
    @DisplayName("Google ID로 사용자 조회 실패 - 사용자 없음")
    void findByGoogleId_Fail_UserNotFound() {
        // given
        String googleId = "google123";
        given(userRepository.findByGoogleId(googleId)).willReturn(Optional.empty());

        // when & then
        assertThatThrownBy(() -> userService.findByGoogleId(googleId))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("사용자를 찾을 수 없습니다");

        then(userRepository).should().findByGoogleId(googleId);
    }
}