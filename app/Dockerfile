FROM gradle:jdk11 as builder

COPY . /app

WORKDIR /app

RUN gradle build -x test

FROM adoptopenjdk/openjdk11:latest

VOLUME /tmp

COPY --from=builder /app/build/libs/petal-0.0.1-SNAPSHOT.jar /opt/app.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/.urandom","-jar","/opt/app.jar"]
