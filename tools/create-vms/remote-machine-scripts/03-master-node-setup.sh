#!/bin/bash
#login as REGULAR user on your MASTER node
#type 'cat > 03-node-setup.sh'
#paste the content of this file in your terminal
#CTRL+C
#run ./03-node-setup.sh
if [ "$(id -u)" == "0" ]; then
    echo ""
    echo "###############################################"
    echo "# This script must NOT be run as root" 1>&2
    echo "###############################################"
    exit 1
fi

echo "$1" | sudo -S echo "Got correct password for sudo, good!"
if [[ "$?" != "0" ]]; then
    echo "Incorrect password for sudo!"
    exit 1
fi
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo usermod -aG docker $USER
sudo newgrp docker

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml