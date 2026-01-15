package com.uniplan.user.domain.auth.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.user.domain.auth.dto.LoginRequest;
import com.uniplan.user.domain.auth.dto.SignupRequest;
import com.uniplan.user.domain.university.entity.University;
import com.uniplan.user.domain.university.repository.UniversityRepository;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.entity.UserStatus;
import com.uniplan.user.domain.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import com.uniplan.user.domain.user.entity.User;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;
import static org.hamcrest.Matchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ActiveProfiles("test")
@DisplayName("AuthController 통합 테스트")
class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UniversityRepository universityRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private University testUniversity;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        // 테스트용 대학 생성 (이미 존재하면 조회)
        testUniversity = universityRepository.findByCode("TEST")
            .orElseGet(() -> universityRepository.save(
                University.builder()
                    .name("테스트대학교")
                    .code("TEST")
                    .build()
            ));
    }

    @Test
    @DisplayName("POST /auth/signup - 회원가입 성공")
    void signup_Success() throws Exception {
        // given
        SignupRequest request = new SignupRequest(
                "newuser@example.com",
                "password123",
                "신규사용자",
                testUniversity.getId()
        );

        // when & then
        mockMvc.perform(post("/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.accessToken").isNotEmpty())
                .andExpect(jsonPath("$.refreshToken").isNotEmpty())
                .andExpect(jsonPath("$.user.id").isNumber())
                .andExpect(jsonPath("$.user.email").value("newuser@example.com"))
                .andExpect(jsonPath("$.user.name").value("신규사용자"))
                .andExpect(jsonPath("$.user.role").value("USER"))
                .andExpect(jsonPath("$.user.universityId").value(testUniversity.getId()))
                .andExpect(jsonPath("$.user.universityName").value("테스트대학교"));
    }

    @Test
    @DisplayName("POST /auth/signup - 이메일 중복으로 회원가입 실패")
    void signup_Fail_DuplicateEmail() throws Exception {
        // given
        User existingUser = User.createLocalUser(
                "duplicate@example.com",
                "기존사용자",
                passwordEncoder.encode("password123"),
                testUniversity
        );
        userRepository.save(existingUser);

        SignupRequest request = new SignupRequest(
                "duplicate@example.com",
                "password456",
                "신규사용자",
                testUniversity.getId()
        );

        // when & then
        mockMvc.perform(post("/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict());
    }

    @Test
    @DisplayName("POST /auth/signup - 유효성 검증 실패 (이메일 형식)")
    void signup_Fail_InvalidEmailFormat() throws Exception {
        // given
        SignupRequest request = new SignupRequest(
                "invalid-email",
                "password123",
                "사용자",
                testUniversity.getId()
        );

        // when & then
        mockMvc.perform(post("/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("POST /auth/signup - 유효성 검증 실패 (비밀번호 길이)")
    void signup_Fail_InvalidPasswordLength() throws Exception {
        // given
        SignupRequest request = new SignupRequest(
                "user@example.com",
                "123",  // 6자 미만
                "사용자",
                testUniversity.getId()
        );

        // when & then
        mockMvc.perform(post("/auth/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("POST /auth/login - 로그인 성공")
    void login_Success() throws Exception {
        // given
        User user = User.createLocalUser(
                "test@example.com",
                "테스트사용자",
                passwordEncoder.encode("password123"),
                testUniversity
        );
        userRepository.save(user);

        LoginRequest request = new LoginRequest(
                "test@example.com",
                "password123"
        );

        // when & then
        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").isNotEmpty())
                .andExpect(jsonPath("$.refreshToken").isNotEmpty())
                .andExpect(jsonPath("$.user.id").isNumber())
                .andExpect(jsonPath("$.user.email").value("test@example.com"))
                .andExpect(jsonPath("$.user.name").value("테스트사용자"))
                .andExpect(jsonPath("$.user.role").value("USER"))
                .andExpect(jsonPath("$.user.universityId").value(testUniversity.getId()))
                .andExpect(jsonPath("$.user.universityName").value("테스트대학교"));
    }

    @Test
    @DisplayName("POST /auth/login - 존재하지 않는 이메일로 로그인 실패")
    void login_Fail_UserNotFound() throws Exception {
        // given
        LoginRequest request = new LoginRequest(
                "nonexistent@example.com",
                "password123"
        );

        // when & then
        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("POST /auth/login - 비밀번호 불일치로 로그인 실패")
    void login_Fail_InvalidPassword() throws Exception {
        // given
        User user = User.createLocalUser(
                "test@example.com",
                "테스트사용자",
                passwordEncoder.encode("password123"),
                testUniversity
        );
        userRepository.save(user);

        LoginRequest request = new LoginRequest(
                "test@example.com",
                "wrongpassword"
        );

        // when & then
        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("POST /auth/login - 유효성 검증 실패 (빈 이메일)")
    void login_Fail_EmptyEmail() throws Exception {
        // given
        LoginRequest request = new LoginRequest(
                "",
                "password123"
        );

        // when & then
        mockMvc.perform(post("/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }
}