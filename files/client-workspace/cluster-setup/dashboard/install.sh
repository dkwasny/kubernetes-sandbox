#!/bin/bash

DIR=$(dirname $0);

echo "Installing the dashboard";
helm install --tls stable/kubernetes-dashboard \
    --name kubernetes-dashboard \
    --namespace kube-system \
    --values "$DIR/values.yaml";

echo "Creating the dashboard login service account and role binding";
kubectl apply -f "$DIR/login-account.yaml";

