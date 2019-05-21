#!/bin/bash

kubectl describe secret \
    $(kubectl get secret | grep kube-dashboard-login | cut -f1 -d" ") \
    | grep "^token";
