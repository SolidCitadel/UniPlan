# Build a single Spring Boot service by module name passed via SERVICE build-arg.
ARG SERVICE

FROM gradle:8.10-jdk21 AS builder
ARG SERVICE
WORKDIR /workspace

# Copy only the backend module to leverage Gradle's multi-project build.
COPY app/backend/ .
RUN ./gradlew :${SERVICE}:bootJar

FROM eclipse-temurin:21-jre
ARG SERVICE
WORKDIR /app
COPY --from=builder /workspace/${SERVICE}/build/libs/*.jar app.jar
EXPOSE 8080 8081 8082 8083
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
