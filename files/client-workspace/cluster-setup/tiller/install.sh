#!/bin/bash

DIR=$(dirname $0);

echo "Creating service account";
kubectl apply -f "$DIR/service-account.yaml";

echo "Installing tiller";
helm init \
    --service-account tiller \
    --tiller-tls \
    --tiller-tls-verify \
    --tiller-tls-cert /etc/secrets/kube-tiller.pem \
    --tiller-tls-key /etc/secrets/kube-tiller.key \
    --tiller-tls-ca-cert /etc/secrets/ca.pem;
