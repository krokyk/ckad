#!/bin/bash

sshpass -p root ssh root@ckad-worker "bash -s" -- < remote-machine-scripts/01-master-and-worker-node-setup.sh