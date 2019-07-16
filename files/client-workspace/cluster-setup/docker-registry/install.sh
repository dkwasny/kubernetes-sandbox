#!/bin/bash

DIR=$(dirname $0);

echo "Installing the container registry";
helm install --tls stable/docker-registry \
    --name docker-registry \
    --namespace kube-system \
    --values "$DIR/values.yaml";
