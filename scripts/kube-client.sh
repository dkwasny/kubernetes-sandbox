#!/bin/bash

echo "Setting up kube-client";

echo "Installing packages";
dnf -y install kubernetes-client;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp /vagrant/secrets/kube-client.pem /etc/secrets/host.pem;
cp /vagrant/secrets/kube-client.key /etc/secrets/host.key;
chmod 644 /etc/secrets/*;

echo "Setting up workspace";
ln -s /vagrant/client-workspace /home/vagrant/workspace;
