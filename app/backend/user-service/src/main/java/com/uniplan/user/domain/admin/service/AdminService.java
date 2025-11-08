package com.uniplan.user.domain.admin.service;

import com.uniplan.user.domain.user.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Admin Service (개발 환경 전용)
 * 테스트 데이터 초기화 등 관리 기능 제공
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Profile("local")  // 개발 환경에서만 활성화
public class AdminService {

    private final UserRepository userRepository;

    @PersistenceContext
    private EntityManager entityManager;

    /**
     * 모든 사용자 삭제 및 Auto-increment 리셋
     * @return 삭제된 사용자 수
     */
    @Transactional
    public int resetAllUsers() {
        // 1. 모든 사용자 삭제
        long count = userRepository.count();
        userRepository.deleteAll();

        log.info("삭제된 사용자 수: {}", count);

        // 2. Auto-increment 리셋 (MySQL)
        entityManager.createNativeQuery("ALTER TABLE users AUTO_INCREMENT = 1").executeUpdate();

        log.info("users 테이블 AUTO_INCREMENT 리셋 완료");

        return (int) count;
    }
}
