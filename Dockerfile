FROM adoptopenjdk/openjdk11:alpine-jre

# Add user 

WORKDIR /home/microservices-example

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
  EUREKA_INSTANCE_IP_ADDRESS=""

RUN apk add --no-cache jq curl

RUN adduser -D -s /bin/sh duypk5

VOLUME /tmp 

ADD entrypoint.sh entrypoint.sh

RUN chmod 755 entrypoint.sh && chown duypk5:duypk5 entrypoint.sh

USER duypk5 

ADD ./target/*.jar eureka.jar 

ENTRYPOINT ["./entrypoint.sh"]

EXPOSE 8761