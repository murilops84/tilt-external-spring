FROM openjdk:17-alpine AS build
#RUN apk add openjdk17-jdk
RUN mkdir /app
WORKDIR /app
COPY target/jar/application.jar application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM openjdk:17-alpine
#RUN apk add openjdk17-jdk
RUN mkdir /app
WORKDIR /app
COPY --from=build /app/dependencies /app
COPY --from=build /app/snapshot-dependencies /app
COPY --from=build /app/spring-boot-loader /app
COPY --from=build /app/application /app
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
