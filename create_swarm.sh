#!/bin/bash

set -e

echo "Creating swarm cluster"

docker-machine create -d virtualbox local
eval "$(docker-machine env local)"
docker run swarm create > swarm_token
TOKEN=`cat swarm_token`
docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery token://$TOKEN swarm-master
docker-machine create -d virtualbox --swarm --swarm-discovery token://$TOKEN swarm-agent-00
docker-machine create -d virtualbox --swarm --swarm-discovery token://$TOKEN swarm-agent-01
eval $(docker-machine env --swarm swarm-master)

