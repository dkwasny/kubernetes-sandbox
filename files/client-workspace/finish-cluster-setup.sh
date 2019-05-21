#!/bin/bash

DIR=$(dirname $0)/cluster-setup;

echo "Setting up the CoreDNS user and role";
kubectl apply -f "$DIR/coredns.yaml";

echo "Installing the Kubernetes dashboard";
"$DIR/dashboard/install.sh";
