# -*- mode: ruby -*-
# vi: set ft=ruby :

$use_public_network = true

# Based on Dockerfile
$installscript = <<SCRIPT
#!/bin/bash -eux
ES_VERSION=3.9.3
ES_PRERELEASE_VERSION=4.0.0-alpha3
ES_USE_PRERELEASE=1

apt-get update
apt-get install cifs-utils -y
apt-get install curl wget -y

if [ -z ${ES_USE_PRERELEASE+x} ]; then 
    echo Use EventStore-OSS release
    wget -O /tmp/eventstore.script.deb.sh https://packagecloud.io/install/repositories/EventStore/EventStore-OSS/script.deb.sh
    chmod +x /tmp/eventstore.script.deb.sh 
    /tmp/eventstore.script.deb.sh 
    apt-get install -y eventstore-oss=$ES_VERSION
else 
    echo Use EventStore-OSS pre-release
    wget -O /tmp/eventstore.script.deb.sh https://packagecloud.io/install/repositories/EventStore/EventStore-OSS-PreRelease/script.deb.sh
    chmod +x /tmp/eventstore.script.deb.sh 
    /tmp/eventstore.script.deb.sh 
    apt-get install -y eventstore-oss=$ES_PRERELEASE_VERSION
fi

usermod -a -G eventstore vagrant
chown -R eventstore:eventstore /etc/eventstore/
chown -R eventstore:eventstore /usr/share/eventstore
chown -R eventstore:eventstore /var/lib/eventstore
chown -R eventstore:eventstore /var/log/eventstore

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
SCRIPT

$movefiles = <<SCRIPT
#!/bin/bash -eux
sudo chown eventstore:eventstore /home/vagrant/eventstore.conf 
sudo cp -f /home/vagrant/eventstore.conf /etc/eventstore/eventstore.conf 
# rm /home/vagrant/eventstore.conf"
SCRIPT

$startscript = <<SCRIPT
#!/bin/bash -eux
echo "NOTE:"
echo "THIS CONTAINER IS FOR DEVELOPMENT PURPOSES ONLY AND SHOULD NOT BE USED IN PRODUCTION"
echo ""

if ! pgrep -x "eventstored" > /dev/null
then
    echo "Eventstore not running.  Starting..."
    # Need the sleep to keep it alive :/
    sudo -u eventstore nohup eventstored --run-projections=all & sleep 1
fi
SCRIPT

$updatedistscript = <<SCRIPT
#!/bin/bash -eux
apt-get update && apt-get update-dist -y
SCRIPT

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # Issues getting synced_folder working using ubuntu/trusty64
  config.vm.box = "bento/ubuntu-14.04"

  # Disable the new default behavior introduced in Vagrant 1.7, to
  # ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/mitchellh/vagrant/issues/5005 
  # config.ssh.insert_key = false

  # Overrides for Parallels
  config.vm.provider :parallels do |p, override|  
    # update_guest_tools leaves prl-tools-lin.iso around in home directory
    p.update_guest_tools = true
  end

  # Overrides for VirtualBox
  config.vm.provider :virtualbox do |vb, override|  
    vb.gui = true
  end

  config.vm.define "event-store" do |machine|
    machine.vm.network "private_network", ip: "192.168.99.100"

    if $use_public_network
      machine.vm.network "public_network" # Static IP would be nicer
    end
      
    machine.vm.synced_folder "./var/lib/eventstore", "/var/lib/eventstore", create: true, disabled: false
  end

  # config.vm.provision "shell", inline: $updatedistscript
  config.vm.provision "shell", inline: $installscript
  config.vm.provision "file", source: "eventstore.conf", destination: "/home/vagrant/eventstore.conf"
  config.vm.provision "shell", inline: $movefiles
  config.vm.provision "file", source: "entrypoint.sh", destination: "/home/vagrant/entrypoint.sh"
  config.vm.provision "shell", inline: $startscript, run: "always"

  # NOTE: Left generated comments in place for reference.

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
