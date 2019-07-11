#!/bin/bash

DIR=$(dirname $0);

echo "Creating service account";
kubectl apply -f "$DIR/service-account.yaml";

echo "Installing tiller";
helm init \
    --service-account tiller \
    --tiller-tls \
    --tiller-tls-verify \
    --tiller-tls-cert /etc/secrets/tiller.pem \
    --tiller-tls-key /etc/secrets/tiller.key \
    --tls-ca-cert /etc/secrets/ca.pem;

echo "Linking client certs";
ln -s /etc/secrets/host.pem ~/.helm/cert.pem;
ln -s /etc/secrets/host.key ~/.helm/key.pem;
