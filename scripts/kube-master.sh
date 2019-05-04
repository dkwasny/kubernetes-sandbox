#!/bin/bash

echo "Setting up kube-master";

echo "Installing packages";
dnf -y install \
	kubernetes \
	etcd \
	flannel;

echo "Copying secrets";
mkdir /etc/secrets;
cp /vagrant/secrets/ca.pem /etc/secrets/ca.pem;
cp /vagrant/secrets/kube-master.pem /etc/secrets/host.pem;
cp /vagrant/secrets/kube-master.key /etc/secrets/host.key;
cp /vagrant/secrets/service-account-* /etc/secrets/;
chmod 644 /etc/secrets/*;

echo "Configuring etcd";
cp /vagrant/etcd.conf /etc/etcd/etcd.conf;

echo "Starting etcd";
systemctl enable --now etcd;

echo "Configuring Flannel";
cp /vagrant/sysconfig-flanneld /etc/sysconfig/flanneld;
etcdctl \
    --ca-file /etc/secrets/ca.pem \
    --cert-file /etc/secrets/host.pem \
    --key-file /etc/secrets/host.key \
    --endpoints https://kube-master:2379 \
    mkdir /kwas-flannel;
etcdctl \
    --ca-file /etc/secrets/ca.pem \
    --cert-file /etc/secrets/host.pem \
    --key-file /etc/secrets/host.key \
    --endpoints https://kube-master:2379 \
    set /kwas-flannel/config < /vagrant/etcd-flannel.json;

echo "Starting Flannel";
systemctl enable --now flanneld;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;

echo "Starting Kubernetes";
systemctl enable --now kube-apiserver;
systemctl enable --now kube-controller-manager;
systemctl enable --now kube-scheduler;
