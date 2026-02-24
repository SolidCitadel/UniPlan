package com.uniplan.planner.unit.client;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.CatalogFeignClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.RedisConnectionFailureException;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;

import java.time.Duration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CatalogClient 캐시 테스트")
class CatalogClientCacheTest {

    @Mock
    private CatalogFeignClient feignClient;

    @Mock
    private RedisTemplate<String, Object> redisTemplate;

    @Mock
    private ValueOperations<String, Object> valueOps;

    private final ObjectMapper objectMapper = new ObjectMapper();

    private CatalogClient catalogClient;

    private static final CourseFullResponse COURSE_101 = CourseFullResponse.builder()
            .id(101L)
            .courseCode("CS101")
            .courseName("자료구조")
            .professor("김교수")
            .credits(3)
            .build();

    private static final CourseFullResponse COURSE_102 = CourseFullResponse.builder()
            .id(102L)
            .courseCode("CS102")
            .courseName("알고리즘")
            .professor("이교수")
            .credits(3)
            .build();

    @BeforeEach
    void setUp() {
        catalogClient = new CatalogClient(feignClient, redisTemplate, objectMapper);
        lenient().when(redisTemplate.opsForValue()).thenReturn(valueOps);
    }

    @Test
    @DisplayName("캐시 히트 시 Feign 호출하지 않음")
    void cacheHit_skipsFeignCall() {
        // given
        when(valueOps.get("course:101")).thenReturn(COURSE_101);

        // when
        CourseFullResponse result = catalogClient.getFullCourseById(101L);

        // then
        assertThat(result).isEqualTo(COURSE_101);
        verifyNoInteractions(feignClient);
    }

    @Test
    @DisplayName("캐시 미스 시 Feign 호출 후 캐시 저장")
    void cacheMiss_fetchesAndCaches() {
        // given
        when(valueOps.get("course:101")).thenReturn(null);
        when(feignClient.getCourseById(101L)).thenReturn(COURSE_101);

        // when
        CourseFullResponse result = catalogClient.getFullCourseById(101L);

        // then
        assertThat(result).isEqualTo(COURSE_101);
        verify(feignClient).getCourseById(101L);
        verify(valueOps).set(eq("course:101"), eq(COURSE_101), any(Duration.class));
    }

    @Test
    @DisplayName("Redis 장애 시 Feign 폴백")
    void redisFailure_fallsBackToFeign() {
        // given
        when(valueOps.get("course:101")).thenThrow(new RedisConnectionFailureException("Connection refused"));
        when(feignClient.getCourseById(101L)).thenReturn(COURSE_101);

        // when
        CourseFullResponse result = catalogClient.getFullCourseById(101L);

        // then
        assertThat(result).isEqualTo(COURSE_101);
        verify(feignClient).getCourseById(101L);
    }

    @Test
    @DisplayName("캐시에서 LinkedHashMap 반환 시 ObjectMapper로 변환")
    void cacheReturnsLinkedHashMap_convertsWithObjectMapper() {
        // given: simulate GenericJackson2JsonRedisSerializer returning a Map
        Map<String, Object> mapData = new HashMap<>();
        mapData.put("id", 101);
        mapData.put("courseCode", "CS101");
        mapData.put("courseName", "자료구조");
        mapData.put("professor", "김교수");
        mapData.put("credits", 3);
        when(valueOps.get("course:101")).thenReturn(mapData);

        // when
        CourseFullResponse result = catalogClient.getFullCourseById(101L);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(101L);
        assertThat(result.getCourseName()).isEqualTo("자료구조");
        verifyNoInteractions(feignClient);
    }

    @Test
    @DisplayName("getCourseById - Full 응답을 Simple로 변환")
    void getCourseById_convertsToSimple() {
        // given
        when(valueOps.get("course:101")).thenReturn(COURSE_101);

        // when
        CourseSimpleResponse result = catalogClient.getCourseById(101L);

        // then
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(101L);
        assertThat(result.getCourseName()).isEqualTo("자료구조");
        assertThat(result.getProfessor()).isEqualTo("김교수");
    }

    @Test
    @DisplayName("배치 조회 - multiGet으로 부분 캐시 히트")
    void batchPartialHit_fetchesOnlyMisses() {
        // given: 101 is cached, 102 is not
        when(valueOps.multiGet(List.of("course:101", "course:102")))
                .thenReturn(List.of(COURSE_101, /* null placeholder */ new Object() {
                    // multiGet returns null for misses, but we can't put null in List.of
                }));
        // Use a mutable list to include null
        java.util.ArrayList<Object> multiGetResult = new java.util.ArrayList<>();
        multiGetResult.add(COURSE_101);
        multiGetResult.add(null);
        when(valueOps.multiGet(List.of("course:101", "course:102")))
                .thenReturn(multiGetResult);
        when(feignClient.getCoursesByIds(List.of(102L))).thenReturn(List.of(COURSE_102));

        // when
        Map<Long, CourseFullResponse> result = catalogClient.getFullCoursesByIds(List.of(101L, 102L));

        // then
        assertThat(result).hasSize(2);
        assertThat(result.get(101L)).isEqualTo(COURSE_101);
        assertThat(result.get(102L)).isEqualTo(COURSE_102);
        verify(feignClient).getCoursesByIds(List.of(102L));
        verify(valueOps).set(eq("course:102"), eq(COURSE_102), any(Duration.class));
    }

    @Test
    @DisplayName("배치 조회 - 전체 캐시 히트 시 Feign 호출 없음")
    void batchFullHit_noFeignCall() {
        // given
        java.util.ArrayList<Object> multiGetResult = new java.util.ArrayList<>();
        multiGetResult.add(COURSE_101);
        multiGetResult.add(COURSE_102);
        when(valueOps.multiGet(List.of("course:101", "course:102")))
                .thenReturn(multiGetResult);

        // when
        Map<Long, CourseFullResponse> result = catalogClient.getFullCoursesByIds(List.of(101L, 102L));

        // then
        assertThat(result).hasSize(2);
        verifyNoInteractions(feignClient);
    }

    @Test
    @DisplayName("배치 조회 - Redis 장애 시 전체 Feign 폴백")
    void batchRedisFailure_fetchesAll() {
        // given
        when(valueOps.multiGet(any())).thenThrow(new RedisConnectionFailureException("Connection refused"));
        when(feignClient.getCoursesByIds(List.of(101L, 102L))).thenReturn(List.of(COURSE_101, COURSE_102));

        // when
        Map<Long, CourseFullResponse> result = catalogClient.getFullCoursesByIds(List.of(101L, 102L));

        // then
        assertThat(result).hasSize(2);
        verify(feignClient).getCoursesByIds(List.of(101L, 102L));
    }

    @Test
    @DisplayName("빈 목록 조회 시 빈 결과 반환")
    void emptyIds_returnsEmptyMap() {
        // when
        Map<Long, CourseFullResponse> result = catalogClient.getFullCoursesByIds(List.of());

        // then
        assertThat(result).isEmpty();
        verifyNoInteractions(feignClient);
    }
}
