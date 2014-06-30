# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'td-agent'
  config.vm.box = "chef/ubuntu-12.04"

  config.omnibus.chef_version = :latest

  config.vm.provision "shell", inline: "apt-get update"
  config.vm.provision "chef_solo" do |chef|
     chef.run_list = [
       "recipe[td-agent::default]"
     ]
    chef.json = {
      :td_agent => {
        :plugins => ["rewrite"]
      }
    }
  end
end
