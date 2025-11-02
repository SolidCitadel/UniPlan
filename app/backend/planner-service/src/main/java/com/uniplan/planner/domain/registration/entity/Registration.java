package com.uniplan.planner.domain.registration.entity;

import com.uniplan.planner.domain.scenario.entity.Scenario;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "registrations", indexes = {
    @Index(name = "idx_user_id", columnList = "user_id"),
    @Index(name = "idx_status", columnList = "status")
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Registration {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    // 시작 시나리오 (Plan A)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "start_scenario_id", nullable = false)
    private Scenario startScenario;

    // 현재 시나리오 (네비게이션에 따라 변경됨)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "current_scenario_id", nullable = false)
    private Scenario currentScenario;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RegistrationStatus status;

    @Column(name = "started_at", nullable = false)
    @CreationTimestamp
    private LocalDateTime startedAt;

    @Column(name = "completed_at")
    private LocalDateTime completedAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "registration", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("timestamp ASC")
    @Builder.Default
    private List<RegistrationStep> steps = new ArrayList<>();

    // 비즈니스 메서드
    public void addStep(RegistrationStep step) {
        this.steps.add(step);
        step.setRegistration(this);
    }

    public void navigateToScenario(Scenario nextScenario) {
        this.currentScenario = nextScenario;
    }

    public void complete() {
        this.status = RegistrationStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
    }

    public void cancel() {
        this.status = RegistrationStatus.CANCELLED;
        this.completedAt = LocalDateTime.now();
    }

    public boolean isInProgress() {
        return this.status == RegistrationStatus.IN_PROGRESS;
    }

    public List<Long> getAllSucceededCourses() {
        // 취소된 과목 제외
        java.util.Set<Long> canceledSet = steps.stream()
                .flatMap(step -> step.getCanceledCourses().stream())
                .collect(java.util.stream.Collectors.toSet());

        return steps.stream()
                .flatMap(step -> step.getSucceededCourses().stream())
                .distinct()
                .filter(courseId -> !canceledSet.contains(courseId))
                .toList();
    }

    public List<Long> getAllFailedCourses() {
        return steps.stream()
                .flatMap(step -> step.getFailedCourses().stream())
                .distinct()
                .toList();
    }

    public List<Long> getAllCanceledCourses() {
        return steps.stream()
                .flatMap(step -> step.getCanceledCourses().stream())
                .distinct()
                .toList();
    }
}