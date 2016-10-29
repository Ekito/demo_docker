#!/bin/bash

docker-machine rm vbox-consul-1 -y -f



for MGR_ID in {1..3}
do
  docker-machine rm vbox-mgr-$MGR_ID -y -f
done

for NODE_ID in {1..1}
do
  docker-machine rm vbox-node-$NODE_ID -y -f
done
