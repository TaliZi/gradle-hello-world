# stage 1 - copy the artifact.
FROM alpine AS artifact
WORKDIR /artifacts
COPY build/libs/*-all.jar app.jar

# stage 2 - runtime.
FROM eclipse-temurin:17-jre
WORKDIR /app
RUN useradd -m appuser
USER appuser
COPY --from=artifact /artifacts/app.jar app.jar
CMD ["java", "-jar", "app.jar"]
