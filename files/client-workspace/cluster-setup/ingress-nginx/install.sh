#!/bin/bash

DIR=$(dirname $0);

echo "Creating the namespace";
kubectl apply -f "$DIR/namespace.yaml";

echo "Deploying ingress-nginx.yaml";
kubectl apply -f "$DIR/ingress-nginx.yaml";

echo "Deploying the nodeport service";
kubectl apply -f "$DIR/nodeport-service.yaml";
