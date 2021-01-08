#!/bin/bash

echo ">>>>> Removing all images..."
#remove all images
docker rmi $(docker images -q)
