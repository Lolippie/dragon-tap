FROM maven:3.9.11-eclipse-temurin-25-alpine AS builder

WORKDIR /build

COPY pom.xml ./

COPY src ./src

RUN mvn -B package
  
FROM eclipse-temurin:25-jre-alpine

WORKDIR /app

COPY --from=builder /build/target/*.jar /app/app.jar

EXPOSE 4181

CMD ["sh", "-c", "java -jar /app/app.jar"]