FROM openjdk:21-jdk-slim

WORKDIR /app

COPY build.gradle gradlew ./

COPY gradle gradle

RUN chmod +x gradlew

COPY src src

RUN ./gradlew build -x test


CMD ["java","-jar","build/libs/adservice.js"]
