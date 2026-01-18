package com.uniplan.planner.unit.scenario;

import com.uniplan.planner.domain.registration.repository.RegistrationRepository;
import com.uniplan.planner.domain.scenario.dto.*;
import com.uniplan.planner.domain.scenario.entity.Scenario;
import com.uniplan.planner.domain.scenario.repository.ScenarioRepository;
import com.uniplan.planner.domain.scenario.service.ScenarioService;
import com.uniplan.planner.domain.timetable.dto.CreateTimetableRequest;
import com.uniplan.planner.domain.timetable.entity.Timetable;
import com.uniplan.planner.domain.timetable.repository.TimetableRepository;
import com.uniplan.planner.global.client.CatalogClient;
import com.uniplan.planner.global.exception.AlternativeScenarioNotFoundException;
import com.uniplan.planner.global.exception.ScenarioNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.*;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.BDDMockito.*;

/**
 * ScenarioService 단위 테스트
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("ScenarioService 단위 테스트")
class ScenarioServiceTest {

    @Mock private ScenarioRepository scenarioRepository;
    @Mock private TimetableRepository timetableRepository;
    @Mock private RegistrationRepository registrationRepository;
    @Mock private CatalogClient catalogClient;

    @InjectMocks
    private ScenarioService scenarioService;

    private static final Long USER_ID = 1L;
    private Timetable mockTimetable;
    private Scenario mockScenario;

    @BeforeEach
    void setUp() {
        mockTimetable = Timetable.builder()
            .id(1L)
            .userId(USER_ID)
            .name("Test Timetable")
            .openingYear(2026)
            .semester("1학기")
            .build();

        mockScenario = Scenario.builder()
            .id(10L)
            .userId(USER_ID)
            .name("Plan A")
            .timetable(mockTimetable)
            .failedCourseIds(new HashSet<>())
            .build();
    }

    @Nested
    @DisplayName("createRootScenario")
    class CreateRootScenario {

        @Test
        @DisplayName("기존 시간표로 생성 - 성공")
        void withExistingTimetable_success() {
            // given
            CreateScenarioRequest request = new CreateScenarioRequest();
            request.setName("Plan A");
            request.setExistingTimetableId(1L);

            given(timetableRepository.findByIdAndUserId(1L, USER_ID)).willReturn(Optional.of(mockTimetable));
            given(scenarioRepository.save(any())).willReturn(mockScenario);
            given(catalogClient.getFullCoursesByIds(any())).willReturn(new HashMap<>());

            // when
            ScenarioResponse response = scenarioService.createRootScenario(USER_ID, request);

            // then
            assertThat(response).isNotNull();
            verify(scenarioRepository).save(any());
        }

        @Test
        @DisplayName("시간표 정보 없음 - 예외 발생")
        void noTimetableInfo_throwsException() {
            // given
            CreateScenarioRequest request = new CreateScenarioRequest();
            request.setName("Plan A");
            // existingTimetableId와 timetableRequest 둘 다 null

            // when & then
            assertThatThrownBy(() -> scenarioService.createRootScenario(USER_ID, request))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("existingTimetableId 또는 timetableRequest 중 하나는 필수입니다");
        }
    }

    @Nested
    @DisplayName("createAlternativeScenario")
    class CreateAlternativeScenario {

        @Test
        @DisplayName("부모 시나리오 없음 - 예외 발생")
        void parentNotFound_throwsException() {
            // given
            CreateAlternativeScenarioRequest request = new CreateAlternativeScenarioRequest();
            request.setName("Plan B");
            request.setExistingTimetableId(1L);

            given(scenarioRepository.findByIdAndUserId(999L, USER_ID)).willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> scenarioService.createAlternativeScenario(USER_ID, 999L, request))
                .isInstanceOf(ScenarioNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("navigate")
    class Navigate {

        @Test
        @DisplayName("대안 시나리오 찾기 - 성공")
        void findAlternative_success() {
            // given
            NavigationRequest request = new NavigationRequest();
            request.setFailedCourseIds(Set.of(101L));

            Scenario alternativeScenario = Scenario.builder()
                .id(11L)
                .userId(USER_ID)
                .name("Plan B")
                .timetable(mockTimetable)
                .failedCourseIds(Set.of(101L))
                .build();

            given(scenarioRepository.findByIdAndUserId(10L, USER_ID)).willReturn(Optional.of(mockScenario));
            given(scenarioRepository.findAlternativeScenario(eq(10L), any())).willReturn(Optional.of(alternativeScenario));
            given(catalogClient.getFullCoursesByIds(any())).willReturn(new HashMap<>());

            // when
            ScenarioResponse response = scenarioService.navigate(USER_ID, 10L, request);

            // then
            assertThat(response.getName()).isEqualTo("Plan B");
        }

        @Test
        @DisplayName("대안 시나리오 없음 - 예외 발생")
        void noAlternative_throwsException() {
            // given
            NavigationRequest request = new NavigationRequest();
            request.setFailedCourseIds(Set.of(101L, 102L));

            given(scenarioRepository.findByIdAndUserId(10L, USER_ID)).willReturn(Optional.of(mockScenario));
            given(scenarioRepository.findAlternativeScenario(eq(10L), any())).willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> scenarioService.navigate(USER_ID, 10L, request))
                .isInstanceOf(AlternativeScenarioNotFoundException.class);
        }
    }

    @Nested
    @DisplayName("deleteScenario")
    class DeleteScenario {

        @Test
        @DisplayName("정상 삭제 - 성공")
        void success() {
            // given
            given(scenarioRepository.findByIdAndUserId(10L, USER_ID)).willReturn(Optional.of(mockScenario));
            given(registrationRepository.countByStartScenarioId(10L)).willReturn(0L);
            given(registrationRepository.countByCurrentScenarioId(10L)).willReturn(0L);
            given(scenarioRepository.findByParentScenarioIdOrderByOrderIndexAsc(10L)).willReturn(List.of());

            // when
            scenarioService.deleteScenario(USER_ID, 10L);

            // then
            verify(scenarioRepository).delete(mockScenario);
        }

        @Test
        @DisplayName("진행 중인 Registration 있음 - 예외 발생")
        void hasActiveRegistration_throwsException() {
            // given
            given(scenarioRepository.findByIdAndUserId(10L, USER_ID)).willReturn(Optional.of(mockScenario));
            given(registrationRepository.countByStartScenarioId(10L)).willReturn(1L);
            given(registrationRepository.countByCurrentScenarioId(10L)).willReturn(0L);

            // when & then
            assertThatThrownBy(() -> scenarioService.deleteScenario(USER_ID, 10L))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("시나리오를 삭제할 수 없습니다");
        }

        @Test
        @DisplayName("시나리오 없음 - 예외 발생")
        void notFound_throwsException() {
            // given
            given(scenarioRepository.findByIdAndUserId(999L, USER_ID)).willReturn(Optional.empty());

            // when & then
            assertThatThrownBy(() -> scenarioService.deleteScenario(USER_ID, 999L))
                .isInstanceOf(ScenarioNotFoundException.class);
        }
    }
}
