#!/bin/bash

# Add the wildcard certificate to every namespace that uses ingress.
# Ingresses don't support cross-namespace secrets.

DIR=$(dirname $0);

NAMESPACES="
    kube-system
    default
    istio-system
";

for NAMESPACE in $NAMESPACES; do
    echo "Ensuring namespace exists";
    kubectl create namespace "$NAMESPACE";

    echo "Installing wildcard secret to $NAMESPACE";
    kubectl create secret tls wildcard-ingress-secret \
        --key /etc/secrets/ingress-wildcard.key \
        --cert /etc/secrets/ingress-wildcard.pem \
        --namespace "$NAMESPACE";
done;
