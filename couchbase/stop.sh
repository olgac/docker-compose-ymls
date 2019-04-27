#!/bin/bash

echo "$(date) Removing CouchBase"
docker stack rm couchbase

echo "$(date) Removing CouchBase stack"
while true; do docker container ls | grep -Fq couchbase; if [ $? -ne 0 ]; then echo -e "\n$(date) Stack is REMOVED!"; sleep 2; break; fi; printf  "."; sleep 1; done

echo "$(date) Removing CouchBase volume"
docker volume rm couchbase_couchbase-data

echo "$(date) Removing stopped container(s)"
docker container prune -f

#docker rmi -f $(docker images -f "dangling=true" -q)
echo "$(date) CouchBase is REMOVED!"