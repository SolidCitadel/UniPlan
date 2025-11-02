package com.uniplan.planner.domain.scenario.entity;

import com.uniplan.planner.domain.timetable.entity.Timetable;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "scenarios", indexes = {
    @Index(name = "idx_user_id", columnList = "user_id"),
    @Index(name = "idx_parent_scenario_id", columnList = "parent_scenario_id"),
    @Index(name = "idx_timetable_id", columnList = "timetable_id")
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Scenario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(length = 500)
    private String description;

    // 트리 구조: 부모 시나리오 (null이면 루트)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_scenario_id")
    private Scenario parentScenario;

    // 자식 시나리오들
    @OneToMany(mappedBy = "parentScenario", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Scenario> childScenarios = new ArrayList<>();

    // 실패 조건: 어떤 강의들이 실패했을 때 이 시나리오로 이동하는가
    // empty이면 기본(루트) 시나리오
    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "scenario_failed_courses",
                     joinColumns = @JoinColumn(name = "scenario_id"))
    @Column(name = "course_id")
    @Builder.Default
    private Set<Long> failedCourseIds = new HashSet<>();

    // 형제 노드 간 순서 (같은 부모의 자식들 중 순서)
    @Column(name = "order_index")
    private Integer orderIndex;

    // 이 시나리오의 실제 시간표
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "timetable_id", nullable = false)
    private Timetable timetable;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // 비즈니스 메서드
    public void addChildScenario(Scenario child) {
        this.childScenarios.add(child);
        child.setParentScenario(this);
    }

    public void removeChildScenario(Scenario child) {
        this.childScenarios.remove(child);
        child.setParentScenario(null);
    }

    public void updateInfo(String name, String description) {
        if (name != null) {
            this.name = name;
        }
        if (description != null) {
            this.description = description;
        }
    }

    public boolean isRoot() {
        return this.parentScenario == null;
    }

    public boolean isAlternative() {
        return !this.failedCourseIds.isEmpty();
    }

    // Setter for bidirectional relationship
    public void setParentScenario(Scenario parent) {
        this.parentScenario = parent;
    }
}