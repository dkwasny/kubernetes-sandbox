#!/bin/bash

kubectl config set-cluster master --server=http://kube-master:8080 --insecure-skip-tls-verify=true;
kubectl config set-context master --cluster=master;
kubectl config use-context master;
