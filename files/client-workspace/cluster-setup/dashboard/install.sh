#!/bin/bash

DIR=$(dirname $0);

echo "Creating the dashboard login service account and role binding";
kubectl apply -f "$DIR/login-account.yaml";

echo "Deploying the dashboard";
kubectl apply -f "$DIR/dashboard.yaml";

echo "Creating the ingress entry";
kubectl apply -f "$DIR/ingress.yaml";
