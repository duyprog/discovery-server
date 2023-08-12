FROM openjdk:17

# Add user 

WORKDIR /home/microservices-example

VOLUME /tmp 

# ADD entrypoint.sh entrypoint.sh

# RUN chmod 777 entrypoint.sh 

# USER duypk5 

ADD ./target/*.jar eureka.jar 

ENTRYPOINT [ "java", "-jar","./eureka.jar" ]

EXPOSE 8761