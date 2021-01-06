#!/bin/bash

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE:-$0}" )" && pwd ) 

# prevent warning the user needs to answer yes to
ssh-keyscan ckad-master >> ~/.ssh/known_hosts

# copy KUBECONFIG file for cluster
mkdir -p ~/.kube
scp -i "$CKAD_RSA_KEY" ckad@ckad-master:~/.kube/config ~/.kube/config

# rename cluster config name
# default is always generated. See https://github.com/rancher/k3s/blob/f36067760166db0966de43949d0dc2b4a588f3e7/pkg/clientaccess/clientaccess.go#L57 
# sed -i 's/default/k8s/g' ~/config.yaml