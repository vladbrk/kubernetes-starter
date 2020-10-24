#!/bin/bash

source common.sh

nodes=(${knodes[@]} ${k8s_master})

for node in ${nodes[@]}
do
    sshpass -p "${pass}" ssh -o StrictHostKeyChecking=no kadmin@${node} << EOS
    # clear directory
    rm *
    echo ${pass} | sudo -S apt-get update
EOS
done

# Copy init files to hosts
for ((i=0 ; i<${#nodes[@]}; i++))
do  
    sshpass -p "${pass}" scp ./common.sh kadmin@${nodes[i]}:~
    sshpass -p "${pass}" scp ./init_node.sh kadmin@${nodes[i]}:~
done
sshpass -p "${pass}" scp ./init_master.sh kadmin@${k8s_master}:~
sshpass -p "${pass}" scp ./k8s-app.deployment.yaml kadmin@${k8s_master}:~

# Open terminal ssh'ed to hosts
for ((i=0 ; i<${#nodes[@]}; i++))
do
    gnome-terminal -e "sshpass -p ${pass} ssh kadmin@${nodes[i]}"
done

