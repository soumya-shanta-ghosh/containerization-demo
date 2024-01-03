FROM eclipse-temurin:17-jre-alpine
VOLUME /tmp
ARG EXTRACTED=./target/extracted

RUN mkdir /app && \
    mkdir /app/logs && \
    touch /tmp/pid && \
    touch /app/logs/spring-boot-logger.log

WORKDIR /app

COPY ${EXTRACTED}/dependencies/ ./
COPY ${EXTRACTED}/snapshot-dependencies/ ./
COPY ${EXTRACTED}/spring-boot-loader/ ./
COPY ${EXTRACTED}/application/ ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app/ && \
    chmod 777 /tmp/pid && \
    chown appuser:appgroup /tmp/pid

USER appuser
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]