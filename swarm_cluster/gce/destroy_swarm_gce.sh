#!/bin/bash
# sets up google api credentials location
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/Swarm Test-ff404fd8c125.json"

docker-machine rm gce-consul-1 -y -f &

for MGR_ID in {1..3}
do
  docker-machine rm gce-mgr-$MGR_ID -y -f &
done

for NODE_ID in {1..1}
do
  docker-machine rm gce-node-$NODE_ID -y -f &
done
wait
