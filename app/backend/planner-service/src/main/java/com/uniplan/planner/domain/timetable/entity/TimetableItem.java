package com.uniplan.planner.domain.timetable.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "timetable_items", indexes = {
    @Index(name = "idx_timetable_id", columnList = "timetable_id"),
    @Index(name = "idx_course_id", columnList = "course_id")
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class TimetableItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "timetable_id", nullable = false)
    private Timetable timetable;

    @Column(name = "course_id", nullable = false)
    private Long courseId;

    @CreationTimestamp
    @Column(name = "added_at", nullable = false, updatable = false)
    private LocalDateTime addedAt;

    /**
     * 양방향 연관관계 설정용 (Timetable.addItem()에서 호출)
     */
    public void setTimetable(Timetable timetable) {
        this.timetable = timetable;
    }
}