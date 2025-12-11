# Build stage - use Maven with JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom and download dependencies first (cache)
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn -B -DskipTests package

# Run stage - use JDK 21
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# Copy packaged jar from build stage
COPY --from=build /app/target/ecom-proj-0.0.1-SNAPSHOT.jar ./app.jar

EXPOSE 8080

ENV JAVA_OPTS=""

ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar /app/app.jar"]
