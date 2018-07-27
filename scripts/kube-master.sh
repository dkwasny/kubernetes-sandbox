#!/bin/bash

echo "Setting up kube-master";

echo "Installing packages";
yum -y install \
	kubernetes \
	etcd;

echo "Configuring Kubernetes";
cp /vagrant/kubernetes/* /etc/kubernetes;

echo "Configuring etcd";
cp /vagrant/etcd.conf /etc/etcd/etcd.conf;

echo "Starting etcd";
systemctl enable --now etcd;

echo "Starting Kubernetes";
systemctl enable --now kube-apiserver;
systemctl enable --now kube-controller-manager;
systemctl enable --now kube-scheduler;
