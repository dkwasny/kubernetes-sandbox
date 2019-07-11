#!/bin/bash

echo "Setting up kube-client";

echo "Installing packages";
dnf -y install \
    kubernetes-client \
    vim-enhanced \
    wget \
    bind-utils;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp /vagrant/secrets/kube-client.pem /etc/secrets/host.pem;
cp /vagrant/secrets/kube-client.key /etc/secrets/host.key;
cp /vagrant/secrets/kube-admin.* /etc/secrets/;
cp /vagrant/secrets/tiller.* /etc/secrets/;
cp /vagrant/secrets/ingress-wildcard.* /etc/secrets/;
chmod 644 /etc/secrets/*;

echo "Reconfigure system DNS client";
cp /vagrant/no-dns.conf /etc/NetworkManager/conf.d/;
systemctl restart NetworkManager;
cp /vagrant/resolv.conf /etc/resolv.conf;

echo "Setting up workspace";
ln -s /vagrant/client-workspace /home/vagrant/workspace;

echo "Installing helm";
HELM_TAR="/tmp/helm.tar.gz";
wget -q -O "$HELM_TAR" https://get.helm.sh/helm-v2.14.1-linux-amd64.tar.gz;
tar -x -f "$HELM_TAR" -C /tmp;
cp /tmp/linux-amd64/helm /usr/bin/helm;
