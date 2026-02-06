FROM alpine AS artifact
WORKDIR /artifacts
COPY build/libs/*-all.jar app.jar

FROM eclipse-temurin:17-jre
WORKDIR /app

RUN useradd -m appuser
USER appuser

COPY --from=artifact /artifacts/app.jar app.jar

CMD ["java", "-jar", "app.jar"]
