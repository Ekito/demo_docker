#!/bin/bash

#Creates machines in default project previously initialized in gcloud

# recovers the default project id
PROJECT_ID=$(gcloud info | grep project: | cut -d " " -f 6 | cut -d "[" -f 2 | cut -d "]" -f 1)

# sets up google api credentials location
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/Swarm Test-ff404fd8c125.json"

#create consul kv store
docker-machine create \
--driver google \
--google-project $PROJECT_ID \
gce-consul-1

eval $(docker-machine env gce-consul-1)

docker run -d -p 8500:8500 \
--restart always --name=consul \
progrium/consul -server -bootstrap

CONSUL_IP=$(docker-machine ssh gce-consul-1 "ifconfig eth0 | grep 'inet addr' | cut -d ' ' -f 12 | cut -d ':' -f 2")

echo Consul Server up and running. IP: $CONSUL_IP

#create swarm managers
for MGR_ID in {1..3}
do
  docker-machine create \
  --driver google \
  --google-project $PROJECT_ID \
  --swarm \
  --swarm-master \
  --swarm-discovery consul://$CONSUL_IP:8500 \
  --swarm-opt heartbeat=10s \
  --engine-opt cluster-store=consul://$CONSUL_IP:8500 \
  --engine-opt cluster-advertise=eth0:2376 \
  gce-mgr-$MGR_ID &
done

#create worker nodes
for NODE_ID in {1..1}
do
  docker-machine create \
  --driver google \
  --google-project $PROJECT_ID \
  --swarm \
  --swarm-discovery consul://$CONSUL_IP:8500 \
  --swarm-opt heartbeat=10s \
  --engine-opt cluster-store=consul://$CONSUL_IP:8500 \
  --engine-opt cluster-advertise=eth0:2376 \
  --engine-label exposes=http8080 \
  --google-tags http8080 \
  gce-node-$NODE_ID &
done

wait
