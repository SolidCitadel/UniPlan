package com.uniplan.planner.component.wishlist;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.planner.config.DockerRequiredExtension;
import com.uniplan.planner.domain.wishlist.dto.AddToWishlistRequest;
import com.uniplan.planner.domain.wishlist.dto.UpdateWishlistRequest;
import com.uniplan.planner.domain.wishlist.entity.WishlistItem;
import com.uniplan.planner.domain.wishlist.repository.WishlistItemRepository;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(DockerRequiredExtension.class)
@SpringBootTest
@AutoConfigureMockMvc
class WishlistControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private WishlistItemRepository wishlistItemRepository;

    @Autowired
    private CatalogClient catalogClient;

    private static final Long TEST_USER_ID = 1L;
    private static final Long OTHER_USER_ID = 2L;

    @BeforeEach
    void setUp() {
        wishlistItemRepository.deleteAll();

        // Mock CatalogClient to return course info
        when(catalogClient.getFullCoursesByIds(anyList())).thenAnswer(invocation -> {
            List<Long> courseIds = invocation.getArgument(0);
            return courseIds.stream()
                    .collect(Collectors.toMap(
                            Function.identity(),
                            this::createMockCourse));
        });

        when(catalogClient.getFullCourseById(anyLong())).thenAnswer(invocation -> {
            Long courseId = invocation.getArgument(0);
            return createMockCourse(courseId);
        });
    }

    private CourseFullResponse createMockCourse(Long id) {
        return CourseFullResponse.builder()
                .id(id)
                .courseCode("CS" + id)
                .courseName("Course " + id)
                .professor("Professor " + id)
                .credits(3)
                .classroom("Room " + id)
                .campus("Main")
                .classTimes(List.of())
                .build();
    }

    @Test
    @DisplayName("희망과목 추가")
    void addToWishlist() throws Exception {
        AddToWishlistRequest request = AddToWishlistRequest.builder()
                .courseId(101L)
                .priority(1)
                .build();

        mockMvc.perform(post("/wishlist")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").exists())
                .andExpect(jsonPath("$.userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$.courseId").value(101L))
                .andExpect(jsonPath("$.priority").value(1));
    }

    @Test
    @DisplayName("희망과목 중복 추가 실패")
    void addToWishlist_duplicate() throws Exception {
        // Given: 이미 추가된 희망과목
        createTestWishlistItem(TEST_USER_ID, 101L, 1);

        AddToWishlistRequest request = AddToWishlistRequest.builder()
                .courseId(101L)
                .priority(2)
                .build();

        // When & Then: 중복 추가 -> 409 Conflict
        mockMvc.perform(post("/wishlist")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isConflict());
    }

    @Test
    @DisplayName("내 희망과목 목록 조회")
    void getMyWishlist() throws Exception {
        // Given
        createTestWishlistItem(TEST_USER_ID, 101L, 1);
        createTestWishlistItem(TEST_USER_ID, 102L, 2);
        createTestWishlistItem(OTHER_USER_ID, 103L, 1); // 다른 사용자

        // When & Then
        mockMvc.perform(get("/wishlist")
                .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].userId").value(TEST_USER_ID))
                .andExpect(jsonPath("$[1].userId").value(TEST_USER_ID));
    }

    @Test
    @DisplayName("희망과목 우선순위 수정 - wishlist item id 사용")
    void updatePriority() throws Exception {
        // Given
        WishlistItem item = createTestWishlistItem(TEST_USER_ID, 101L, 1);

        UpdateWishlistRequest request = UpdateWishlistRequest.builder()
                .priority(3)
                .build();

        // When & Then: wishlist item id로 수정
        mockMvc.perform(patch("/wishlist/" + item.getId())
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(item.getId()))
                .andExpect(jsonPath("$.priority").value(3));
    }

    @Test
    @DisplayName("희망과목 우선순위 수정 - 존재하지 않는 아이템")
    void updatePriority_notFound() throws Exception {
        UpdateWishlistRequest request = UpdateWishlistRequest.builder()
                .priority(3)
                .build();

        mockMvc.perform(patch("/wishlist/99999")
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("희망과목 우선순위 수정 - 다른 사용자의 아이템")
    void updatePriority_otherUser() throws Exception {
        // Given: 다른 사용자의 희망과목
        WishlistItem otherItem = createTestWishlistItem(OTHER_USER_ID, 101L, 1);

        UpdateWishlistRequest request = UpdateWishlistRequest.builder()
                .priority(3)
                .build();

        // When & Then: 내 계정으로 수정 시도 -> 404
        mockMvc.perform(patch("/wishlist/" + otherItem.getId())
                .header("X-User-Id", TEST_USER_ID)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andDo(print())
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("희망과목 삭제 - wishlist item id 사용")
    void removeFromWishlist() throws Exception {
        // Given
        WishlistItem item = createTestWishlistItem(TEST_USER_ID, 101L, 1);

        // When & Then: wishlist item id로 삭제
        mockMvc.perform(delete("/wishlist/" + item.getId())
                .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNoContent());
    }

    @Test
    @DisplayName("희망과목 삭제 - 존재하지 않는 아이템")
    void removeFromWishlist_notFound() throws Exception {
        mockMvc.perform(delete("/wishlist/99999")
                .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("희망과목 삭제 - 다른 사용자의 아이템")
    void removeFromWishlist_otherUser() throws Exception {
        // Given: 다른 사용자의 희망과목
        WishlistItem otherItem = createTestWishlistItem(OTHER_USER_ID, 101L, 1);

        // When & Then: 내 계정으로 삭제 시도 -> 404
        mockMvc.perform(delete("/wishlist/" + otherItem.getId())
                .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("희망과목 포함 여부 확인")
    void isInWishlist() throws Exception {
        // Given
        createTestWishlistItem(TEST_USER_ID, 101L, 1);

        // When & Then
        mockMvc.perform(get("/wishlist/check/101")
                .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("true"));

        mockMvc.perform(get("/wishlist/check/999")
                .header("X-User-Id", TEST_USER_ID))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("false"));
    }

    // Helper method
    private WishlistItem createTestWishlistItem(Long userId, Long courseId, Integer priority) {
        WishlistItem item = WishlistItem.builder()
                .userId(userId)
                .courseId(courseId)
                .priority(priority)
                .build();
        return wishlistItemRepository.save(item);
    }

    @TestConfiguration
    static class MockitoConfig {
        @Bean
        CatalogClient catalogClient() {
            return Mockito.mock(CatalogClient.class);
        }
    }
}
