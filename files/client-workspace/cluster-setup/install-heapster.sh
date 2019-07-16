#!/bin/bash

echo "Installing Heapster";
helm install stable/heapster --tls \
    --name heapster \
    --namespace kube-system;
