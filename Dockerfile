FROM openjdk:17-jdk-slim
VOLUME /tmp
COPY target/spring-boot-app.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]