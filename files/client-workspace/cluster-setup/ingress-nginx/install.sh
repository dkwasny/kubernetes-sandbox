#!/bin/bash

DIR=$(dirname $0);

echo "Installing nginx-ingress";
helm install --tls stable/nginx-ingress \
    --name nginx-ingress \
    --namespace kube-system \
    --values "$DIR/values.yaml";
