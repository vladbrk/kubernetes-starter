#!/bin/bash

echo 'JOIN NODE'

sudo kubeadm join 192.168.0.20:6443 --token egih4v.3laquwc3mivroqoi \
    --discovery-token-ca-cert-hash sha256:0aa42d891f08c7a64c22da2daf54c011c9ca39c6a24c75136ac35255154a1b5f \
    --node-name knode0
#   --node-name knode1
