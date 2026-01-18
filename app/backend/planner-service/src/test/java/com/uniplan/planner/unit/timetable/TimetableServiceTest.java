package com.uniplan.planner.unit.timetable;

import com.uniplan.planner.domain.timetable.dto.AddCourseRequest;
import com.uniplan.planner.domain.timetable.dto.TimetableItemResponse;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.entity.TimetableItem;
import com.uniplan.planner.domain.timetable.repository.TimetableItemRepository;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.domain.timetable.service.TimetableService;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.client.dto.CourseFullResponse;
import com.uniplan.planner.global.exception.CourseNotFoundException;
import com.uniplan.planner.global.exception.DuplicateCourseException;
import com.uniplan.planner.global.exception.ExcludedCourseException;
import com.uniplan.planner.global.exception.TimetableNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.BDDMockito.*;

/**
 * TimetableService 단위 테스트
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("TimetableService 단위 테스트")
class TimetableServiceTest {

    @Mock private TimetableRepository timetableRepository;
    @Mock private TimetableItemRepository timetableItemRepository;
    @Mock private CatalogClient catalogClient;

    @InjectMocks
    private TimetableService timetableService;

    private static final Long USER_ID = 1L;
    private static final Long TIMETABLE_ID = 1L;
    private static final Long COURSE_ID = 101L;

    private Timetable mockTimetable;
    private CourseFullResponse mockCourse;

    @BeforeEach
    void setUp() {
        mockTimetable = Timetable.builder()
            .id(TIMETABLE_ID)
            .userId(USER_ID)
            .name("Test Timetable")
            .openingYear(2026)
            .semester("1학기")
            .excludedCourseIds(new HashSet<>())
            .build();

        mockCourse = new CourseFullResponse();
        mockCourse.setId(COURSE_ID);
        mockCourse.setCourseName("자료구조");
        mockCourse.setProfessor("김교수");
        mockCourse.setCredits(3);
    }

    @Nested
    @DisplayName("addCourse")
    class AddCourse {

        @Test
        @DisplayName("정상 추가 - 성공")
        void success() {
            // given
            AddCourseRequest request = new AddCourseRequest();
            request.setCourseId(COURSE_ID);

            TimetableItem savedItem = TimetableItem.builder()
                .id(1L)
                .timetable(mockTimetable)
                .courseId(COURSE_ID)
                .build();

            given(timetableRepository.findByIdAndUserId(TIMETABLE_ID, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(catalogClient.getFullCourseById(COURSE_ID)).willReturn(mockCourse);
            given(timetableItemRepository.existsByTimetableIdAndCourseId(TIMETABLE_ID, COURSE_ID)).willReturn(false);
            given(timetableItemRepository.save(any())).willReturn(savedItem);

            // when
            TimetableItemResponse response = timetableService.addCourse(USER_ID, TIMETABLE_ID, request);

            // then
            assertThat(response.getCourseId()).isEqualTo(COURSE_ID);
            assertThat(response.getCourseName()).isEqualTo("자료구조");
            verify(timetableItemRepository).save(any());
        }

        @Test
        @DisplayName("존재하지 않는 강의 - 예외 발생")
        void courseNotFound_throwsException() {
            // given
            AddCourseRequest request = new AddCourseRequest();
            request.setCourseId(999L);

            given(timetableRepository.findByIdAndUserId(TIMETABLE_ID, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(catalogClient.getFullCourseById(999L)).willReturn(null);

            // when & then
            assertThatThrownBy(() -> timetableService.addCourse(USER_ID, TIMETABLE_ID, request))
                .isInstanceOf(CourseNotFoundException.class);
        }

        @Test
        @DisplayName("제외된 과목 추가 시도 - 예외 발생")
        void excludedCourse_throwsException() {
            // given
            AddCourseRequest request = new AddCourseRequest();
            request.setCourseId(COURSE_ID);

            // 제외 과목에 추가
            mockTimetable.getExcludedCourseIds().add(COURSE_ID);

            given(timetableRepository.findByIdAndUserId(TIMETABLE_ID, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(catalogClient.getFullCourseById(COURSE_ID)).willReturn(mockCourse);

            // when & then
            assertThatThrownBy(() -> timetableService.addCourse(USER_ID, TIMETABLE_ID, request))
                .isInstanceOf(ExcludedCourseException.class);
        }

        @Test
        @DisplayName("중복 과목 추가 시도 - 예외 발생")
        void duplicateCourse_throwsException() {
            // given
            AddCourseRequest request = new AddCourseRequest();
            request.setCourseId(COURSE_ID);

            given(timetableRepository.findByIdAndUserId(TIMETABLE_ID, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(catalogClient.getFullCourseById(COURSE_ID)).willReturn(mockCourse);
            given(timetableItemRepository.existsByTimetableIdAndCourseId(TIMETABLE_ID, COURSE_ID)).willReturn(true);

            // when & then
            assertThatThrownBy(() -> timetableService.addCourse(USER_ID, TIMETABLE_ID, request))
                .isInstanceOf(DuplicateCourseException.class);
        }

        @Test
        @DisplayName("시간표 없음 - 예외 발생")
        void timetableNotFound_throwsException() {
            // given
            AddCourseRequest request = new AddCourseRequest();
            request.setCourseId(COURSE_ID);

            given(timetableRepository.findByIdAndUserId(999L, USER_ID)).willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> timetableService.addCourse(USER_ID, 999L, request))
                .isInstanceOf(TimetableNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("removeCourse")
    class RemoveCourse {

        @Test
        @DisplayName("정상 삭제 - 성공")
        void success() {
            // given
            TimetableItem item = TimetableItem.builder()
                .id(1L)
                .timetable(mockTimetable)
                .courseId(COURSE_ID)
                .build();

            given(timetableRepository.findByIdAndUserId(TIMETABLE_ID, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(timetableItemRepository.findByTimetableIdAndCourseId(TIMETABLE_ID, COURSE_ID)).willReturn(Optional.of(item));

            // when
            timetableService.removeCourse(USER_ID, TIMETABLE_ID, COURSE_ID);

            // then
            verify(timetableItemRepository).delete(item);
        }

        @Test
        @DisplayName("과목 없음 - 예외 발생")
        void courseNotInTimetable_throwsException() {
            // given
            given(timetableRepository.findByIdAndUserId(TIMETABLE_ID, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(timetableItemRepository.findByTimetableIdAndCourseId(TIMETABLE_ID, 999L)).willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> timetableService.removeCourse(USER_ID, TIMETABLE_ID, 999L))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("강의를 찾을 수 없습니다");
        }
    }
}
