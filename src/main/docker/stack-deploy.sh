#!/bin/bash
echo "Deploying stack srv-discovery..."
docker stack deploy -c docker-stack.yml --with-registry-auth srv-discovery
echo "Stack deployed!"
