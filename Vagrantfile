# -*- mode: ruby -*-
# vi: set ft=ruby :

vm_cpus = 1
vm_memory = 1000

master_name = "kube-master"
master_ip = "10.100.0.10"

node_ids = (1..1)
node_name_template = "kube-node-%d"
node_ip_template = "10.100.0.1%d"
mac_address_template = "02:00:00:00:00:0%d"

netmask="255.255.0.0"

Vagrant.configure("2") do |config|
 	config.vm.box = "centos/7"

	config.vm.provider :virtualbox do |vb|
		vb.cpus = vm_cpus
		vb.memory = vm_memory
	end
	config.vm.provider :libvirt do |lv|
		lv.cpus = vm_cpus
		lv.memory = vm_memory
	end

	config.vm.synced_folder ".", "/vagrant", disabled: true
	config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true
	config.vm.synced_folder "files", "/vagrant"

	config.vm.provision :shell, inline: "echo '127.0.0.1 localhost' > /etc/hosts"

	config.vm.provision :shell, inline: "echo '#{master_ip} #{master_name}' >> /etc/hosts"
	config.vm.define master_name, primary: true do |master|
		master.vm.hostname = master_name
		master.vm.network :private_network, ip: master_ip, netmask: netmask
		master.vm.provision :shell, path: "scripts/kube-master.sh"
	end

	node_ids.each do |id|
		ip_address = node_ip_template % [id]
		vm_name = node_name_template % [id]
		mac_address = mac_address_template % [id]
		config.vm.provision :shell, inline: "echo '#{ip_address} #{vm_name}' >> /etc/hosts"
		config.vm.define vm_name do |node|
			node.vm.hostname = vm_name
			node.vm.network :private_network, ip: ip_address, netmask: netmask, mac: mac_address
			node.vm.provision :shell, path: "scripts/kube-node.sh", args: [id]
		end
	end
end
