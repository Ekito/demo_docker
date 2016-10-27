#!/bin/bash

#Creates machines in default project previously initialized in gcloud

# recovers the default project id
PROJECT_ID=$(gcloud info | grep project: | cut -d " " -f 6 | cut -d "[" -f 2 | cut -d "]" -f 1)

# sets up google api credentials location
export GOOGLE_APPLICATION_CREDENTIALS="$(pwd)/Swarm Test-ff404fd8c125.json"

# sets up swarm id
if [ $# -ne 1 ]
then
  echo first create a swarm id : docker run swarm create
  echo "Not the right number of arguments. Try sudo ./create_swarm_gce [swarmId]."
  exit $E_WRONG_ARGS_NO
fi
SWARM_ID=$1
echo swarm id is [$SWARM_ID]

#create swarm managers
for MGR_ID in {1..2}
do
  docker-machine create \
  --driver google \
  --google-project $PROJECT_ID \
  --swarm \
  --swarm-master \
  --swarm-discovery token://$SWARM_ID \
  mgr_$MGR_ID
done

#create worker nodes
for NODE_ID in {1..1}
do
  docker-machine create \
  --driver google \
  --google-project $PROJECT_ID \
  --swarm \
  --swarm-discovery token://$SWARM_ID \
  node_$NODE_ID
done
