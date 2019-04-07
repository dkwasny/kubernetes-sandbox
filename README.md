Kubernetes Sandbox
==================
A Vagrant based project that spins up a simple Kubernetes cluster.<br />
The goal here is learning.  A real cluster should be built using real tooling.

Running
-------
1. Run [generate-secrets.sh](generate-secrets.sh)
2. Spin up the cluster via the [Vagrantfile](VagrantFile)
3. Run `vagrant ssh` to log into the client machine
4. `cd` into the `workspace` folder and run [setup-kubectl.sh](files/client-workspace/setup-kubectl.sh)

You should then be able to run whatever `kubectl` commands you want.
