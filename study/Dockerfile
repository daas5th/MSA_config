FROM maven:latest

ENV APP_FILE config-service-1.0-SNAPSHOT.jar
EXPOSE 8061
WORKDIR /opt
COPY pom.xml /opt/pom.xml
COPY src /opt/src
RUN mvn package

ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar target/$APP_FILE"]
