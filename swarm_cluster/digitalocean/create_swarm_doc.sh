#!/bin/bash

#Creates machines in default project previously initialized in gcloud

ACCESS_TOKEN=$(cat ./doc_token)
#create consul kv store
docker-machine create \
--driver digitalocean \
--digitalocean-size 1gb \
--digitalocean-access-token $ACCESS_TOKEN \
doc-consul-1

eval $(docker-machine env doc-consul-1)

docker run -d -p 8500:8500 \
--restart always --name=consul \
progrium/consul -server -bootstrap

CONSUL_IP=$(docker-machine ssh doc-consul-1 "ifconfig eth0 | grep 'inet addr' | cut -d ' ' -f 12 | cut -d ':' -f 2")

echo Consul Server up and running. IP: $CONSUL_IP


#create swarm managers
for MGR_ID in {1..2}
do
  docker-machine create \
  --driver digitalocean \
  --digitalocean-access-token $ACCESS_TOKEN \
  --digitalocean-size 1gb \
  --swarm \
  --swarm-master \
  --swarm-discovery consul://$CONSUL_IP:8500 \
  --swarm-opt heartbeat=10s \
  --engine-opt cluster-store=consul://$CONSUL_IP:8500 \
  --engine-opt cluster-advertise=eth0:2376 \
  doc-mgr-$MGR_ID &
done

#create worker nodes
for NODE_ID in {1..1}
do
  docker-machine create \
  --driver digitalocean \
  --digitalocean-access-token $ACCESS_TOKEN \
  --digitalocean-size 4gb \
  --swarm \
  --swarm-discovery consul://$CONSUL_IP:8500 \
  --swarm-opt heartbeat=10s \
  --engine-opt cluster-store=consul://$CONSUL_IP:8500 \
  --engine-opt cluster-advertise=eth0:2376 \
  doc-node-$NODE_ID &
done
wait
