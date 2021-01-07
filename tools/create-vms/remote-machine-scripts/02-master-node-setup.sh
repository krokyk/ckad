#!/bin/bash
#login as ROOT user on ALL your nodes
#type 'cat > 01-node-setup.sh'
#paste the content of this file in your terminal
#CTRL+C
#run ./01-node-setup.sh
if [ "$(id -u)" != "0" ]; then
    echo ""
    echo "###############################################"
    echo "# This script must be run as root" 1>&2
    echo "###############################################"
    exit 1
fi

ipaddress=$(ip -4 addr show dev eth0 | grep inet | tr -s " " | cut -d" " -f3 | sed  "s|\([0-9\.]\+\).*|\1|g")
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$ipaddress

echo ""
echo "###########################################"
echo "# Save the joining command from above and after you"
echo "# are finished with the 03-node-setup.sh script"
echo "# you will run it on the worker node(s)"
echo "###########################################"

echo "kubeadm join 192.168.88.3:6443 --token 4nazim.dpmmx3rnlcufbvlf \\"
echo "    --discovery-token-ca-cert-hash sha256:b09fa33f71ddde9506229b83120f2bdbbd132676700637a998d94ebaec80a1be"

echo "You can generate new join command by running:"
echo "kubeadm token create --print-join-command"