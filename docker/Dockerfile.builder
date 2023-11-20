FROM docker.io/library/debian:buster as base

FROM docker.io/library/node:lts-buster AS node

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
    apt upgrade && \
    apt install -y curl wget zip git

RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
RUN dpkg -i jdk-17_linux-x64_bin.deb
RUN wget "https://trials.sencha.com/cmd/7.6.0/SenchaCmd-7.6.0.87-linux-amd64.sh.zip" && \
    unzip SenchaCmd-*.zip && \
    ./SenchaCmd-*.sh -q

ENV JAVA_HOME=/usr/lib/jvm/jdk-17/
ENV PATH="${PATH}:$JAVA_HOME/bin/"
ENV PATH="${PATH}:$HOME/bin/Sencha/Cmd/"

RUN rm -rf *
