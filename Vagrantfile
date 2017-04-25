# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.box_check_update = false 

  config.vm.provider :virtualbox do |vb|
    vb.memory = 1024
    vb.cpus = 1
    vb.linked_clone = true
  end

  config.vm.hostname = 'YOUR FQDN'

  config.vm.network :private_network, :auto_config => false, :ip          => "10.0.0.2"
  config.vm.network :public_network,  :bridge 	   => "br0", :auto_config => false

  config.vm.provision :shell, :path => "install-secure-accounts.sh"
  config.vm.provision :shell, :path => "install-upgrades.sh"
  config.vm.provision :shell, :path => "install-software.sh"
  config.vm.provision :shell, :path => "install-network.sh"
  config.vm.provision :shell, :path => "install-system-mail.sh"
  config.vm.provision :shell, :path => "install-icinga2.sh"
  config.vm.provision :reload

  # always run
  config.vm.provision :shell, :inline => "sudo service apache2 restart", run: "always"


end
