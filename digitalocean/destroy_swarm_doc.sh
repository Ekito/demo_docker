#!/bin/bash

for MGR_ID in {1..2}
do
  docker-machine rm doc-mgr-$MGR_ID -y -f
done

for NODE_ID in {1..1}
do
  docker-machine rm doc-node-$NODE_ID -y -f
done
