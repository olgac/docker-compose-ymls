#!/bin/bash

echo "$(date) Removing Portainer"
docker stack rm portainer

echo "$(date) Removing stopped container(s)"
docker container prune -f

#docker rmi -f $(docker images -f "dangling=true" -q)
echo "$(date) Portainer is REMOVED!"