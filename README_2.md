# Gradle Hello World – CI/CD devops project

This project demonstrates a complete CI pipeline for a simple java "hello world" application, built with gradle and automated using github actions.

The focus of the project is not the application itself, but the ci process around it: versioning, build automation, artifact handling, sbom generation, artifact signing, containerization and publishing.

---

## Project goals

The main goals of this project are:
- demonstrate a clean and reproducible build using gradle wrapper
- automate version management (patch version bump)
- produce and publish build artifacts
- generate and publish sbom for supply chain visibility
- sign build artifacts to ensure integrity
- containerize the application using docker
- push and run a versioned docker image automatically

---

## Project structure

- `src/`  
  contains the java source code.  
  a minimal hello world application used as a build target.

- `build.gradle.kts`  
  gradle build configuration using kotlin dsl.  
  defines the application version and build settings.

- `gradlew` and `gradle/wrapper/`  
  gradle wrapper files that allow running the build without installing gradle locally.  
  this ensures the same gradle version is used by all developers and in the CI pipeline.

- `Dockerfile`  
  defines how the application is packaged into a docker image.  

- `.github/workflows/ci.yml`  
  github actions workflow implementing the full CI pipeline.

- `LICENSE`  
  this project is licensed under the apache license 2.0, which allows free use, modification, reproduction and distribution of the code with built-in patent protection.

---

## CI pipeline overview

The pipeline runs automatically on every push event to the `master` branch.

### 1. source checkout and environment setup
- checks out the repository
- installs java 17 (temurin distribution)
- makes the gradle wrapper executable

this ensures a consistent and reproducible build environment.

---

### 2. automatic version management
- reads the current version from `build.gradle.kts`
- increments the patch version (for example: `1.0.0 → 1.0.1`)
- exposes the new version to later pipeline steps

this guarantees that every build produces a uniquely versioned artifact and docker image.

---

### 3. build and package
- runs `./gradlew build`
- compiles the java code
- produces a jar file under `build/libs/`

this step creates the main build artifact.

---

### 4. artifact publishing
- uploads the generated jar as a github actions artifact

this allows the build output to be downloaded directly from the ci run.

---

### 5. sbom generation and publishing
- installs trivy
- generates a software bill of materials (SBOM) in cyclonedx json format
- uploads the sbom as a ci artifact

the sbom provides visibility into the software components used in the build and supports supply chain security practices.

---

### 6. artifact signing
- installs cosign
- generates a signing key
- signs the jar artifact

this demonstrates how build artifacts can be verified for integrity and authenticity.

---

### 7. docker build, push and run
- logs in to docker hub using Github secrets
- builds a docker image using the dockerfile
- tags the image with the same version as the jar artifact
- pushes the image to Docker hub
- runs the container to verify successful execution

docker automatically pulls the image if it does not exist locally.

---

### 8. version commit 
- commits the updated version back to the repository
- runs only after the pipeline completes successfully

this prevents broken or failed builds from updating the project version.

---


