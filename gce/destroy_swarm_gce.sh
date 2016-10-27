#!/bin/bash
# sets up google api credentials location
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/Swarm Test-ff404fd8c125.json"


for MGR_ID in {1..2}
do
  docker-machine rm gce-mgr-$MGR_ID -y
done

for NODE_ID in {1..1}
do
  docker-machine rm gce-node-$NODE_ID -y
done