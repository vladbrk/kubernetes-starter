#!/bin/bash

echo 'INIT MASTER'

sudo kubeadm init --kubernetes-version=v1.16.1 --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo sysctl net.bridge.bridge-nf-call-iptables=1
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.12.0/Documentation/kube-flannel.yml


echo 'DEPLOY APP'
echo '1. CREATE SECRET'

export DOCKER_REGISTRY_SERVER=docker.io
export DOCKER_USER=${docker_user}
export DOCKER_EMAIL=${docker_email}
export DOCKER_PASSWORD=${docker_password}

kubectl create secret docker-registry myregistrykey \
  --docker-server=$DOCKER_REGISTRY_SERVER \
  --docker-username=$DOCKER_USER \
  --docker-password=$DOCKER_PASSWORD \
  --docker-email=$DOCKER_EMAIL


echo '2. CREATE DEPLOYMENT'

kubectl run k8s-app --image=vladbrk/k8s-app:v1 --port=8080 --overrides='{ "spec": { "imagePullSecrets": [{"name": "myregistrykey"}] } }'

echo '3. EXPOSE APP'
kubectl expose deployment/k8s-app --type="NodePort" --port 8080

#kubectl describe service/k8s-app | grep NodePort
#kubectl describe service kubernetes | grep Endpoints
#http://192.168.0.20:30781/return/qwe

# GKE
# kubectl expose deployment/k8s-app --type="LoadBalancer" --port 8080
# kubectl describe services/k8s-app | grep "LoadBalancer Ingress:"
# http://35.194.115.189:8080/return/qwe

#kubectl expose deployment/k8s-app --type="LoadBalancer" --port=8080 --target-port=8080
#kubectl expose deployment/k8s-app --type="Ingress" --port=8080 --target-port=8080

#kubectl scale --replicas=2 deployment/k8s-app