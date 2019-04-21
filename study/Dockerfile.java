# build stage
FROM maven:latest AS build
MAINTAINER dass5th-TEAM

WORKDIR /opt
COPY pom.xml /opt/pom.xml
COPY src /opt/src
RUN mvn package

# running stage
FROM openjdk:8-jre-alpine

## copy jarfile from build stage
ENV APP_FILE config-service-1.0-SNAPSHOT.jar
COPY --from=build /opt/target/$APP_FILE /opt/

## configuring etc.
EXPOSE 8061
WORKDIR /opt
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar $APP_FILE"]
