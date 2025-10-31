package com.uniplan.planner.domain.wishlist.service;

import com.uniplan.planner.domain.wishlist.dto.AddToWishlistRequest;
import com.uniplan.planner.domain.wishlist.dto.WishlistItemResponse;
import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import com.uniplan.planner.domain.wishlist.repository.WishlistItemRepository;
import com.uniplan.planner.global.exception.DuplicateWishlistItemException;
import com.uniplan.planner.global.exception.WishlistItemNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class WishlistService {

    private final WishlistItemRepository wishlistItemRepository;

    @Transactional
    public WishlistItemResponse addToWishlist(Long userId, AddToWishlistRequest request) {
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
        return items.stream()
                .map(WishlistItemResponse::from)
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
}
