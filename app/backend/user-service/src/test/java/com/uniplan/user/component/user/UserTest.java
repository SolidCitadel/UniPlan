package com.uniplan.user.component.user;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.user.domain.university.entity.University;
import com.uniplan.user.domain.university.repository.UniversityRepository;
import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.entity.UserStatus;
import com.uniplan.user.config.DockerRequiredExtension;
import com.uniplan.user.domain.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ExtendWith(DockerRequiredExtension.class)
@DisplayName("UserController 통합 테스트")
class UserTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UniversityRepository universityRepository;

    private User testUser;
    private University testUniversity;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        
        // Create test university
        testUniversity = universityRepository.findByCode("TEST")
            .orElseGet(() -> universityRepository.save(
                University.builder()
                    .name("테스트대학교")
                    .code("TEST")
                    .build()
            ));

        testUser = User.builder()
                .email("test@example.com")
                .name("테스트사용자")
                .displayName("테스터")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .university(testUniversity)
                .build();
        testUser = userRepository.save(testUser);
    }

    @Test
    @DisplayName("GET /users/me - 내 정보 조회 성공")
    void getMyInfo_Success() throws Exception {
        // when & then
        mockMvc.perform(get("/users/me")
                        .header("X-User-Id", testUser.getId())
                        .header("X-User-Email", testUser.getEmail())
                        .header("X-User-Role", testUser.getRole().name())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testUser.getId()))
                .andExpect(jsonPath("$.email").value("test@example.com"))
                .andExpect(jsonPath("$.name").value("테스트사용자"))
                .andExpect(jsonPath("$.displayName").value("테스터"))
                .andExpect(jsonPath("$.role").value("USER"))
                .andExpect(jsonPath("$.status").value("ACTIVE"))
                .andExpect(jsonPath("$.universityId").value(testUniversity.getId().intValue()));
    }

    @Test
    @DisplayName("GET /users/me - X-User-Id 헤더 없이 요청 실패")
    void getMyInfo_Fail_MissingHeader() throws Exception {
        // when & then
        // X-User-Id 헤더가 없으면 Spring MVC가 500 Internal Server Error를 반환함
        // (required=true인 Long 타입 파라미터에 null을 바인딩할 수 없기 때문)
        mockMvc.perform(get("/users/me")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isInternalServerError());
    }

    @Test
    @DisplayName("GET /users/me - 존재하지 않는 사용자 ID로 요청 실패")
    void getMyInfo_Fail_UserNotFound() throws Exception {
        // when & then
        mockMvc.perform(get("/users/me")
                        .header("X-User-Id", 99999L)
                        .header("X-User-Email", "nonexistent@example.com")
                        .header("X-User-Role", "USER")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("GET /users/{userId} - 사용자 정보 조회 성공")
    void getUserById_Success() throws Exception {
        // when & then
        mockMvc.perform(get("/users/{userId}", testUser.getId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(testUser.getId()))
                .andExpect(jsonPath("$.email").value("test@example.com"))
                .andExpect(jsonPath("$.name").value("테스트사용자"))
                .andExpect(jsonPath("$.displayName").value("테스터"));
    }

    @Test
    @DisplayName("GET /users/{userId} - 존재하지 않는 사용자 조회 실패")
    void getUserById_Fail_UserNotFound() throws Exception {
        // when & then
        mockMvc.perform(get("/users/{userId}", 99999L)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("GET /users/{userId} - Google OAuth2 사용자 조회")
    void getUserById_GoogleUser() throws Exception {
        // given
        User googleUser = User.builder()
                .googleId("google123")
                .email("google@example.com")
                .name("구글사용자")
                .picture("https://example.com/picture.jpg")
                .displayName("구글닉네임")
                .role(UserRole.USER)
                .status(UserStatus.ACTIVE)
                .university(testUniversity)
                .build();
        googleUser = userRepository.save(googleUser);

        // when & then
        mockMvc.perform(get("/users/{userId}", googleUser.getId())
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(googleUser.getId()))
                .andExpect(jsonPath("$.googleId").value("google123"))
                .andExpect(jsonPath("$.email").value("google@example.com"))
                .andExpect(jsonPath("$.name").value("구글사용자"))
                .andExpect(jsonPath("$.picture").value("https://example.com/picture.jpg"))
                .andExpect(jsonPath("$.displayName").value("구글닉네임"));
    }
}