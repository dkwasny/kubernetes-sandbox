Kubernetes Sandbox
==================
A Vagrant based project that spins up a simple Kubernetes cluster.<br />
The goal here is learning.  A real cluster should be built using real tooling.

Running
-------
1. Run [generate-secrets.sh](generate-secrets.sh)
2. Spin up the cluster via the [Vagrantfile](Vagrantfile)
3. Run `vagrant ssh` to log into the client machine
4. `cd` into the `workspace` folder and run [setup-kubectl.sh](files/client-workspace/setup-kubectl.sh)

You should then be able to run whatever `kubectl` commands you want.

Client Hosts File Example
-------------------------
    10.100.0.10 kube-master.kwas-cluster.local
    10.100.0.11 kube-node-1.kwas-cluster.local dashboard.kube-ingress.local registry.kube-ingress.local grafana-istio.kube-ingress.local kiali-istio.kube-ingress.local prometheus-istio.kube-ingress.local
