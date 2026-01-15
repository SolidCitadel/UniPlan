package com.uniplan.planner.domain.wishlist.service;

import com.uniplan.planner.domain.wishlist.dto.AddToWishlistRequest;
import com.uniplan.planner.domain.wishlist.dto.WishlistItemResponse;
import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import com.uniplan.planner.domain.wishlist.repository.WishlistItemRepository;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.exception.CourseNotFoundException;
import com.uniplan.planner.global.exception.DuplicateWishlistItemException;
import com.uniplan.planner.global.exception.WishlistItemNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WishlistService {

    private final WishlistItemRepository wishlistItemRepository;
    private final CatalogClient catalogClient;

    @Transactional
    public WishlistItemResponse addToWishlist(Long userId, AddToWishlistRequest request) {
        // 강의 존재 확인
        CourseFullResponse course = catalogClient.getFullCourseById(request.getCourseId());
        if (course == null) {
            throw new CourseNotFoundException(request.getCourseId());
        }

        // 중복 체크
        if (wishlistItemRepository.existsByUserIdAndCourseId(userId, request.getCourseId())) {
            throw new DuplicateWishlistItemException(request.getCourseId());
        }

        // 희망과목 추가
        WishlistItem item = WishlistItem.builder()
                .userId(userId)
                .courseId(request.getCourseId())
                .priority(request.getPriority())
                .build();

        WishlistItem savedItem = wishlistItemRepository.save(item);
        return WishlistItemResponse.from(savedItem);
    }

    public List<WishlistItemResponse> getMyWishlist(Long userId) {
        List<WishlistItem> items = wishlistItemRepository.findByUserIdOrderByPriorityAsc(userId);

        if (items.isEmpty()) {
            return List.of();
        }

        // Extract course IDs and fetch full course details from catalog-service
        List<Long> courseIds = items.stream()
                .map(WishlistItem::getCourseId)
                .collect(Collectors.toList());

        Map<Long, CourseFullResponse> courseMap = catalogClient.getFullCoursesByIds(courseIds);

        // Combine wishlist items with course information
        return items.stream()
                .map(item -> {
                    CourseFullResponse course = courseMap.get(item.getCourseId());
                    return WishlistItemResponse.from(item, course);
                })
                .collect(Collectors.toList());
    }

    @Transactional
    public void removeFromWishlist(Long userId, Long courseId) {
        // 존재 여부 확인
        if (!wishlistItemRepository.existsByUserIdAndCourseId(userId, courseId)) {
            throw new WishlistItemNotFoundException(courseId);
        }

        wishlistItemRepository.deleteByUserIdAndCourseId(userId, courseId);
    }

    public boolean isInWishlist(Long userId, Long courseId) {
        return wishlistItemRepository.existsByUserIdAndCourseId(userId, courseId);
    }

    @Transactional
    public WishlistItemResponse updatePriority(Long userId, Long courseId, Integer priority) {
        WishlistItem item = wishlistItemRepository.findByUserIdAndCourseId(userId, courseId)
                .orElseThrow(() -> new WishlistItemNotFoundException(courseId));

        item.updatePriority(priority);
        return WishlistItemResponse.from(item);
    }
}
