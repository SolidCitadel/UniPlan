package com.uniplan.planner.domain.registration.entity;

import com.uniplan.planner.domain.scenario.entity.Scenario;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "registration_steps", indexes = {
    @Index(name = "idx_registration_id", columnList = "registration_id")
})
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class RegistrationStep {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "registration_id", nullable = false)
    private Registration registration;

    // 이 단계에서 시도한 시나리오
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "scenario_id", nullable = false)
    private Scenario scenario;

    // 성공한 과목 ID 목록 (JSON array)
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "succeeded_courses", columnDefinition = "json")
    @Builder.Default
    private List<Long> succeededCourses = List.of();

    // 실패한 과목 ID 목록 (JSON array)
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "failed_courses", columnDefinition = "json")
    @Builder.Default
    private List<Long> failedCourses = List.of();

    // 취소한 과목 ID 목록 (JSON array) - 성공했지만 나중에 취소한 과목
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "canceled_courses", columnDefinition = "json")
    @Builder.Default
    private List<Long> canceledCourses = List.of();

    // 다음으로 이동한 시나리오 (null이면 현재 시나리오 유지)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "next_scenario_id")
    private Scenario nextScenario;

    @Column(length = 500)
    private String notes;

    @CreationTimestamp
    @Column(nullable = false, updatable = false)
    private LocalDateTime timestamp;
}