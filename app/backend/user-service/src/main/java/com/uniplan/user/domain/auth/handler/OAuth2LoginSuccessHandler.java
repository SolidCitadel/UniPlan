package com.uniplan.user.domain.auth.handler;

import com.uniplan.user.domain.user.entity.User;
import com.uniplan.user.domain.user.service.UserService;
import com.uniplan.user.domain.auth.service.JwtTokenProvider;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;

/**
 * OAuth2 로그인 성공 시 처리 핸들러
 * Google 로그인 성공 후 사용자 정보를 DB에 저장하고 JWT 토큰 발급
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class OAuth2LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

    @org.springframework.beans.factory.annotation.Value("${oauth2.success-redirect-url:}")
    private String frontendRedirectUrl;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException {

        OAuth2User oAuth2User = (OAuth2User) authentication.getPrincipal();

        // 1. Google 사용자 정보 추출
        String googleId = oAuth2User.getAttribute("sub");
        String email = oAuth2User.getAttribute("email");
        String name = oAuth2User.getAttribute("name");
        String picture = oAuth2User.getAttribute("picture");

        log.info("OAuth2 로그인 성공 - googleId: {}, email: {}", googleId, email);

        // 2. DB에 사용자 저장 또는 업데이트
        User user = userService.findOrCreateUser(googleId, email, name, picture);

        log.info("사용자 처리 완료 - userId: {}, email: {}", user.getId(), user.getEmail());

        // 3. JWT 토큰 생성
        String accessToken = jwtTokenProvider.generateAccessToken(user.getId());
        String refreshToken = jwtTokenProvider.generateRefreshToken(user.getId());

        log.info("JWT 토큰 발급 완료 - userId: {}", user.getId());

        // 4. 프론트엔드 URL로 리다이렉트 (토큰을 쿼리 파라미터로 전달)
        String redirectUrl = UriComponentsBuilder.fromUriString(
                        frontendRedirectUrl.isBlank() ? "http://localhost:3000/auth/callback" : frontendRedirectUrl)
                .queryParam("accessToken", accessToken)
                .queryParam("refreshToken", refreshToken)
                .queryParam("userId", user.getId())
                .queryParam("email", user.getEmail())
                .queryParam("name", user.getName())
                .build()
                .toUriString();

        log.info("OAuth2 로그인 성공, 리다이렉트: {}", redirectUrl);
        log.info("========================================");
        log.info("Access Token: {}", accessToken);
        log.info("Refresh Token: {}", refreshToken);
        log.info("========================================");
        log.info("테스트용 curl 명령어:");
        log.info("curl -H \"Authorization: Bearer {}\" http://localhost:8080/api/v1/users/me", accessToken);
        log.info("========================================");
        getRedirectStrategy().sendRedirect(request, response, redirectUrl);
    }
}
