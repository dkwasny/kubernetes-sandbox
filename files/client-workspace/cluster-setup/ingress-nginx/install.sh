#!/bin/bash

DIR=$(dirname $0);

echo "Installing nginx-ingress";
helm install --tls stable/nginx-ingress \
    -n nginx-ingress \
    -f "$DIR/values.yaml";
