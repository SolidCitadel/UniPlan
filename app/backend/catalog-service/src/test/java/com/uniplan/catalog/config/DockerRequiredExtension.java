package com.uniplan.catalog.config;

import org.junit.jupiter.api.extension.BeforeAllCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.DockerClientFactory;

/**
 * JUnit 5 Extension that checks Docker availability before tests run.
 * Fails fast with a clear error message if Docker is not available.
 * 
 * Usage:
 * <pre>
 * {@code @ExtendWith(DockerRequiredExtension.class)}
 * {@code @SpringBootTest}
 * class MyTest { }
 * </pre>
 */
public class DockerRequiredExtension implements BeforeAllCallback {

    private static final Logger log = LoggerFactory.getLogger(DockerRequiredExtension.class);
    private static boolean checked = false;

    @Override
    public void beforeAll(ExtensionContext context) {
        // Only check once per test run
        if (checked) {
            return;
        }
        checked = true;

        log.info("Checking Docker availability for TestContainers...");

        try {
            boolean dockerAvailable = DockerClientFactory.instance().isDockerAvailable();

            if (!dockerAvailable) {
                throw new IllegalStateException(buildErrorMessage());
            }

            log.info("Docker is available. Proceeding with tests.");
        } catch (ExceptionInInitializerError | NoClassDefFoundError e) {
            throw new IllegalStateException(
                "Failed to check Docker availability. Is TestContainers dependency configured?", e
            );
        }
    }

    private String buildErrorMessage() {
        return "\n\n" +
            "╔══════════════════════════════════════════════════════════════════════╗\n" +
            "║  ❌ DOCKER IS NOT RUNNING                                            ║\n" +
            "║                                                                      ║\n" +
            "║  Component tests require Docker for TestContainers.                  ║\n" +
            "║                                                                      ║\n" +
            "║  Please start Docker Desktop and try again.                          ║\n" +
            "║                                                                      ║\n" +
            "║  To run only unit tests (no Docker required):                        ║\n" +
            "║    ./gradlew test --tests '**/unit/**'                               ║\n" +
            "╚══════════════════════════════════════════════════════════════════════╝\n";
    }
}
