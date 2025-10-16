package com.uniplan.user.global.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    // TODO: OAuth2 기능 추가 시 OAuth2LoginSuccessHandler 주입
    // private final OAuth2LoginSuccessHandler oAuth2LoginSuccessHandler;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public org.springframework.security.web.SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(authz -> authz
                .anyRequest().permitAll()  // API Gateway에서 이미 JWT 검증을 수행하므로 모든 요청 허용
            )
            // TODO: OAuth2 로그인 활성화 (향후 확장)
            // .oauth2Login(oauth2 -> oauth2
            //     .successHandler(oAuth2LoginSuccessHandler)
            // )
            .csrf(csrf -> csrf.disable())  // REST API이므로 CSRF 비활성화
            .headers(headers -> headers
                .frameOptions(frameOptions -> frameOptions.sameOrigin())  // H2 콘솔 iframe 허용
            );
        return http.build();
    }
}
