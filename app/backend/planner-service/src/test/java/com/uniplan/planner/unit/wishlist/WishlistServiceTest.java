package com.uniplan.planner.unit.wishlist;

import com.uniplan.planner.domain.wishlist.dto.AddToWishlistRequest;
import com.uniplan.planner.domain.wishlist.dto.WishlistItemResponse;
import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import com.uniplan.planner.domain.wishlist.repository.WishlistItemRepository;
import com.uniplan.planner.domain.wishlist.service.WishlistService;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.exception.CourseNotFoundException;
import com.uniplan.planner.global.exception.DuplicateWishlistItemException;
import com.uniplan.planner.global.exception.WishlistItemNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("WishlistService 단위 테스트")
class WishlistServiceTest {

    @Mock
    private WishlistItemRepository wishlistItemRepository;

    @Mock
    private CatalogClient catalogClient;

    @InjectMocks
    private WishlistService wishlistService;

    private static final Long USER_ID = 1L;
    private static final Long COURSE_ID = 101L;
    private static final Long WISHLIST_ITEM_ID = 1L;

    private CourseFullResponse mockCourse;
    private WishlistItem mockWishlistItem;
    private AddToWishlistRequest addRequest;

    @BeforeEach
    void setUp() {
        mockCourse = CourseFullResponse.builder()
                .id(COURSE_ID)
                .courseCode("CS101")
                .courseName("자료구조")
                .professor("김교수")
                .credits(3)
                .build();

        mockWishlistItem = WishlistItem.builder()
                .id(WISHLIST_ITEM_ID)
                .userId(USER_ID)
                .courseId(COURSE_ID)
                .priority(1)
                .build();

        addRequest = AddToWishlistRequest.builder()
                .courseId(COURSE_ID)
                .priority(1)
                .build();
    }

    @Nested
    @DisplayName("addToWishlist")
    class AddToWishlist {

        @Test
        @DisplayName("성공 - 정상적으로 위시리스트에 추가")
        void success() {
            // given
            given(catalogClient.getFullCourseById(COURSE_ID)).willReturn(mockCourse);
            given(wishlistItemRepository.existsByUserIdAndCourseId(USER_ID, COURSE_ID)).willReturn(false);
            given(wishlistItemRepository.save(any(WishlistItem.class))).willReturn(mockWishlistItem);

            // when
            WishlistItemResponse response = wishlistService.addToWishlist(USER_ID, addRequest);

            // then
            assertThat(response).isNotNull();
            assertThat(response.getCourseId()).isEqualTo(COURSE_ID);
            assertThat(response.getPriority()).isEqualTo(1);

            then(catalogClient).should().getFullCourseById(COURSE_ID);
            then(wishlistItemRepository).should().existsByUserIdAndCourseId(USER_ID, COURSE_ID);
            then(wishlistItemRepository).should().save(any(WishlistItem.class));
        }

        @Test
        @DisplayName("실패 - 존재하지 않는 과목")
        void fail_courseNotFound() {
            // given
            given(catalogClient.getFullCourseById(COURSE_ID)).willReturn(null);

            // when & then
            assertThatThrownBy(() -> wishlistService.addToWishlist(USER_ID, addRequest))
                    .isInstanceOf(CourseNotFoundException.class);

            then(wishlistItemRepository).should(never()).existsByUserIdAndCourseId(anyLong(), anyLong());
            then(wishlistItemRepository).should(never()).save(any(WishlistItem.class));
        }

        @Test
        @DisplayName("실패 - 중복 과목 추가")
        void fail_duplicateCourse() {
            // given
            given(catalogClient.getFullCourseById(COURSE_ID)).willReturn(mockCourse);
            given(wishlistItemRepository.existsByUserIdAndCourseId(USER_ID, COURSE_ID)).willReturn(true);

            // when & then
            assertThatThrownBy(() -> wishlistService.addToWishlist(USER_ID, addRequest))
                    .isInstanceOf(DuplicateWishlistItemException.class);

            then(wishlistItemRepository).should(never()).save(any(WishlistItem.class));
        }
    }

