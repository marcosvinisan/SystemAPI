
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app


COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN ./mvnw dependency:go-offline -B


COPY src ./src
RUN ./mvnw clean package -DskipTests -B


FROM eclipse-temurin:21-jre-alpine AS runtime


RUN addgroup -S bankapp && adduser -S bankapp -G bankapp
USER bankapp

WORKDIR /app

COPY --from=build /app/target/banksystem-1.0.0-SNAPSHOT.jar app.jar


EXPOSE 8080


ENV SPRING_PROFILES_ACTIVE=dev \
JAVA_OPTS="-Xms256m -Xmx512m"


ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
