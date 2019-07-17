#!/bin/bash

DIR=$(dirname $0)/cluster-setup;

echo "Configuring kubectl";
"$DIR/../setup-kubectl.sh";

echo "Setting up the CoreDNS user and role";
kubectl apply -f "$DIR/coredns.yaml";

echo "Installing the wildcard ingress secret";
"$DIR/install-wildcard-certificate.sh";

echo "Installing tiller";
"$DIR/tiller/install.sh";

echo "Installing the Ingress Controller";
"$DIR/ingress-nginx/install.sh";

echo "Installing the Kubernetes dashboard";
"$DIR/dashboard/install.sh";

echo "Installing the container registry";
"$DIR/docker-registry/install.sh";

echo "Installing Heapster";
"$DIR/heapster/install.sh";

# TODO: Not yet
#echo "Installing Istio";
#"$DIR/install-istio.sh";
