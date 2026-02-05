# ------ stage 1: build -------
FROM gradle:8-jdk17 AS builder

WORKDIR /app

# copy Gradle build files first
COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts .

RUN chmod +x gradlew && ./gradlew dependencies --no-daemon

# then copy source code
COPY src src

# build the application (creates gradle-hello-world-all.jar)
RUN ./gradlew clean build --no-daemon


# ------ stage 2: runtime -------
FROM eclipse-temurin:17-jre

WORKDIR /app

# create non-root user
RUN useradd -m appuser
USER appuser

# copy only the fat jar
COPY --from=builder /app/build/libs/*-all.jar /app/app.jar

# run the application
ENTRYPOINT ["java","-jar","/app/app.jar"]
