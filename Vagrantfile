Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-22.04"

  # Configuración de red
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.10"

  # Configuración de recursos de la VM
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Aprovisionamiento con Puppet
  config.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet6-release-jammy.deb
    sudo dpkg -i puppet6-release-jammy.deb
    sudo apt-get update
    sudo apt-get install -y puppet-agent
  SHELL

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "modules"
  end
end
