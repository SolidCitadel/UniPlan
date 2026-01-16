package com.uniplan.planner.domain.wishlist.repository;

import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistItemRepository extends JpaRepository<WishlistItem, Long> {

    List<WishlistItem> findByUserIdOrderByPriorityAsc(Long userId);

    Optional<WishlistItem> findByUserIdAndCourseId(Long userId, Long courseId);

    boolean existsByUserIdAndCourseId(Long userId, Long courseId);

    void deleteByUserIdAndCourseId(Long userId, Long courseId);

    Optional<WishlistItem> findByIdAndUserId(Long id, Long userId);
}