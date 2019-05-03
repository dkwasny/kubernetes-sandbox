#!/bin/bash

kubectl config set-cluster kube-cluster \
    --server=https://kube-master:6443 \
    --certificate-authority=/etc/secrets/ca.pem;

kubectl config set-credentials kube-user \
    --client-certificate=/etc/secrets/host.pem \
    --client-key=/etc/secrets/host.key;

kubectl config set-context master \
    --cluster=kube-cluster \
    --user=kube-user;

kubectl config use-context master;
