#!/bin/bash

DIR=$(dirname $0)/cluster-setup;

echo "Setting up the CoreDNS user and role";
kubectl apply -f "$DIR/coredns.yaml";

echo "Installing the wildcard ingress secret";
kubectl create secret tls wildcard-ingress-secret \
    --key /etc/secrets/ingress-wildcard.key \
    --cert /etc/secrets/ingress-wildcard.pem;

echo "Installing the Ingress Controller";
"$DIR/ingress-nginx/install.sh";

echo "Installing the Kubernetes dashboard";
"$DIR/dashboard/install.sh";
