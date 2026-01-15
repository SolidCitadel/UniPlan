package com.uniplan.catalog.domain.university.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * 대학 참조 테이블 (catalog-service는 독립 DB이므로 별도 관리)
 */
@Entity
@Table(name = "university")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class University {

    @Id
    private Long id;

    @Column(nullable = false, unique = true, length = 20)
    private String code;
}
