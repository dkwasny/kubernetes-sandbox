#!/bin/bash

DIR=$(dirname $0);

echo "Creating configmap";
kubectl create configmap kwas-dashboard-configmap \
    --from-file "$DIR/kubeconfig.yaml" \
    --namespace kube-system;

echo "Creating the dashboard secret";
kubectl create secret generic kwas-dashboard-secret \
    --from-file /etc/secrets/kube-dashboard.pem \
    --from-file /etc/secrets/kube-dashboard.key \
    --from-file /etc/secrets/ca.pem \
    --namespace kube-system;

echo "Creating the dashboard login service account and role binding";
kubectl apply -f "$DIR/login-account.yaml";

echo "Deploying the dashboard";
kubectl apply -f "$DIR/dashboard.yaml";

echo "Deploying the nodeport service";
kubectl apply -f "$DIR/nodeport-service.yaml";
