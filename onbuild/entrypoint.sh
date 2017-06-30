#!/usr/bin/env bash
set -e

if [ ! -z ${EVENTSTORE_CLUSTER_SIZE+x} ]
then
    export EVENTSTORE_INT_IP=`ip addr show eth0|grep '\/24'|awk '/inet / {print $2}'|sed -e 's/\/.*//'`
fi

exec eventstored