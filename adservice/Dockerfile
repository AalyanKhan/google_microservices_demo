FROM openjdk:19-jdk-slim AS builder

WORKDIR /app

COPY . .

RUN chmod +x gradlew
RUN ./gradlew clean build -x test

FROM eclipse-temurin:19-jre


RUN useradd --creat-home --shell /bin/false --uid 1000 javauser

USER javauser

WORKDIR /app

COPY --from=builder --chown=1000:1000 /app/build/libs/adservice.jar ./

EXPOSE 9555

CMD ["java", "-jar", "adservice.jar"]
