FROM docker.io/library/debian:bookworm-slim as base

FROM docker.io/library/node:lts-bookworm-slim AS node

FROM base as builder
# Import Node.js binaries
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/share /usr/local/share
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

USER root
WORKDIR /tmp
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl wget zip git \
    openjdk-17-jdk

# Install sencha tool
RUN wget "https://trials.sencha.com/cmd/7.6.0/SenchaCmd-7.6.0.87-linux-amd64.sh.zip" && \
    unzip SenchaCmd-*.zip && \
    ./SenchaCmd-*.sh -q

##Set environment
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${PATH}:$JAVA_HOME/bin/"
ENV PATH="${PATH}:$HOME/bin/Sencha/Cmd/"

RUN rm -rf *
