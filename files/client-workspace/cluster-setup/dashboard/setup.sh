#!/bin/bash

DIR=$(dirname $0);

echo "Creating configmap";
kubectl create configmap kwas-dashboard-configmap \
    --from-file "$DIR/kubeconfig.yaml" \
    --namespace kube-system;

echo "Creating secret";
kubectl create secret generic kwas-dashboard-secret \
    --from-file /etc/secrets/kwas-dashboard.pem \
    --from-file /etc/secrets/kwas-dashboard.key \
    --from-file /etc/secrets/ca.pem \
    --namespace kube-system;

echo "Adding cluster role binding";
kubectl create clusterrolebinding dashboard \
    --clusterrole cluster-admin \
    --user kwas-dashboard;

echo "Deploying the dashboard";
kubectl apply -f "$DIR/dashboard.yaml";
