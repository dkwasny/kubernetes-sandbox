#!/bin/bash

kubectl config set-cluster kwas --server=http://kube-master:8080 --insecure-skip-tls-verify=true;
kubectl config set-context kwas --cluster=kwas;
kubectl config use-context kwas;
