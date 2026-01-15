package com.uniplan.user.domain.user.repository;

import com.uniplan.user.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    /**
     * Google ID로 사용자 조회
     */
    Optional<User> findByGoogleId(String googleId);

    /**
     * 이메일로 사용자 조회
     */
    Optional<User> findByEmail(String email);

    /**
     * 이메일로 사용자 조회 (대학 정보 포함)
     */
    @Query("SELECT u FROM User u JOIN FETCH u.university WHERE u.email = :email")
    Optional<User> findByEmailWithUniversity(@Param("email") String email);

    /**
     * Google ID 존재 여부 확인
     */
    boolean existsByGoogleId(String googleId);

    /**
     * 이메일 존재 여부 확인
     */
    boolean existsByEmail(String email);
}

