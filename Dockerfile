FROM ubuntu:16.04

ENV ES_VERSION=5.0.0-1 \    
    EVENTSTORE_CLUSTER_GOSSIP_PORT=2112

RUN apt-get update \
    && apt-get install tzdata curl iproute2 -y \
    && curl -fSL -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh | bash \
    && apt-get install eventstore-oss=$ES_VERSION -y      

EXPOSE 1112 2112 1113 2113

VOLUME /var/lib/eventstore

COPY eventstore.conf /etc/eventstore/
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]