FROM ubuntu:16.04
LABEL maintainer="Event Store LLP <ops@geteventstore.com>"

ENV TINI_VERSION=v0.18.0 \
    ES_VERSION=4.1.1-hotfix1-1 \
    DEBIAN_FRONTEND=noninteractive \
    EVENTSTORE_CLUSTER_GOSSIP_PORT=2112

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

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

CMD ["/entrypoint.sh"]
