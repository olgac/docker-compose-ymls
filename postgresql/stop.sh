#!/bin/bash

echo "$(date) Removing PostgreSQL"
docker stack rm postgresql

echo "$(date) Removing stopped container(s)"
docker container prune -f

#docker rmi -f $(docker images -f "dangling=true" -q)
echo "$(date) PostgreSQL is REMOVED!"