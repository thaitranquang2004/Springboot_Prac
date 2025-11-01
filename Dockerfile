# Build stage: Maven compile với Java 25 (tag tồn tại)
FROM maven:3.9.11-eclipse-temurin-25-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline  # Cache dependencies để build nhanh
COPY src src
RUN mvn clean package -DskipTests

# Runtime stage: Chạy JAR với Java 25 (alpine nhỏ gọn)
FROM eclipse-temurin:25-jdk-alpine
ARG JAR_FILE=*.jar  # Tự động lấy JAR từ target/
COPY --from=build /app/target/${JAR_FILE} app.jar
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -jar /app.jar"]
EXPOSE 8080