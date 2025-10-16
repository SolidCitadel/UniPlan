package com.uniplan.user.domain.user.service;

import com.uniplan.user.domain.user.dto.UserResponse;
import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.entity.UserRole;
import com.uniplan.user.domain.user.entity.UserStatus;
import com.uniplan.user.domain.user.repository.UserRepository;
import com.uniplan.user.global.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
@Slf4j
public class UserService {

    private final UserRepository userRepository;

    /**
     * Google OAuth2 로그인 시 사용자 찾기 또는 생성
     *
     * @param googleId Google User ID (sub)
     * @param email 이메일
     * @param name 이름
     * @param picture 프로필 사진 URL
     * @return 생성 또는 업데이트된 사용자
     */
    @Transactional
    public User findOrCreateUser(String googleId, String email, String name, String picture) {
        return userRepository.findByGoogleId(googleId)
                .map(existingUser -> {
                    // 기존 사용자 정보 업데이트
                    log.info("기존 사용자 정보 업데이트: googleId={}, email={}", googleId, email);
                    existingUser.updateFromOAuth2(name, picture, email);
                    return userRepository.save(existingUser);
                })
                .orElseGet(() -> {
                    // 새 사용자 생성
                    log.info("신규 사용자 생성: googleId={}, email={}", googleId, email);
                    User newUser = User.builder()
                            .googleId(googleId)
                            .email(email)
                            .name(name)
                            .picture(picture)
                            .displayName(name)  // 초기 displayName은 name과 동일
                            .role(UserRole.USER)
                            .status(UserStatus.ACTIVE)
                            .build();
                    return userRepository.save(newUser);
                });
    }

    /**
     * 사용자 ID로 조회
     */
    public User findById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("사용자를 찾을 수 없습니다: " + userId));
    }

    /**
     * 사용자 정보를 DTO로 변환하여 반환
     */
    public UserResponse getUserInfo(Long userId) {
        User user = findById(userId);
        return UserResponse.from(user);
    }

    /**
     * Google ID로 사용자 조회
     */
    public User findByGoogleId(String googleId) {
        return userRepository.findByGoogleId(googleId)
                .orElseThrow(() -> new ResourceNotFoundException("사용자를 찾을 수 없습니다: " + googleId));
    }
}
