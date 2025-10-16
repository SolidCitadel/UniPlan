import org.gradle.api.tasks.testing.Test

val springCloudVersion = "2025.0.0"

plugins {
    java
    id("org.springframework.boot") version "3.5.6"
    id("io.spring.dependency-management") version "1.1.7"
}

group = "com.uniplan"
version = "0.0.1-SNAPSHOT"
description = "User-Service for UniPlan"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

dependencies {
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springframework.cloud:spring-cloud-starter-gateway-server-webflux")

    // Swagger for API Gateway (통합 문서)
    implementation("org.springdoc:springdoc-openapi-starter-webflux-ui:2.3.0")

    // JWT 검증 (User Service와 동일한 시크릿 키 사용)
    implementation("io.jsonwebtoken:jjwt-api:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-impl:0.12.3")
    runtimeOnly("io.jsonwebtoken:jjwt-jackson:0.12.3")

    implementation(project(":common-lib"))
}

configurations {
    val annotationProcessor = getByName("annotationProcessor")
    getByName("compileOnly").extendsFrom(annotationProcessor)
}

tasks.withType<Test>().configureEach {
    useJUnitPlatform()
}

dependencyManagement {
    imports {
        mavenBom("org.springframework.cloud:spring-cloud-dependencies:$springCloudVersion")
    }
}