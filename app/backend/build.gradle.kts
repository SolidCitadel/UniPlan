import org.gradle.api.tasks.testing.Test

plugins {
    id("java")
    id("org.springframework.boot") version "3.5.5" apply false // 하위 모듈에서 적용하도록 false 처리
    id("io.spring.dependency-management") version "1.1.7" apply false
}

// 모든 하위 프로젝트에 적용될 공통 설정
subprojects {
    apply(plugin = "java")
    apply(plugin = "org.springframework.boot")
    apply(plugin = "io.spring.dependency-management")

    group = "com.uniplan"
    version = "0.0.1-SNAPSHOT"
    description = "Demo project for Spring Boot"

    repositories {
        mavenCentral()
    }

    // 모든 모듈이 공통으로 사용하는 의존성
    dependencies {
        compileOnly("org.projectlombok:lombok")
        annotationProcessor("org.projectlombok:lombok")
        testImplementation("org.springframework.boot:spring-boot-starter-test")
        testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    }

    // 공통 Java Toolchain (JDK 21)
    java {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(21))
        }
    }

    // 공통 configuration: compileOnly가 annotationProcessor를 상속
    configurations {
        val annotationProcessor = getByName("annotationProcessor")
        getByName("compileOnly").extendsFrom(annotationProcessor)
    }

    // 공통 테스트 설정
    tasks.withType<Test>().configureEach {
        useJUnitPlatform()
    }
}

// 일부 IDE/플러그인이 Gradle 8에서 제거된 태스크를 호출하는 경우를 대비한 호환 태스크
allprojects {
    if (tasks.findByName("prepareKotlinBuildScriptModel") == null) {
        tasks.register("prepareKotlinBuildScriptModel")
    }
}