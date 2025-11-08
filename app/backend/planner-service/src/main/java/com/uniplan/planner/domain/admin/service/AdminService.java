package com.uniplan.planner.domain.admin.service;

import com.uniplan.planner.domain.admin.controller.AdminController.ResetStats;
import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.domain.wishlist.repository.WishlistItemRepository;
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

    private final RegistrationRepository registrationRepository;
    private final ScenarioRepository scenarioRepository;
    private final TimetableRepository timetableRepository;
    private final WishlistItemRepository wishlistItemRepository;

    @PersistenceContext
    private EntityManager entityManager;

    /**
     * 모든 플래너 데이터 삭제 및 Auto-increment 리셋
     * @return 삭제 통계
     */
    @Transactional
    public ResetStats resetAllPlannerData() {
        // 외래키 제약 조건 체크 비활성화 (MySQL)
        entityManager.createNativeQuery("SET FOREIGN_KEY_CHECKS = 0").executeUpdate();

        try {
            // 1. Registration 삭제 (RegistrationStep은 cascade로 삭제됨)
            long registrationCount = registrationRepository.count();
            entityManager.createNativeQuery("TRUNCATE TABLE registration_steps").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE registrations").executeUpdate();
            log.info("삭제된 Registration: {} 건", registrationCount);

            // 2. Scenario 삭제 (childScenarios, failedCourses는 cascade로 삭제됨)
            long scenarioCount = scenarioRepository.count();
            entityManager.createNativeQuery("TRUNCATE TABLE scenario_failed_courses").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE scenarios").executeUpdate();
            log.info("삭제된 Scenario: {} 건", scenarioCount);

            // 3. Timetable 삭제 (TimetableItem, excludedCourses는 cascade로 삭제됨)
            long timetableCount = timetableRepository.count();
            entityManager.createNativeQuery("TRUNCATE TABLE timetable_excluded_courses").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE timetable_items").executeUpdate();
            entityManager.createNativeQuery("TRUNCATE TABLE timetables").executeUpdate();
            log.info("삭제된 Timetable: {} 건", timetableCount);

            // 4. WishlistItem 삭제
            long wishlistCount = wishlistItemRepository.count();
            entityManager.createNativeQuery("TRUNCATE TABLE wishlist_items").executeUpdate();
            log.info("삭제된 WishlistItem: {} 건", wishlistCount);

            return new ResetStats(
                (int) registrationCount,
                (int) scenarioCount,
                (int) timetableCount,
                (int) wishlistCount
            );

        } finally {
            // 외래키 제약 조건 체크 재활성화
            entityManager.createNativeQuery("SET FOREIGN_KEY_CHECKS = 1").executeUpdate();
            log.info("플래너 데이터 AUTO_INCREMENT 리셋 완료");
        }
    }
}
