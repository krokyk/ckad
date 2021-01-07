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
ifconfig -a
cat /sys/class/dmi/id/product_uuid

lsmod | grep br_netfilter
if [[ "$?" == "1" ]]; then
    echo "###############################################"
    echo "# Adding br_netfilter"
    echo "###############################################"
    modprobe br_netfilter
    lsmod | grep br_netfilter
fi

echo ""
echo "###############################################"
echo "# Letting iptables see bridged traffic"
echo "###############################################"
cat <<EOF | tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

echo ""
echo "###############################################"
echo "# (Install Docker CE)"
echo "# Set up the repository:"
echo "# Install packages to allow apt to use a repository over HTTPS"
echo "###############################################"
apt-get update && apt-get install -y \
  apt-transport-https ca-certificates curl software-properties-common gnupg2
echo ""
echo "###############################################"
echo "# Add Docker's official GPG key:"
echo "###############################################"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -
echo ""
echo "###############################################"
echo "# Add the Docker apt repository:"
echo "###############################################"
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
echo ""
echo "###############################################"
echo "# Install Docker CE"
echo "###############################################"
apt-get update && apt-get install -y \
  containerd.io=1.2.13-2 \
  docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
echo ""
echo "###############################################"
echo "# Set up the Docker daemon"
echo "###############################################"
cat <<EOF | tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
echo ""
echo "###############################################"
echo "# Create /etc/systemd/system/docker.service.d"
echo "###############################################"
mkdir -p /etc/systemd/system/docker.service.d
echo ""
echo "###############################################"
echo "# Restart Docker"
echo "###############################################"
systemctl daemon-reload
systemctl restart docker
echo ""
echo "###############################################"
echo "# Docker will start on boot"
echo "###############################################"
systemctl enable docker

echo ""
echo "###############################################"
echo "# Status of the docker service"
echo "###############################################"
systemctl status docker.service

echo ""
echo "###############################################"
echo "# Installing kubeadm, kubelet and kubectl"
echo "###############################################"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo ""
echo "###############################################"
echo "# Turning swap off..."
echo "###############################################"
swapoff -a
sed -i 's|^\(/swap.*\)|#\1|g' /etc/fstab