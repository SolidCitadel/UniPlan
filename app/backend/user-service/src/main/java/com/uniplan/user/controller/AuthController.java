package com.uniplan.user.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Optional;

@RestController
public class AuthController {

    @GetMapping("/")
    public String home() {
        return "Welcome to UniPlan User Service!";
    }

    @GetMapping("/user")
    public Map<String, Object> user(@AuthenticationPrincipal OAuth2User principal) {
        return Map.of(
            "sub", Optional.ofNullable(principal.getAttribute("sub")).orElse("Unknown"),
            "name", Optional.ofNullable(principal.getAttribute("name")).orElse("Unknown"),
            "email", Optional.ofNullable(principal.getAttribute("email")).orElse("No email"),
            "picture", Optional.ofNullable(principal.getAttribute("picture")).orElse("")
        );
    }

    @GetMapping("/login/success")
    public Map<String, Object> loginSuccess(@AuthenticationPrincipal OAuth2User principal) {
        return Map.of(
            "message", "Login successful",
            "user", Map.of(
                "sub", Optional.ofNullable(principal.getAttribute("sub")).orElse("Unknown"),
                "name", Optional.ofNullable(principal.getAttribute("name")).orElse("Unknown"),
                "email", Optional.ofNullable(principal.getAttribute("email")).orElse("No email")
            )
        );
    }
}
