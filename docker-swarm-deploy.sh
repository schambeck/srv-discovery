#!/bin/bash
echo "Deploying srv-discovery application to the Docker Swarm..."
docker stack deploy -c <(cd src/main/docker && docker-compose config) srv-discovery
echo "Application deployed!"
