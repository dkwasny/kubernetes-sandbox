#!/bin/bash

echo "Setting up kube-client";

echo "Installing packages";
dnf -y install kubernetes-client;

echo "Setting up workspace";
ln -s /vagrant/client-workspace /home/vagrant/workspace;
