#!/bin/bash

bash <(curl https://raw.githubusercontent.com/krustlet/krustlet/main/scripts/bootstrap.sh)

export IP=`ifconfig eth0 | awk '/inet / {print $2}'`
sleep 5 && kubectl certificate approve $IP-tls &
KUBECONFIG=~/.kube/config KRUSTLET_NODE_NAME=krustlet bin/krustlet-wasi --node-ip $IP --hostname $IP --insecure-registries localhost:12345 --port 3000 --bootstrap-file ~/.krustlet/config/bootstrap.conf
