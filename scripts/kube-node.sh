#!/bin/bash

NODE_ID="$1";

echo "Setting up kube-node-$NODE_ID";

echo "Configuring dnf";
echo "fastestmirror=True" >> /etc/dnf/dnf.conf;

echo "Installing packages";
dnf -y install \
    bridge-utils \
    kubernetes \
    flannel \
    vim-enhanced \
    bind-utils \
    wget;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp "/vagrant/secrets/kube-node-$NODE_ID.pem" /etc/secrets/host.pem;
cp "/vagrant/secrets/kube-node-$NODE_ID.key" /etc/secrets/host.key;
chmod 644 /etc/secrets/*;

echo "Installing ca.crt to /etc/docker/certs.d";
mkdir /etc/docker/certs.d/registry.kube-ingress.local:30443;
ln -s /etc/secrets/ca.pem /etc/docker/certs.d/registry.kube-ingress.local:30443/ca.crt;

echo "Reconfigure system DNS client";
cp /vagrant/no-dns.conf /etc/NetworkManager/conf.d/;
systemctl restart NetworkManager;
cp /vagrant/resolv.conf /etc/resolv.conf;

# Fedora comes with Flannel 0.9.0 which is incompatible with Kubernetes 1.13 and above.
# https://github.com/coreos/flannel/blob/v0.9.1/Documentation/troubleshooting.md#connectivity
# Use `cat` to retain all the stupid SELinux properties of the original file.
echo "Updating Flannel";
wget -q -O /tmp/flannel.tar.gz "https://github.com/coreos/flannel/releases/download/v0.9.1/flannel-v0.9.1-linux-amd64.tar.gz";
tar -x -f /tmp/flannel.tar.gz -C /tmp;
cat /tmp/flanneld > /usr/bin/flanneld;

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
