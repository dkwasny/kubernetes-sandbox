#!/bin/bash

DIR=$(dirname $0);

echo "Adding Istio repository";
helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.2.2/charts/;

echo "Creating the Kiali secret";
kubectl apply -f "$DIR/kiali-secret.yaml";

echo "Installing istio-init";
helm install --tls istio.io/istio-init \
    --name istio-init \
    --namespace istio-system;

echo "Waiting for istio-init's jobs to finish";
COUNT=0;
while kubectl get job -n istio-system | grep "istio-init.*0/1" > /dev/null; do
    sleep 5;
    if [ $((COUNT += 1)) -gt 20 ]; then
        echo "This is taking too long...";
        exit 1;
    fi;
done;

echo "Installing Istio";
helm install --tls istio.io/istio \
    --name istio \
    --namespace istio-system \
    --values "$DIR/values.yaml";
