#!/bin/bash

echo "Adding Istio repository";
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.2.2/charts/;

echo "Installing istio-init";
helm install \
    --tls \
    --namespace istio-system \
    istio.io/istio-init;

echo "Installing Istio";
helm install \
    --name istio \
    --namespace istio-system \
    --values install/kubernetes/helm/istio/values-istio-minimal.yaml \
    istio.io/istio;
