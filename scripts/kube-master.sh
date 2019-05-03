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
chmod 644 /etc/secrets/*;

echo "Configuring etcd";
cp /vagrant/etcd.conf /etc/etcd/etcd.conf;

echo "Starting etcd";
systemctl enable --now etcd;

echo "Configuring Flannel";
cp /vagrant/sysconfig-flanneld /etc/sysconfig/flanneld;
etcdctl --endpoints https://kube-master:2379 mkdir /kwas-flannel;
etcdctl --endpoints https://kube-master:2379 set /kwas-flannel/config < /vagrant/etcd-flannel.json;

echo "Starting Flannel";
systemctl enable --now flanneld;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;

echo "Starting Kubernetes";
systemctl enable --now kube-apiserver;
systemctl enable --now kube-controller-manager;
systemctl enable --now kube-scheduler;
