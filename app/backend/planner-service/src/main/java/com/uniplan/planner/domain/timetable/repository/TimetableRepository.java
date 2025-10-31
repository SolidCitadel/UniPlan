package com.uniplan.planner.domain.timetable.repository;

import com.uniplan.planner.domain.timetable.entity.Timetable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TimetableRepository extends JpaRepository<Timetable, Long> {

    List<Timetable> findByUserId(Long userId);

    List<Timetable> findByUserIdAndOpeningYearAndSemester(Long userId, Integer openingYear, String semester);

    Optional<Timetable> findByIdAndUserId(Long id, Long userId);
}