# Create war file
FROM maven:ibmjava-alpine AS build

#create home directory
RUN mkdir /home/footgo && apk update && apk add git &&\
 git clone https://github.com/WiseHands/FootGo.git -b 'release/1.0.0' --single-branch /home/footgo && \
cp /home/footgo/src/main/resources/application.properties.example /home/footgo/src/main/resources/application.properties
WORKDIR /home/footgo
RUN mvn -f /home/footgo/pom.xml clean package && mv /home/footgo/target/ROOT.war\
 /home/footgo/footgov1.war

# run footgo app
FROM tomcat:alpine AS prod

#RUN mkdir /home/footgo
WORKDIR /root/

COPY --from=build /home/footgo/footgov1.war . 
EXPOSE 8080
ENTRYPOINT java -jar footgov1.war
