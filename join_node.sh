#!/bin/bash

echo 'JOIN NODE'

sudo kubeadm join 192.168.0.21:6443 --token melyyf.klcqlyl472wmsfev \
    --discovery-token-ca-cert-hash sha256:2a41ef08f44bbf5ba57d034e9810886e8a8177c22f072e2327b9cf09989d1faf \
    --node-name knode0
#   --node-name knode1
