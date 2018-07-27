#!/bin/bash

kubectl config set-cluster kwas --server=http://10.200.0.10:8080 --insecure-skip-tls-verify=true;
kubectl config set-context kwas --cluster=kwas;
kubectl config use-context kwas;
