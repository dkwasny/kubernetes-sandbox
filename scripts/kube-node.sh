#!/bin/bash

NODE_ID="$1";

echo "Setting up kube-node-$NODE_ID";

echo "Installing packages";
dnf -y install \
    bridge-utils \
    kubernetes \
    flannel \
    vim-enhanced;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp "/vagrant/secrets/kube-node-$NODE_ID.pem" /etc/secrets/host.pem;
cp "/vagrant/secrets/kube-node-$NODE_ID.key" /etc/secrets/host.key;
chmod 644 /etc/secrets/*;

echo "Configuring Flannel";
cp /vagrant/sysconfig-flanneld /etc/sysconfig/flanneld;

echo "Starting Flannel";
systemctl enable --now flanneld;

echo "Configuring Docker";
cp /vagrant/sysconfig-docker /etc/sysconfig/docker;

echo "Starting Docker";
systemctl enable --now docker;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;
sed --in-place "s/{id}/$NODE_ID/g" /etc/kubernetes/kubelet;

echo "Starting Kubernetes";
systemctl enable --now kubelet;
systemctl enable --now kube-proxy;