    @Nested
    @DisplayName("getMyWishlist")
    class GetMyWishlist {

        @Test
        @DisplayName("성공 - 위시리스트 조회")
        void success() {
            // given
            List<WishlistItem> items = List.of(mockWishlistItem);
            given(wishlistItemRepository.findByUserIdOrderByPriorityAsc(USER_ID)).willReturn(items);
            given(catalogClient.getFullCoursesByIds(List.of(COURSE_ID)))
                    .willReturn(Map.of(COURSE_ID, mockCourse));

            // when
            List<WishlistItemResponse> result = wishlistService.getMyWishlist(USER_ID);

            // then
            assertThat(result).hasSize(1);
            assertThat(result.get(0).getCourseId()).isEqualTo(COURSE_ID);
        }

        @Test
        @DisplayName("성공 - 빈 위시리스트")
        void success_emptyList() {
            // given
            given(wishlistItemRepository.findByUserIdOrderByPriorityAsc(USER_ID)).willReturn(List.of());

            // when
            List<WishlistItemResponse> result = wishlistService.getMyWishlist(USER_ID);

            // then
            assertThat(result).isEmpty();
            then(catalogClient).should(never()).getFullCoursesByIds(anyList());
        }
    }

    @Nested
    @DisplayName("removeFromWishlist")
    class RemoveFromWishlist {

        @Test
        @DisplayName("성공 - 위시리스트 아이템 삭제")
        void success() {
            // given
            given(wishlistItemRepository.findByIdAndUserId(WISHLIST_ITEM_ID, USER_ID))
                    .willReturn(Optional.of(mockWishlistItem));

            // when
            wishlistService.removeFromWishlist(USER_ID, WISHLIST_ITEM_ID);

            // then
            then(wishlistItemRepository).should().delete(mockWishlistItem);
        }

        @Test
        @DisplayName("실패 - 존재하지 않는 아이템")
        void fail_notFound() {
            // given
            given(wishlistItemRepository.findByIdAndUserId(WISHLIST_ITEM_ID, USER_ID))
                    .willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> wishlistService.removeFromWishlist(USER_ID, WISHLIST_ITEM_ID))
                    .isInstanceOf(WishlistItemNotFoundException.class);

            then(wishlistItemRepository).should(never()).delete(any(WishlistItem.class));
        }
    }

    @Nested
    @DisplayName("updatePriority")
    class UpdatePriority {

        @Test
        @DisplayName("성공 - 우선순위 변경")
        void success() {
            // given
            given(wishlistItemRepository.findByIdAndUserId(WISHLIST_ITEM_ID, USER_ID))
                    .willReturn(Optional.of(mockWishlistItem));

            // when
            WishlistItemResponse response = wishlistService.updatePriority(USER_ID, WISHLIST_ITEM_ID, 3);

            // then
            assertThat(response).isNotNull();
            assertThat(mockWishlistItem.getPriority()).isEqualTo(3);
        }

        @Test
        @DisplayName("실패 - 존재하지 않는 아이템")
        void fail_notFound() {
            // given
            given(wishlistItemRepository.findByIdAndUserId(WISHLIST_ITEM_ID, USER_ID))
                    .willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> wishlistService.updatePriority(USER_ID, WISHLIST_ITEM_ID, 3))
                    .isInstanceOf(WishlistItemNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("isInWishlist")
    class IsInWishlist {

        @Test
        @DisplayName("true - 위시리스트에 있음")
        void returnTrue() {
            // given
            given(wishlistItemRepository.existsByUserIdAndCourseId(USER_ID, COURSE_ID)).willReturn(true);

            // when
            boolean result = wishlistService.isInWishlist(USER_ID, COURSE_ID);

            // then
            assertThat(result).isTrue();
        }

        @Test
        @DisplayName("false - 위시리스트에 없음")
        void returnFalse() {
            // given
            given(wishlistItemRepository.existsByUserIdAndCourseId(USER_ID, COURSE_ID)).willReturn(false);

            // when
            boolean result = wishlistService.isInWishlist(USER_ID, COURSE_ID);

            // then
            assertThat(result).isFalse();
        }
    }
}
