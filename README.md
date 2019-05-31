# Corda on Docker is now avaliable from main Corda repo. Please take a look at: https://github.com/corda/corda/tree/master/docker

**Old documentation:**

**Docker 17.09 and up is required for this Dockerfile.**

Docker configuration files to create and spin up Docker images for a few Corda Nodes (banka/bankb/bankc), Networkmap, Notary and one CordApp.

The docker image is based on Alpine/OpenJDK (https://hub.docker.com/_/openjdk/)

## Usage (automatic way - using docker compose)

* Check Dockerfile and docker-compose.yml (e.g. to adjust version or exposed ports)
* `docker-compose build` - to build base Corda images for Corda Node/Networkmap/Notary
* `docker-compose up` - to spin up all Corda containers (Nodes + Networkmap + Notary)
* `docker exec -it banka /bin/sh` - to log in to one of the running Node containers
* `docker exec -it networkmap /bin/sh` - to log in to the running Networkmap container

## Corda configuration
At the moment java options are put into **corda_docker.env**. All the others are in Dockerfile/docker_compose.yml

If you need to modify Corda parameters (node or/and networkmap) change their configuration file(s) and restart container:
### For Corda node (i.e. banka):
* modify `files/corda-banka.conf`
* restart Corda node: `docker restart banka`
### For Networkmap node:
* modify `files/corda-networkmap.conf`
* restart Corda networkmap: `docker restart networkmap`

## Show installed CordApps
In your web browser open:
* `http://localhost:10024` (for banka)
* `http://localhost:10034` (for bankb)

etc

## Issues
If you get the following message: `<containername> exited with code 137` it's likely because the Linux OOM killer is getting triggered inside of running Docker instance.
Please adjust memory size for Docker environment:
On MacOS: https://docs.docker.com/docker-for-mac/#memory
On Windows: https://docs.docker.com/docker-for-windows/#advanced

## TODO
* add more to README.md (how to customise the build, potential manual spin up without docker compose) 
