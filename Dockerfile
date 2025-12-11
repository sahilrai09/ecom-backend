# Build stage - use Maven with JDK 17
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom and download dependencies first (cache)
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -B -DskipTests package

# Run stage - use slim JRE
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app

# Copy packaged jar from build stage
COPY --from=build /app/target/ecom-proj-0.0.1-SNAPSHOT.jar ./app.jar

# Expose port (Render uses $PORT env at runtime)
EXPOSE 8080

# Use the PORT env variable if provided by Render
ENV JAVA_OPTS=""

# Start command
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
