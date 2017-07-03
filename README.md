# Event Store Docker Container
**Note: This container is for development purposes only**

The docker image will be available via the [Docker Hub Event Store Repository]( https://hub.docker.com/r/eventstore/eventstore/)

## Getting Started ##

### Single node mode ###

Pull the docker image
```
docker pull eventstore/eventstore
```
Run the container using
```
docker run --name eventstore-node -it -p 2113:2113 -p 1113:1113 eventstore/eventstore
```

> Note : The admin UI and atom feeds will only work if you publish the node's http port to a matching port on the host. (i.e. you need to run the container with `-p 2113:2113`)

### Cluster mode ###

**Note: please don't forget to check you're already in swarm mode.**

Ensure you have `esnet` network: `docker network inspect esnet`. If not you should create it on your swarm manager : `docker network create -d overlay --attachable esnet`

Then to run a cluster of 3 nodes for example:
```bash
docker service create --replicas 1 --name es1-node --network name=esnet,alias=escluster.net -e EVENTSTORE_CLUSTER_SIZE=3 -e EVENTSTORE_CLUSTER_DNS=escluster.net eventstore/eventstore
docker service create --replicas 1 --name es2-node --network name=esnet,alias=escluster.net -e EVENTSTORE_CLUSTER_SIZE=3 -e EVENTSTORE_CLUSTER_DNS=escluster.net eventstore/eventstore
docker service create --replicas 1 --name es3-node --network name=esnet,alias=escluster.net -e EVENTSTORE_CLUSTER_SIZE=3 -e EVENTSTORE_CLUSTER_DNS=escluster.net eventstore/eventstore
```

## Web UI ##

Get the docker ip address

**Via docker-machine**
```
docker-machine ip default
```
**Via docker**
```
docker inspect -f "{{ .NetworkSettings.IPAddress }}" eventstore-node
```
Using the ip address and the external http port (defaults to 2113) you can use the browser to view the event store admin ui.

e.g.
```
http://192.168.99.100:2113/
```
Username and password is `admin` and `changeit` respectively.

### Using your own configuration ###
When running the docker image, the user has the ability to provide environment variables.
e.g.
```
docker run -it -p 2113:2113 -e EVENTSTORE_RUN_PROJECTIONS=None eventstore/eventstore
```
The environment variables overrides the values supplied via the configuration file.

More documentation on Event Store's Configuration can be found [here](http://docs.geteventstore.com/server/latest/command-line-arguments/)

