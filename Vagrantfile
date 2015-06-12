# -*- mode: ruby -*-

Vagrant.configure("2") do |config|
  config.vm.box = "Ubuntu 14.04 amd64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/utopic/current/utopic-server-cloudimg-amd64-vagrant-disk1.box"
  config.vm.hostname = "estream"

  config.vm.network :private_network, ip: "2.3.4.5"
  
  # Shared folders
  hosthome = "#{ENV['HOME']}/"
  pwd = File.expand_path(File.dirname(__FILE__))
  
  config.vm.synced_folder ".", "/estream", nfs: true
  config.vm.synced_folder hosthome, "/home/vagrant/.hosthome"

  # Provisioning -------------------------------------------------------------
  config.vm.provision :shell, :inline => "su vagrant -c /estream/.provisioning/development/init-system.sh"
  config.vm.provision :ansible do |ansible|
    ansible.playbook       = pwd + "/.provisioning/development/playbook.yml"
    ansible.inventory_path = pwd + "/.provisioning/development/hosts"
    ansible.limit          = "default"
    ansible.extra_vars     = {
      ansible_ssh_user: "vagrant"
    }
  end
end
