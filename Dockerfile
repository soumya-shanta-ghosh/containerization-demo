FROM eclipse-temurin:17-jdk-alpine

RUN mkdir -p /tmp/build && \
	mkdir /app && \
	mkdir /app/logs && \
	touch /tmp/pid && \
	touch /app/logs/spring-boot-logger.log

COPY . /tmp/build/

WORKDIR /tmp/build
RUN chmod +x mvnw && \
	./mvnw clean package && \
	java -Djarmode=layertools -jar ./target/containerization-demo*.jar extract --destination target/extracted

WORKDIR /app

RUN cp -r /tmp/build/target/extracted/dependencies/* ./  && \
	if [[ -z "$(ls -A /tmp/build/target/extracted/snapshot-dependencies/)" ]]; then echo "Directory is empty."; else cp -r /tmp/build/target/extracted/snapshot-dependencies/* ./ ; fi && \
	cp -r /tmp/build/target/extracted/spring-boot-loader/* ./ && \
	cp -r /tmp/build/target/extracted/application/* ./

RUN addgroup -S appgroup && adduser -S appuser -G appgroup && \
	chown -R appuser:appgroup /app/ && \
	chmod 777 /tmp/pid && \
	chown appuser:appgroup /tmp/pid && \
	rm -rf /tmp/build

USER appuser
ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]