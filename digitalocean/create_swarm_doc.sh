#!/bin/bash

#Creates machines in default project previously initialized in gcloud

ACCESS_TOKEN=$(cat ./doc_token)

echo access token is [$ACCESS_TOKEN]

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
  --driver digitalocean \
  --digitalocean-access-token $ACCESS_TOKEN \
  --swarm \
  --swarm-master \
  --swarm-discovery token://$SWARM_ID \
  doc-mgr-$MGR_ID
done

#create worker nodes
for NODE_ID in {1..1}
do
  docker-machine create \
  --driver digitalocean \
  --digitalocean-access-token $ACCESS_TOKEN \
  --swarm \
  --swarm-discovery token://$SWARM_ID \
  doc-node-$NODE_ID
done
