#!/bin/bash

DIR=$(dirname $0);

echo "Creating the namespace";
kubectl apply -f "$DIR/namespace.yaml";

echo "Creating custom configmap";
kubectl create configmap kwas-ingress-nginx-configmap \
    --from-file "$DIR/kubeconfig.yaml" \
    --namespace ingress-nginx;

echo "Creating custom secrets";
kubectl create secret generic kwas-ingress-nginx-secret \
    --from-file /etc/secrets/kube-ingress-nginx.pem \
    --from-file /etc/secrets/kube-ingress-nginx.key \
    --from-file /etc/secrets/ca.pem \
    --namespace ingress-nginx;

echo "Deploying ingress-nginx.yaml";
kubectl apply -f "$DIR/ingress-nginx.yaml";

echo "Deploying the nodeport service";
kubectl apply -f "$DIR/nodeport-service.yaml";
