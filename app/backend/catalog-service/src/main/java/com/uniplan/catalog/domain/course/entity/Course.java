package com.uniplan.catalog.domain.course.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "courses", indexes = {
    @Index(name = "idx_course_code", columnList = "course_code"),
    @Index(name = "idx_opening_year_semester", columnList = "opening_year,semester"),
    @Index(name = "idx_professor", columnList = "professor")
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "opening_year", nullable = false)
    private Integer openingYear;

    @Column(nullable = false, length = 20)
    private String semester;

    @Column(name = "target_grade", length = 10)
    private String targetGrade;

    @Column(name = "course_code", nullable = false, length = 20)
    private String courseCode;

    @Column(length = 10)
    private String section;

    @Column(name = "course_name", nullable = false, length = 100)
    private String courseName;

    @Column(length = 50)
    private String professor;

    @Column(nullable = false)
    private Integer credits;

    @Column(length = 50)
    private String classroom;

    @Column(length = 20)
    private String campus;

    @Column(length = 500)
    private String notes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "department_id", nullable = false)
    private Department department;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "course_type_id", nullable = false)
    private CourseType courseType;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<ClassTime> classTimes = new ArrayList<>();

    public void addClassTime(ClassTime classTime) {
        this.classTimes.add(classTime);
        classTime.setCourse(this);
    }
}
