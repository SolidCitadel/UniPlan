package com.uniplan.planner.domain.timetable.repository;

import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TimetableItemRepository extends JpaRepository<TimetableItem, Long> {

    List<TimetableItem> findByTimetableId(Long timetableId);

    Optional<TimetableItem> findByTimetableIdAndCourseId(Long timetableId, Long courseId);

    boolean existsByTimetableIdAndCourseId(Long timetableId, Long courseId);
}