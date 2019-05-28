FROM maven:3.5-jdk-8 as config-service-build

WORKDIR /app
ADD pom.xml pom.xml
RUN mvn clean dependency:go-offline

ADD src src
RUN mvn -o package

FROM openjdk:8u171-jre-alpine
WORKDIR /app

COPY --from=config-service-build /app/target/*.jar .

EXPOSE 8088
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar *.jar"]
