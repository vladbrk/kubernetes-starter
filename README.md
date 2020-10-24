# kubernetes-starter
Bootstrapping Kubernetes clusters 1.19 with kubeadm on Ubuntu 20.04

#Requirements
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

# Create host(kmaster, knode0, knode1) in VMware Workstation Player 
- ISO: ubuntu-20.04.1-live-server-amd64.iso
- username/password: kadmin/123
- CPU: 1 for nodes, 2 for master
> 2 CPU obligatory for master: [ERROR NumCPU]: the number of available CPUs 1 is less than the required 2
- Memory: 1GB
- Network Connection: Bridged Connected directly to the physical network

- username: kadmin
- password: 123
- install SSH

# Prepare local host
- sudo apt update && sudo apt install -y sshpass
- Writes host ids to common.sh

# Prepare k8s-app in hub.docker.com

# Execute sh
- run locally ./prepare_nodes.sh
- run on all hosts ./init_node.sh
- run on kmaster ./init_master.sh
- copy command from kmaster to join_node.sh
- join knode0, knode1 using command from ./join_node.sh
