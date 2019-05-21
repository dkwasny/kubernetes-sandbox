#!/bin/bash

kubectl config set-cluster kube-cluster \
    --server=https://kube-master.kwas-cluster.local:6443 \
    --certificate-authority=/etc/secrets/ca.pem;

kubectl config set-credentials kube-admin \
    --client-certificate=/etc/secrets/kube-admin.pem \
    --client-key=/etc/secrets/kube-admin.key;

kubectl config set-context kube-admin \
    --cluster=kube-cluster \
    --user=kube-admin;

kubectl config use-context kube-admin;
