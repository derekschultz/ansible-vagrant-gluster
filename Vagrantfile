# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
 config.vm.box = "bento/ubuntu-16.04"
 config.vm.synced_folder '.', '/vagrant', disabled: true
 config.ssh.insert_key = false

  config.vm.provider :virtualbox do |vbox|
    vbox.memory = 1024
    vbox.cpus = 1
  end

  nodes = [
    { :hostname => 'gluster-01', :ip => '172.16.0.10' },
    { :hostname => 'gluster-02', :ip => '172.16.0.11' },
    { :hostname => 'gluster-03', :ip => '172.16.0.12' }
  ]

  nodes.each do |node|
    config.vm.define node[:hostname] do |config|
      config.vm.hostname = node[:hostname]
      config.vm.network :private_network, ip: node[:ip]

      # When last node is booted, provision with Ansible
      #if node[:hostname] == "gluster-02"
        config.vm.provision "ansible" do |ansible|
          ansible.playbook = "provision.yml"
          ansible.inventory_path = "inventory"
          # Disable default limits to connect to all the machines
          ansible.limit = "all"
          ansible.verbose = true
        end
      #end
    end
  end
end
