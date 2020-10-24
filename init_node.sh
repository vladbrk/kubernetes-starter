#!/bin/bash

echo 'INIT NODE'

sudo apt-get update
sudo apt-get install -y net-tools

sudo swapoff -a

sudo apt-get install -y docker.io
sudo bash -c 'cat <<EOF >/etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "bip": "172.26.0.1/22"
}
EOF'

# Install Docker CE
## Set up the repository:
### Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
### Add Docker apt repository.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
## Install Docker CE.
#sudo apt-get update && sudo apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 18.06 | head -1 | awk '{print $3}') # doesnot works in Ubuntu 20
#sudo apt-get update && sudo apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 5:19.03.13~3-0~ubuntu-focal | head -1 | awk '{print $3}')
sudo apt-get update && sudo apt-get install -y docker-ce=$(apt-cache madison docker-ce | head -1 | awk '{print $3}')


# Install Kubelet, Kubeadm, Kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF'
sudo apt-get update && sudo apt-get install -y kubelet=1.19.2-00 kubeadm=1.19.2-00 kubectl=1.19.2-00
sudo apt-mark hold kubelet kubeadm kubectl

# Restart
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# KUBEADM VERSIONS
# curl -s https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages | grep Version | awk '{print $2}'


