#!/bin/bash

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd ) 

# prevent warning the user needs to answer yes to
ssh-keyscan ckad-worker >> ~/.ssh/known_hosts

# copy KUBECONFIG file for cluster
ssh -i "$CKAD_RSA_KEY" ckad@ckad-worker