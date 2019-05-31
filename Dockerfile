# Base image from (http://phusion.github.io/baseimage-docker)
FROM openjdk:8u151-jre-alpine


# Override default value with 'docker build --build-arg BUILDTIME_CORDA_VERSION=version'
# example: 'docker build --build-arg BUILDTIME_CORDA_VERSION=1.0.0 -t corda/node:1.0 .'
ARG BUILDTIME_CORDA_VERSION=2.0.0
ARG BUILDTIME_JAVA_OPTIONS

ENV CORDA_VERSION=${BUILDTIME_CORDA_VERSION}
ENV JAVA_OPTIONS=${BUILDTIME_JAVA_OPTIONS}

# Set image labels
LABEL net.corda.version = ${CORDA_VERSION} \
      maintainer = "<devops@r3.com>" \
      vendor = "R3"

RUN apk upgrade --update && \
    apk add --update --no-cache bash iputils && \
    rm -rf /var/cache/apk/* && \
    # Add user to run the app && \
    addgroup corda && \
    adduser -G corda -D -s /bin/bash corda && \
    # Create /opt/corda directory && \
    mkdir -p /opt/corda/plugins && \
    mkdir -p /opt/corda/logs




# Copy corda jar
ADD --chown=corda:corda https://dl.bintray.com/r3/corda/net/corda/corda/${CORDA_VERSION}/corda-${CORDA_VERSION}.jar                       /opt/corda/corda.jar
ADD --chown=corda:corda https://dl.bintray.com/r3/corda/net/corda/corda-webserver/${CORDA_VERSION}/corda-webserver-${CORDA_VERSION}.jar   /opt/corda/corda-webserver.jar

COPY run-corda.sh /run-corda.sh
RUN chmod +x /run-corda.sh && \
    sync && \
    chown -R corda:corda /opt/corda

# Expose port for corda (default is 10002) and RPC
EXPOSE 10002
#EXPOSE 10003
#EXPOSE 10004

# Working directory for Corda
WORKDIR /opt/corda
ENV HOME=/opt/corda
USER corda

# Start it
CMD ["/run-corda.sh"]





FROM openjdk:11-jdk

CMD ["gradle"]

ENV GRADLE_HOME /opt/gradle
ENV GRADLE_VERSION 5.4.1

ARG GRADLE_DOWNLOAD_SHA256=7bdbad1e4f54f13c8a78abc00c26d44dd8709d4aedb704d913fb1bb78ac025dc
RUN set -o errexit -o nounset \
    && echo "Downloading Gradle" \
    && wget --no-verbose --output-document=gradle.zip "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" \
    \
    && echo "Checking download hash" \
    && echo "${GRADLE_DOWNLOAD_SHA256} *gradle.zip" | sha256sum --check - \
    \
    && echo "Installing Gradle" \
    && unzip gradle.zip \
    && rm gradle.zip \
    && mv "gradle-${GRADLE_VERSION}" "${GRADLE_HOME}/" \
    && ln --symbolic "${GRADLE_HOME}/bin/gradle" /usr/bin/gradle \
    \
    && echo "Adding gradle user and group" \
    && groupadd --system --gid 1000 gradle \
    && useradd --system --gid gradle --uid 1000 --shell /bin/bash --create-home gradle \
    && mkdir /home/gradle/.gradle \
    && chown --recursive gradle:gradle /home/gradle \
    \
    && echo "Symlinking root Gradle cache to gradle Gradle cache" \
    && ln -s /home/gradle/.gradle /root/.gradle

# Create Gradle volume
USER gradle
VOLUME "/home/gradle/.gradle"
WORKDIR /home/gradle

RUN set -o errexit -o nounset \
    && echo "Testing Gradle installation" \
    && gradle --version










RUN gradle --version



FROM java:8-jdk
MAINTAINER Pierre Vincent

# In case someone loses the Dockerfile
#RUN rm -rf /etc/Dockerfile
#ADD Dockerfile /etc/Dockerfile




FROM ubuntu:16.04
RUN apt-get update 

RUN apt-get -y install bash 
RUN apt-get -y install docker 
RUN apt-get -y install python 
WORKDIR corda 
CMD sh -c "pip install corda"


RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:mmk2410/intellij-idea-community
RUN apt update
RUN apt -y install intellij-idea-community





