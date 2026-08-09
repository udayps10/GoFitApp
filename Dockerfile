FROM tomcat:9-jdk21
COPY GOFIT.war /usr/local/tomcat/webapps/GOFIT.war
EXPOSE 8080
