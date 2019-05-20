#!/bin/bash

DIR=$(dirname $0);

echo "Creating configmap";
kubectl create configmap kwas-coredns-configmap \
    --from-file "$DIR/kubeconfig.yaml" \
    --namespace kube-system;

echo "Creating secret";
kubectl create secret generic kwas-coredns-secret \
    --from-file /etc/secrets/coredns.pem \
    --from-file /etc/secrets/coredns.key \
    --from-file /etc/secrets/ca.pem \
    --namespace kube-system;

echo "Deploying CoreDNS";
kubectl apply -f "$DIR/coredns.yaml";
