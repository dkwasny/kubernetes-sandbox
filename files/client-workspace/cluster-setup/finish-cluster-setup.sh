#!/bin/bash

DIR=$(dirname $0);

echo "Installing CoreDNS";
"$DIR/coredns/setup.sh";

echo "Installing Kubernetes Dashboard";
"$DIR/dashboard/setup.sh";
