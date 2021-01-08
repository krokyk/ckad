#!/bin/bash

echo ">>>>> Removing all volumes..."
#remove all volumes
docker volume rm $(docker volume ls -q)
