package com.uniplan.user.domain.auth.service;

import com.uniplan.user.domain.auth.dto.AuthResponse;
import com.uniplan.user.domain.auth.dto.LoginRequest;
import com.uniplan.user.domain.auth.dto.SignupRequest;
import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.repository.UserRepository;
import com.uniplan.user.global.exception.AuthenticationException;
import com.uniplan.user.global.exception.DuplicateResourceException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AuthService 단위 테스트")
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtTokenProvider jwtTokenProvider;

    @InjectMocks
    private AuthService authService;

    private SignupRequest signupRequest;
    private LoginRequest loginRequest;
    private User user;

    @BeforeEach
    void setUp() {
        signupRequest = new SignupRequest(
                "test@example.com",
                "password123",
                "테스트사용자"
        );

        loginRequest = new LoginRequest(
                "test@example.com",
                "password123"
        );

        user = User.builder()
                .id(1L)
                .email("test@example.com")
                .name("테스트사용자")
                .password("encodedPassword")
                .role(UserRole.USER)
                .build();
    }

    @Test
    @DisplayName("회원가입 성공")
    void signup_Success() {
        // given
        given(userRepository.existsByEmail(anyString())).willReturn(false);
        given(passwordEncoder.encode(anyString())).willReturn("encodedPassword");
        given(userRepository.save(any(User.class))).willReturn(user);
        given(jwtTokenProvider.createAccessToken(anyLong(), anyString(), anyString()))
                .willReturn("accessToken");
        given(jwtTokenProvider.createRefreshToken(anyLong()))
                .willReturn("refreshToken");

        // when
        AuthResponse response = authService.signup(signupRequest);

        // then
        assertThat(response).isNotNull();
        assertThat(response.getAccessToken()).isEqualTo("accessToken");
        assertThat(response.getRefreshToken()).isEqualTo("refreshToken");
        assertThat(response.getUser()).isNotNull();
        assertThat(response.getUser().getId()).isEqualTo(1L);
        assertThat(response.getUser().getEmail()).isEqualTo("test@example.com");
        assertThat(response.getUser().getName()).isEqualTo("테스트사용자");
        assertThat(response.getUser().getRole()).isEqualTo("USER");

        then(userRepository).should().existsByEmail("test@example.com");
        then(passwordEncoder).should().encode("password123");
        then(userRepository).should().save(any(User.class));
    }

    @Test
    @DisplayName("회원가입 실패 - 이메일 중복")
    void signup_Fail_DuplicateEmail() {
        // given
        given(userRepository.existsByEmail(anyString())).willReturn(true);

        // when & then
        assertThatThrownBy(() -> authService.signup(signupRequest))
                .isInstanceOf(DuplicateResourceException.class)
                .hasMessage("이미 사용 중인 이메일입니다");

        then(userRepository).should().existsByEmail("test@example.com");
        then(passwordEncoder).should(never()).encode(anyString());
        then(userRepository).should(never()).save(any(User.class));
    }

    @Test
    @DisplayName("로그인 성공")
    void login_Success() {
        // given
        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(user));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(true);
        given(jwtTokenProvider.createAccessToken(anyLong(), anyString(), anyString()))
                .willReturn("accessToken");
        given(jwtTokenProvider.createRefreshToken(anyLong()))
                .willReturn("refreshToken");

        // when
        AuthResponse response = authService.login(loginRequest);

        // then
        assertThat(response).isNotNull();
        assertThat(response.getAccessToken()).isEqualTo("accessToken");
        assertThat(response.getRefreshToken()).isEqualTo("refreshToken");
        assertThat(response.getUser()).isNotNull();
        assertThat(response.getUser().getId()).isEqualTo(1L);
        assertThat(response.getUser().getEmail()).isEqualTo("test@example.com");
        assertThat(response.getUser().getRole()).isEqualTo("USER");

        then(userRepository).should().findByEmail("test@example.com");
        then(passwordEncoder).should().matches("password123", "encodedPassword");
    }

    @Test
    @DisplayName("로그인 실패 - 존재하지 않는 이메일")
    void login_Fail_UserNotFound() {
        // given
        given(userRepository.findByEmail(anyString())).willReturn(Optional.empty());

        // when & then
        assertThatThrownBy(() -> authService.login(loginRequest))
                .isInstanceOf(AuthenticationException.class)
                .hasMessage("이메일 또는 비밀번호가 올바르지 않습니다");

        then(userRepository).should().findByEmail("test@example.com");
        then(passwordEncoder).should(never()).matches(anyString(), anyString());
    }

    @Test
    @DisplayName("로그인 실패 - 비밀번호 불일치")
    void login_Fail_InvalidPassword() {
        // given
        given(userRepository.findByEmail(anyString())).willReturn(Optional.of(user));
        given(passwordEncoder.matches(anyString(), anyString())).willReturn(false);

        // when & then
        assertThatThrownBy(() -> authService.login(loginRequest))
                .isInstanceOf(AuthenticationException.class)
                .hasMessage("이메일 또는 비밀번호가 올바르지 않습니다");

        then(userRepository).should().findByEmail("test@example.com");
        then(passwordEncoder).should().matches("password123", "encodedPassword");
    }
}