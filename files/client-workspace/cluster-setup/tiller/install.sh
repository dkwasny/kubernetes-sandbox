#!/bin/bash

DIR=$(dirname $0);

echo "Creating service account";
kubectl apply -f "$DIR/service-account.yaml";

echo "Installing Tiller";
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

echo "Waiting for Tiller pod to initialize";
COUNT=0;
while ! helm list --tls >/dev/null 2>&1; do
    sleep 5;
    if [ $((COUNT += 1)) -gt 20 ]; then
        echo "Tiller isn't coming up...";
        exit 1;
    fi;
done;
