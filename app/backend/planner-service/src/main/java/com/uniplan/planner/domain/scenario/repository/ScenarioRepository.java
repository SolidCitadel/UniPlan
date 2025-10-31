package com.uniplan.planner.domain.scenario.repository;

import com.uniplan.planner.domain.scenario.entity.Scenario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ScenarioRepository extends JpaRepository<Scenario, Long> {

    // 사용자의 모든 시나리오 조회
    List<Scenario> findByUserId(Long userId);

    // 사용자의 루트 시나리오들만 조회 (부모가 없는 것들)
    List<Scenario> findByUserIdAndParentScenarioIsNull(Long userId);

    // 특정 사용자의 특정 시나리오 조회 (권한 체크용)
    Optional<Scenario> findByIdAndUserId(Long id, Long userId);

    // 부모 시나리오의 자식들 조회
    List<Scenario> findByParentScenarioIdOrderByOrderIndexAsc(Long parentScenarioId);

    // 특정 강의 실패 시 대안 시나리오 찾기
    @Query("SELECT s FROM Scenario s WHERE s.parentScenario.id = :parentId AND s.failedCourseId = :courseId")
    Optional<Scenario> findAlternativeScenario(@Param("parentId") Long parentId, @Param("courseId") Long courseId);

    // 시나리오 트리 전체 조회 (루트부터 모든 자손까지)
    @Query("SELECT s FROM Scenario s LEFT JOIN FETCH s.childScenarios WHERE s.userId = :userId AND s.parentScenario IS NULL")
    List<Scenario> findRootScenariosWithChildren(@Param("userId") Long userId);
}