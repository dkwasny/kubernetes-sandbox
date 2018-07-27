#!/bin/bash

NODE_ID="$1";

echo "Setting up kube-node-$NODE_ID";

echo "Installing packages";
yum -y install \
	bridge-utils \
	kubernetes;

echo "Configuring network";
BRIDGE_FILE="/etc/sysconfig/network-scripts/ifcfg-br0";
cp /vagrant/ifcfg-br0.template "$BRIDGE_FILE";
sed --in-place "s/{id}/$NODE_ID/g" "$BRIDGE_FILE";
echo "BRIDGE=br0" >> /etc/sysconfig/network-scripts/ifcfg-eth1;

echo "Shutting down eth1";
ifdown eth1;

echo "Starting br0";
ifup br0;

echo "Starting eth1";
ifup eth1;

echo "Configuring Docker";
cp /vagrant/docker/daemon.json /etc/docker/daemon.json;

echo "Starting Docker";
systemctl enable --now docker;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;
sed --in-place "s/{id}/$NODE_ID/g" /etc/kubernetes/kubelet;

echo "Starting Kubernetes";
systemctl enable --now kubelet;
systemctl enable --now kube-proxy;
