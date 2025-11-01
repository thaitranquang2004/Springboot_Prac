# Build stage: Maven compile với Java 25
FROM maven:3.9.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline  # Cache dependencies
COPY src src
RUN mvn clean package -DskipTests

# Runtime stage: Chạy JAR với Java 25
FROM eclipse-temurin:25-jdk-alpine
VOLUME /tmp
ARG JAR_FILE=*.jar  # Tự động lấy JAR từ target/
COPY --from=build /app/target/${JAR_FILE} app.jar
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app.jar"]
EXPOSE 8080