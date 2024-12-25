# Stage 1: Build dependencies and compile code
FROM maven:3.8.8-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests && mvn dependency:copy-dependencies -DoutputDirectory=target/dependency

# Stage 2: Run application
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/target/rest-service-1.0-SNAPSHOT.jar app.jar
COPY --from=builder /app/target/dependency /app/dependency
ENTRYPOINT ["java", "-cp", "app.jar:dependency/*", "com.example.RestServiceApplication"]
