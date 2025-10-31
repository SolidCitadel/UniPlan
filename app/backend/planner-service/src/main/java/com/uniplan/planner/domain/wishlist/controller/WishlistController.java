package com.uniplan.planner.domain.wishlist.controller;

import com.uniplan.planner.domain.wishlist.dto.AddToWishlistRequest;
import com.uniplan.planner.domain.wishlist.dto.WishlistItemResponse;
import com.uniplan.planner.domain.wishlist.service.WishlistService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "Wishlist", description = "희망과목 관리 API")
@RestController
@RequestMapping("/wishlist")
@RequiredArgsConstructor
public class WishlistController {

    private final WishlistService wishlistService;

    @Operation(summary = "희망과목 추가", description = "강의를 희망과목에 추가합니다")
    @PostMapping
    public ResponseEntity<WishlistItemResponse> addToWishlist(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @Valid @RequestBody AddToWishlistRequest request) {
        WishlistItemResponse response = wishlistService.addToWishlist(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @Operation(summary = "내 희망과목 조회", description = "현재 사용자의 모든 희망과목을 조회합니다")
    @GetMapping
    public ResponseEntity<List<WishlistItemResponse>> getMyWishlist(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId) {
        List<WishlistItemResponse> responses = wishlistService.getMyWishlist(userId);
        return ResponseEntity.ok(responses);
    }

    @Operation(summary = "희망과목 삭제", description = "강의를 희망과목에서 삭제합니다")
    @DeleteMapping("/{courseId}")
    public ResponseEntity<Void> removeFromWishlist(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long courseId) {
        wishlistService.removeFromWishlist(userId, courseId);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "희망과목 포함 여부 확인", description = "특정 강의가 희망과목에 포함되어 있는지 확인합니다")
    @GetMapping("/check/{courseId}")
    public ResponseEntity<Boolean> isInWishlist(
            @Parameter(hidden = true) @RequestHeader("X-User-Id") Long userId,
            @PathVariable Long courseId) {
        boolean exists = wishlistService.isInWishlist(userId, courseId);
        return ResponseEntity.ok(exists);
    }
}