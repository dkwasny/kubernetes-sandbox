#!/bin/bash

DIR=$(dirname $0);

echo "Installing Heapster";
helm install stable/heapster --tls \
    --name heapster \
    --namespace kube-system \
    --values "$DIR/values.yaml";
