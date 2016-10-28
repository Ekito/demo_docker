#!/bin/bash

#Creates machines in default project previously initialized in gcloud

# sets up swarm id
if [ $# -ne 1 ]
then
  echo first create a swarm id : docker run swarm create
  echo "Not the right number of arguments. Try sudo ./create_swarm_doc.sh [swarmId]."
  exit $E_WRONG_ARGS_NO
fi
SWARM_ID=$1
echo swarm id is [$SWARM_ID]

#create swarm managers
for MGR_ID in {1..2}
do
  docker-machine create \
  --driver virtualbox \
  --swarm \
  --swarm-master \
  --swarm-discovery token://$SWARM_ID \
  vbox-mgr-$MGR_ID
done

#create worker nodes
for NODE_ID in {1..1}
do
  docker-machine create \
  --driver virtualbox \
  --swarm \
  --swarm-discovery token://$SWARM_ID \
  vbox-node-$NODE_ID
done
