#!/bin/bash

DIR=$(dirname $0);

echo "Adding Istio repository";
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.2.2/charts/;

echo "Installing istio-init";
helm install --tls istio.io/istio-init \
    --name istio-init \
    --namespace istio-system;

echo "Installing Istio";
helm install --tls istio.io/istio \
    --name istio \
    --namespace istio-system \
    --values "$DIR/values.yaml";
