#!/bin/bash

echo "$(date) Removing GitLab"
docker stack rm gitlab

echo "$(date) Removing GitLab stack"
while true; do docker container ls | grep -Fq gitlab; if [ $? -ne 0 ]; then echo "$(date) Stack is REMOVED!"; sleep 5; break; fi; printf  "."; sleep 1; done

echo "$(date) Removing GitLab volume"
docker volume rm gitlab_gitlab-config
docker volume rm gitlab_gitlab-data
docker volume rm gitlab_gitlab-logs

echo "$(date) Removing stopped container(s)"
docker container prune -f

#docker rmi -f $(docker images -f "dangling=true" -q)
echo "$(date) GitLab is REMOVED!"