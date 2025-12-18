# Build stage
FROM maven:3.8.6-openjdk-11-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM tomcat:9.0-jdk11-openjdk-slim
# Hapus aplikasi default ROOT tomcat agar aplikasi kita menjadi default
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy hasil build WAR ke folder webapps tomcat sebagai ROOT.war
COPY --from=build /app/target/weatherforecast.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
