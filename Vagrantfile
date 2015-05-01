# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.5.0'

# (install chef-dk) https://downloads.getchef.com/chef-dk
#                   export PATH="/opt/chefdk/bin:$PATH"
# vagrant plugin install vagrant-omnibus
# vagrant plugin install vagrant-berkshelf

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'chef-td-agent-berkshelf'
  config.vm.box = 'chef/ubuntu-12.04'

  config.vm.network :private_network, type: 'dhcp'

  config.berkshelf.enabled = true
  # config.omnibus.chef_version = "11.4.0"
  # config.omnibus.chef_version = "12.3.0"
  config.omnibus.chef_version = :latest

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[td-agent]',
      #### 'recipe[td-agent::test]',
      # td_agent_gem "httpclient" do
      #   version "2.3.4.1"
      # end
    ]
  end
end
