package com.uniplan.user.component.university;

import com.uniplan.user.config.DockerRequiredExtension;
import com.uniplan.user.domain.university.entity.University;
import com.uniplan.user.domain.university.repository.UniversityRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
@ExtendWith(DockerRequiredExtension.class)
@DisplayName("UniversityController 컴포넌트 테스트")
class UniversityControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UniversityRepository universityRepository;

    @BeforeEach
    void setUp() {
        universityRepository.deleteAll();
    }

    @Test
    @DisplayName("GET /universities - 대학 목록 조회 성공")
    void getUniversities() throws Exception {
        // given
        University kh = University.builder().code("KHU").name("경희대학교").build();
        University snu = University.builder().code("SNU").name("서울대학교").build();
        universityRepository.save(kh);
        universityRepository.save(snu);

        // when & then
        mockMvc.perform(get("/universities")
                        .contentType(MediaType.APPLICATION_JSON))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(2))
                .andExpect(jsonPath("$[?(@.code == 'KHU')].name").value("경희대학교"))
                .andExpect(jsonPath("$[?(@.code == 'SNU')].name").value("서울대학교"));
    }
}
