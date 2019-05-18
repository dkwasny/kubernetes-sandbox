#!/bin/bash

USER="$1";

if [ -z "$USER" ]; then
    echo "Please provide a user";
    exit 1;
elif [ ! -r "/etc/secrets/$1.key" ]; then
    echo "Invalid user: $1";
    exit 1;
fi;

kubectl config set-cluster kube-cluster \
    --server=https://kube-master:6443 \
    --certificate-authority=/etc/secrets/ca.pem;

kubectl config set-credentials "$USER" \
    "--client-certificate=/etc/secrets/$USER.pem" \
    "--client-key=/etc/secrets/$USER.key";

kubectl config set-context "$USER" \
    --cluster=kube-cluster \
    "--user=$USER";

kubectl config use-context "$USER";
