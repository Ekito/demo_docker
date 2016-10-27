# demo_docker
A docker cloud deployment demo.

## Architecture :

Two networks :

- front-tier includes load balancers
- back-tier includes web app to scale

For test purposes this contains two load balancers :

- traefik -> with subdomain routing
- dockercloud/haproxy which simply load balances across all web instances

Note here that load balancing is realized internally because swarm does not have an internal service LB
as opposed to Kubernetes, for example.

## Setting up a swarm cluster on GCE

## Prerequisites
Install Docker machine
https://docs.docker.com/machine/install-machine/

Install gloud CLI, then init with your account
https://cloud.google.com/sdk/docs/quickstart-linux

type gloud info and make sure that [core] and [compute] figure here

provision swarm cluster source documents
https://docs.docker.com/swarm/provision-with-machine/
https://docs.docker.com/machine/drivers/digital-ocean/
https://rominirani.com/docker-swarm-on-google-compute-engine-364765b400ed#.ivezta3zi

## Create Swarm cluster on GCE

Swarm creation script requires a swarm id. Swarm id is generated with swarm create command.
Its the docker's central registry that keeps track of swarm ids. Hence network
connection to docker is required. This mecanism has been copied form CoreOS.

```
$> cd gce
$> ./create_swarm_gce.sh $(docker run swarm create)
```

## Destroy Swarm cluster on GCE
```
$> cd gce
$> ./destroy_swarm_gce.sh
```
