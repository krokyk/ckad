#!/bin/bash

#sudo apt-get install sshpass
sshpass -p root ssh root@ckad-master "bash -s" -- < remote-machine-scripts/01-master-and-worker-node-setup.sh
sshpass -p root ssh root@ckad-master "bash -s" -- < remote-machine-scripts/02-master-node-setup.sh