#!/bin/bash

ssh -i "$CKAD_RSA_KEY" ckad@ckad-master  "bash -s -- ckad" < remote-machine-scripts/03-master-node-setup.sh