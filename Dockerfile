FROM eclipse-temurin:17-jdk-alpine as builder

COPY target/containerization-demo.jar application.jar

RUN java -Djarmode=layertools -jar application.jar extract

FROM eclipse-temurin:17-jdk-alpine
RUN mkdir /app
RUN mkdir /app/logs
RUN touch /tmp/pid
RUN touch /app/logs/spring-boot-logger.log
WORKDIR /app
COPY --from=builder dependencies/ ./
COPY --from=builder internal-dependencies/ ./
COPY --from=builder snapshot-dependencies/ ./
COPY --from=builder spring-boot-loader/ ./
COPY --from=builder application/ ./
#RUN addgroup --system --gid 1002 app && adduser --system --uid 1002 --gid 1002 appuser
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app/
USER appuser
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]