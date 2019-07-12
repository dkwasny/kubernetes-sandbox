#!/bin/bash

echo "Adding Istio repository";
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.2.2/charts/;

echo "Installing istio-init";
helm install \
    --tls \
    --name istio-init \
    --namespace istio-system \
    istio.io/istio-init;

echo "Installing Istio";
helm install \
    --tls \
    --name istio \
    --namespace istio-system \
    istio.io/istio;
