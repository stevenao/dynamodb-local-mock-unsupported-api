FROM openjdk:8-jre-slim

LABEL maintainer="stevenao"

ENV DYNAMODB_LOCAL_DIR /opt/dynamodb_local
ENV APP_DIR /opt/app_server

WORKDIR $DYNAMODB_LOCAL_DIR

VOLUME ["/dynamodb_local_db"]

ENV DYNAMODB_VERSION=latest

ENV JAVA_OPTS=

RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y --no-install-recommends nodejs && \
    curl -O https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_${DYNAMODB_VERSION}.tar.gz && \
    tar zxvf dynamodb_local_${DYNAMODB_VERSION}.tar.gz && \
    rm dynamodb_local_${DYNAMODB_VERSION}.tar.gz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
    
COPY . $APP_DIR

RUN cd $APP_DIR && npm install --prod && cd $DYNAMODB_LOCAL_DIR

ENTRYPOINT exec java -Djava.library.path=. ${JAVA_OPTS} -jar DynamoDBLocal.jar --sharedDb -dbPath /dynamodb_local_db -port 45670 & cd $APP_DIR && npm run start

EXPOSE 4567
