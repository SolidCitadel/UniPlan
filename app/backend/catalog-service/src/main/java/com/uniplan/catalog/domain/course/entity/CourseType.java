package com.uniplan.catalog.domain.course.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "course_types")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class CourseType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 10)
    private String code;

    @Column(name = "name_kr", nullable = false, length = 50)
    private String nameKr;

    @Column(name = "name_en", length = 100)
    private String nameEn;
}