FROM ubuntu:14.04.3
MAINTAINER Event Store LLP <ops@geteventstore.com>

RUN apt-get update && apt-get install curl -y &&\
    curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh | bash &&\
    apt-get install eventstore-oss -y &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 1113
EXPOSE 2113

ONBUILD VOLUME /var/lib/eventstore

COPY eventstore.conf /etc/eventstore/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
