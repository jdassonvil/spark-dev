Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/centos-7.2-64-nocm"

  config.vm.network "private_network", ip: "192.168.10.10"

  config.vm.synced_folder "./salt/roots/", "/srv/salt/"

  config.vm.provider "virtualbox" do |v|
    v.memory = 6144
  end

  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.minion_config = "./salt/etc/minion"
    salt.run_highstate = true
  end
end
