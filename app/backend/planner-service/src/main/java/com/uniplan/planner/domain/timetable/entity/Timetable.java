package com.uniplan.planner.domain.timetable.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "timetables", indexes = {
    @Index(name = "idx_user_id", columnList = "user_id"),
    @Index(name = "idx_opening_year_semester", columnList = "opening_year,semester")
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Timetable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(name = "opening_year", nullable = false)
    private Integer openingYear;

    @Column(nullable = false, length = 20)
    private String semester;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "timetable", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<TimetableItem> items = new ArrayList<>();

    public void addItem(TimetableItem item) {
        this.items.add(item);
        item.setTimetable(this);
    }

    public void removeItem(TimetableItem item) {
        this.items.remove(item);
        item.setTimetable(null);
    }

    public void updateName(String name) {
        this.name = name;
    }
}