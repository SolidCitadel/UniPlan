package com.uniplan.catalog.domain.course.entity;

import com.uniplan.catalog.domain.university.entity.University;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "courses", indexes = {
    @Index(name = "idx_course_code", columnList = "course_code"),
    @Index(name = "idx_opening_year_semester", columnList = "opening_year,semester"),
    @Index(name = "idx_professor", columnList = "professor"),
    @Index(name = "idx_university", columnList = "university_id")
})
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "university_id", nullable = false)
    private University university;

    @Column(name = "opening_year", nullable = false)
    private Integer openingYear;

    @Column(nullable = false, length = 20)
    private String semester;

    @Column(name = "target_grade")
    private Integer targetGrade;

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

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "course_departments",
        joinColumns = @JoinColumn(name = "course_id"),
        inverseJoinColumns = @JoinColumn(name = "department_id")
    )
    @Builder.Default
    private List<Department> departments = new ArrayList<>();

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

    /**
     * Update course with new data (for import upsert)
     */
    public void update(String courseName, Integer credits, String classroom,
                       String campus, String notes, Integer targetGrade,
                       CourseType courseType, List<Department> departments) {
        this.courseName = courseName;
        this.credits = credits;
        this.classroom = classroom;
        this.campus = campus;
        this.notes = notes;
        this.targetGrade = targetGrade;
        this.courseType = courseType;
        this.departments = departments;
    }

    /**
     * Clear and replace class times
     */
    public void replaceClassTimes(List<ClassTime> newClassTimes) {
        this.classTimes.clear();
        for (ClassTime ct : newClassTimes) {
            addClassTime(ct);
        }
    }
}
