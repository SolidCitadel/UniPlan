package com.uniplan.planner.contract;

import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.client.dto.CourseSimpleResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.cloud.contract.wiremock.AutoConfigureWireMock;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.context.TestPropertySource;

import java.util.List;
import java.util.Map;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Contract Test for CatalogClient
 *
 * Verifies that Planner-Service correctly calls Catalog-Service APIs
 * and properly handles responses. Redis is mocked to isolate Feign behavior.
 */
@SpringBootTest
@AutoConfigureWireMock(port = 0)
@TestPropertySource(properties = {
        "services.catalog.url=http://localhost:${wiremock.server.port}",
        "spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,org.springframework.boot.autoconfigure.data.redis.RedisReactiveAutoConfiguration"
})
@DisplayName("CatalogClient 계약 테스트")
class CatalogClientContractTest {

    @Autowired
    private CatalogClient catalogClient;

    @MockBean
    private RedisConnectionFactory redisConnectionFactory;

    @SuppressWarnings("unchecked")
    @MockBean
    private RedisTemplate<String, Object> redisTemplate;

    @SuppressWarnings("unchecked")
    @BeforeEach
    void setUp() {
        ValueOperations<String, Object> valueOps = mock(ValueOperations.class);
        when(redisTemplate.opsForValue()).thenReturn(valueOps);
        when(valueOps.get(anyString())).thenReturn(null); // always cache miss
        when(valueOps.multiGet(any())).thenReturn(null); // always cache miss for batch
    }

    @Test
    @DisplayName("getFullCourseById - 성공 응답")
    void getFullCourseById_success() {
        // given
        Long courseId = 101L;
        stubFor(get(urlEqualTo("/courses/" + courseId))
                .willReturn(okJson("""
                        {
                            "id": 101,
                            "courseCode": "CS101",
                            "courseName": "자료구조",
                            "professor": "김교수",
                            "credits": 3,
                            "classroom": "공학관 301",
                            "campus": "서울",
                            "classTimes": [
                                {"day": "MON", "startTime": "09:00", "endTime": "10:30"}
                            ]
                        }
                        """)));

        // when
        CourseFullResponse course = catalogClient.getFullCourseById(courseId);

        // then
        assertThat(course).isNotNull();
        assertThat(course.getId()).isEqualTo(101L);
        assertThat(course.getCourseCode()).isEqualTo("CS101");
        assertThat(course.getCourseName()).isEqualTo("자료구조");
        assertThat(course.getProfessor()).isEqualTo("김교수");
        assertThat(course.getCredits()).isEqualTo(3);

        verify(getRequestedFor(urlEqualTo("/courses/" + courseId)));
    }

    @Test
    @DisplayName("getFullCourseById - 404 응답 시 null 반환")
    void getFullCourseById_notFound() {
        // given
        Long courseId = 999L;
        stubFor(get(urlEqualTo("/courses/" + courseId))
                .willReturn(notFound()));

        // when
        CourseFullResponse course = catalogClient.getFullCourseById(courseId);

        // then
        assertThat(course).isNull();
    }

    @Test
    @DisplayName("getCourseById - 단순 응답")
    void getCourseById_success() {
        // given
        Long courseId = 101L;
        stubFor(get(urlEqualTo("/courses/" + courseId))
                .willReturn(okJson("""
                        {
                            "id": 101,
                            "courseName": "자료구조",
                            "professor": "김교수"
                        }
                        """)));

        // when
        CourseSimpleResponse course = catalogClient.getCourseById(courseId);

        // then
        assertThat(course).isNotNull();
        assertThat(course.getId()).isEqualTo(101L);
        assertThat(course.getCourseName()).isEqualTo("자료구조");
    }

    @Test
    @DisplayName("getFullCoursesByIds - 여러 과목 조회 (Batch)")
    void getFullCoursesByIds_success() {
        // given
        stubFor(get(urlPathEqualTo("/internal/courses"))
                .withQueryParam("ids", containing("101"))
                .withQueryParam("ids", containing("102"))
                .willReturn(okJson("""
                        [
                            {"id": 101, "courseName": "자료구조", "professor": "김교수", "credits": 3},
                            {"id": 102, "courseName": "알고리즘", "professor": "이교수", "credits": 3}
                        ]
                        """)));

        // when
        Map<Long, CourseFullResponse> courses = catalogClient.getFullCoursesByIds(List.of(101L, 102L));

        // then
        assertThat(courses).hasSize(2);
        assertThat(courses.get(101L).getCourseName()).isEqualTo("자료구조");
        assertThat(courses.get(102L).getCourseName()).isEqualTo("알고리즘");

        verify(getRequestedFor(urlPathEqualTo("/internal/courses"))
                .withQueryParam("ids", containing("101"))
                .withQueryParam("ids", containing("102")));
    }

    @Test
    @DisplayName("서버 오류 시 null 반환")
    void serverError_returnsNull() {
        // given
        Long courseId = 101L;
        stubFor(get(urlEqualTo("/courses/" + courseId))
                .willReturn(serverError()));

        // when
        CourseFullResponse course = catalogClient.getFullCourseById(courseId);

        // then
        assertThat(course).isNull();
    }
}
