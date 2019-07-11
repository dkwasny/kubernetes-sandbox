#!/bin/bash

helm install \
    --tls \
    --namespace istio-system \
    istio.io/istio-init;

helm install \
    --name istio \
    --namespace istio-system \
    --values install/kubernetes/helm/istio/values-istio-minimal.yaml \
    istio.io/istio;
