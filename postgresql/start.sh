#!/bin/bash

#echo "127.0.0.1		postgresql" | sudo tee -a /etc/hosts

ROOT_PATH=$(dirname "$0")

echo "$(date) Initializing swarm mode"
docker swarm init 2>/dev/null

echo "$(date) Creating overlay network"
docker network create --driver=overlay --attachable local

echo "$(date) Deploying service"
docker stack deploy -c $ROOT_PATH/docker-compose.yml postgresql

echo "$(date) PostgreSQL is READY!"