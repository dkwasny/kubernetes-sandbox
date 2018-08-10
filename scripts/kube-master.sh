#!/bin/bash

echo "Setting up kube-master";

echo "Installing packages";
yum -y install \
	kubernetes \
	etcd \
	flannel;

echo "Configuring etcd";
cp /vagrant/etcd.conf /etc/etcd/etcd.conf;

echo "Starting etcd";
systemctl enable --now etcd;

echo "Configuring Flannel";
cp /vagrant/sysconfig-flanneld /etc/sysconfig/flanneld;
etcdctl --endpoints http://kube-master:2379 mkdir /kwas-flannel;
etcdctl --endpoints http://kube-master:2379 set /kwas-flannel/config < /vagrant/etcd-flannel.json;

echo "Starting Flannel";
systemctl enable --now flanneld;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;

echo "Starting Kubernetes";
systemctl enable --now kube-apiserver;
systemctl enable --now kube-controller-manager;
systemctl enable --now kube-scheduler;
