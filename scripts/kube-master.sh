#!/bin/bash

echo "Setting up kube-master";

echo "Configuring dnf";
echo "fastestmirror=True" >> /etc/dnf/dnf.conf;

echo "Installing packages";
dnf -y install \
    kubernetes \
    etcd \
    flannel \
    vim-enhanced \
    wget \
    bind-utils;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp /vagrant/secrets/kube-master.pem /etc/secrets/host.pem;
cp /vagrant/secrets/kube-master.key /etc/secrets/host.key;
cp /vagrant/secrets/kube-apiserver.* /etc/secrets/;
cp /vagrant/secrets/service-account-* /etc/secrets/;
cp /vagrant/secrets/kube-coredns.* /etc/secrets/;
chmod 644 /etc/secrets/*;

echo "Installing CoreDNS";
wget -q -O /tmp/coredns.tgz "https://github.com/coredns/coredns/releases/download/v1.5.0/coredns_1.5.0_linux_amd64.tgz";
tar -x -f /tmp/coredns.tgz -C /usr/bin/;
chmod 755 /usr/bin/coredns;
wget -q -O /etc/systemd/system/coredns.service "https://raw.githubusercontent.com/coredns/deployment/master/systemd/coredns.service";
useradd -r -s /sbin/nologin -d / coredns;

echo "Configuring CoreDNS";
mkdir /etc/coredns/;
cp /vagrant/coredns/* /etc/coredns/;

echo "Starting CoreDNS";
systemctl enable --now coredns;

echo "Reconfigure system DNS client";
cp /vagrant/no-dns.conf /etc/NetworkManager/conf.d/;
systemctl restart NetworkManager;
cp /vagrant/resolv.conf /etc/resolv.conf;

echo "Waiting for CoreDNS to spin up";
RESP="";
COUNT=0;
while [ "$RESP" != "200" ]; do
    RESP=$(curl -w "%{http_code}" -o /dev/null kube-master.kwas-cluster.local:8931/health 2>/dev/null);
    if [ $((COUNT += 1)) -gt 20 ]; then
        echo "CoreDNS isn't coming up...";
        exit 1;
    fi;
    sleep 1;
done;

echo "Configuring etcd";
cp /vagrant/etcd.conf /etc/etcd/etcd.conf;

echo "Starting etcd";
systemctl enable --now etcd;

# Fedora comes with Flannel 0.9.0 which is incompatible with Kubernetes 1.13 and above.
# https://github.com/coreos/flannel/blob/v0.9.1/Documentation/troubleshooting.md#connectivity
# Use `cat` to retain all the stupid SELinux properties of the original file.
echo "Updating Flannel";
wget -q -O /tmp/flannel.tar.gz "https://github.com/coreos/flannel/releases/download/v0.9.1/flannel-v0.9.1-linux-amd64.tar.gz";
tar -x -f /tmp/flannel.tar.gz -C /tmp;
cat /tmp/flanneld > /usr/bin/flanneld;

echo "Configuring Flannel";
cp /vagrant/sysconfig-flanneld /etc/sysconfig/flanneld;
# Flannel is slow to update to the etcdctl v3 API.
# I don't think you can write data with the v3 API to be read with thew v2 API.
# Force the use of the v2 API until flannel breaks...again.
# https://github.com/coreos/flannel/issues/554
export ETCDCTL_API=2;
etcdctl \
    --ca-file /etc/secrets/ca.pem \
    --cert-file /etc/secrets/host.pem \
    --key-file /etc/secrets/host.key \
    --endpoints https://kube-master.kwas-cluster.local:2379 \
    mkdir /kwas-flannel;
etcdctl \
    --ca-file /etc/secrets/ca.pem \
    --cert-file /etc/secrets/host.pem \
    --key-file /etc/secrets/host.key \
    --endpoints https://kube-master.kwas-cluster.local:2379 \
    set /kwas-flannel/config < /vagrant/etcd-flannel.json;

echo "Starting Flannel";
systemctl enable --now flanneld;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;

echo "Starting Kubernetes";
systemctl enable --now kube-apiserver;
systemctl enable --now kube-controller-manager;
systemctl enable --now kube-scheduler;
systemctl enable --now kube-proxy;

echo "Configuring base Kubernetes users";
kubectl create clusterrolebinding kube-admin-cluster-admin \
    --clusterrole cluster-admin \
    --user kube-admin;
# TODO: make dynamic based on nodes...or not
kubectl create clusterrolebinding kube-master-cluster-admin \
    --clusterrole cluster-admin \
    --user kube-master.kwas-cluster.local;
kubectl create clusterrolebinding kube-node-1-cluster-admin \
    --clusterrole cluster-admin \
    --user kube-node-1.kwas-cluster.local;
