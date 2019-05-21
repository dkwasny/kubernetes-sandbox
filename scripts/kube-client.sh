#!/bin/bash

echo "Setting up kube-client";

echo "Installing packages";
dnf -y install kubernetes-client vim-enhanced;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp /vagrant/secrets/kube-client.pem /etc/secrets/host.pem;
cp /vagrant/secrets/kube-client.key /etc/secrets/host.key;
cp /vagrant/secrets/kube-admin.* /etc/secrets/;
cp /vagrant/secrets/kube-dashboard.* /etc/secrets/;
chmod 644 /etc/secrets/*;

echo "Reconfigure system DNS client";
cp /vagrant/no-dns.conf /etc/NetworkManager/conf.d/;
systemctl restart NetworkManager;
cp /vagrant/resolv.conf /etc/resolv.conf;

echo "Setting up workspace";
ln -s /vagrant/client-workspace /home/vagrant/workspace;
