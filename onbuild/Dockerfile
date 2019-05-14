FROM ubuntu:16.04
MAINTAINER Event Store LLP <ops@geteventstore.com>

ENV ES_VERSION=5.0.1-1 \
    DEBIAN_FRONTEND=noninteractive \
    EVENTSTORE_CLUSTER_GOSSIP_PORT=2112

RUN apt-get update \
    && apt-get install tzdata curl iproute2 -y \
    && curl -s https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh | bash \
    && apt-get install eventstore-oss=$ES_VERSION -y \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 1112 2112 1113 2113

ONBUILD VOLUME /var/lib/eventstore

COPY eventstore.conf /etc/eventstore/
COPY entrypoint.sh /

HEALTHCHECK --timeout=2s CMD curl -sf http://localhost:2113/stats || exit 1

ENTRYPOINT ["/entrypoint.sh"]
