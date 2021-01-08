#!/bin/bash

#stop all running containers
echo ">>>>> Stopping all running containers..."
docker stop $(docker ps -q)

echo ">>>>> Removing all stopped containers..."
#remove all stopped containers
docker rm -f $(docker ps -a -q)
