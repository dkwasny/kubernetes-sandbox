#!/bin/bash

DIR=$(dirname $0);

echo "Installing CoreDNS";
kubectl apply -f "$DIR/coredns.yaml";

echo "Installing Kubernetes Dashboard";
"$DIR/dashboard/setup.sh";
