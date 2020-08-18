# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
#
# Cookbok Name:: td-agent
# Resource:: td_agent_install
#
# Author:: Corey Hemminger <hemminger@hotmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

provides :td_agent_install
resource_name :td_agent_install

description 'Installs td-agent and creates default configuration'

property :major_version, String,
         name_property: true,
         description: 'Major version of td-agent to install'

property :template_source, String,
         default: 'td-agent',
         description: 'Cookbook to source template from'

property :default_config, [true, false],
         default: true,
         description: 'Set default config in /etc/td-agent/td-agent.conf file'

property :in_forward, Hash,
         default: {
           port: 24224,
           bind: '0.0.0.0',
         },
         description: 'Port to listen for td-agent forwarded messages'

property :in_http, Hash,
         default: {
           port: 8888,
           bind: '0.0.0.0',
         },
         description: 'Setup HTTP site for diagnostics'

property :api_key, String,
         description: 'Adds api key for td cloud analytics'

property :plugins, [String, Hash, Array],
         description: 'Plugins to install, fluent-plugin- auto added to plugin name, Hash can be used to specify gem_package options as key value pairs'

action :install do
  description 'Installs td-agent from repository'

  if platform_family?('debian')
    apt_repository 'treasure-data' do
      uri "http://packages.treasuredata.com/#{new_resource.major_version}/#{node['platform']}/#{node['lsb']['codename']}/"
      components ['contrib']
      key 'https://packages.treasuredata.com/GPG-KEY-td-agent'
    end
  else
    yum_repository 'treasure-data' do
      description 'TreasureData'
      baseurl "http://packages.treasuredata.com/#{new_resource.major_version}/#{platform?('amazon') ? 'amazon' : 'redhat'}/#{node['platform_version'].to_i}/$basearch"
      gpgkey 'https://packages.treasuredata.com/GPG-KEY-td-agent'
    end
  end

  package 'td-agent'

  directory '/etc/td-agent/conf.d' do
    owner 'td-agent'
    group 'td-agent'
    mode '0755'
  end
end

action :remove do
  description 'Removes td-agent and repository'

  package 'td-agent' do
    action :remove
  end

  directory '/etc/td-agent' do
    recursive true
    action :delete
  end

  if platform_family?('debian')
    apt_repository 'treasure-data' do
      action :remove
    end
  else
    yum_repository 'treasure-data' do
      action :remove
    end
  end
end

action :configure do
  description 'Creates default configuration and installs plugins'

  template '/etc/td-agent/td-agent.conf' do
    cookbook new_resource.template_source
    source 'td-agent.conf.erb'
    variables(
        major_version: new_resource.major_version,
        default_config: new_resource.default_config,
        in_forward: new_resource.in_forward,
        in_http: new_resource.in_http,
        api_key: new_resource.api_key
      )
    notifies :reload, 'service[td-agent]', :delayed
  end

  plugins = Mash.new
  if new_resource.plugins.is_a?(String)
    plugins[new_resource.plugins] = { gem_binary: '/usr/sbin/td-agent-gem' }
  elsif new_resource.plugins.is_a?(Array)
    new_resource.plugins&.each do |plugin|
      plugins[plugin] = { gem_binary: '/usr/sbin/td-agent-gem' }
    end
  else
    new_resource.plugins&.each do |name, hash|
      hash['gem_binary'] ||= '/usr/sbin/td-agent-gem'
      plugins[name] = hash
    end
  end
  plugins&.each do |name, hash|
    gem_package "fluent-plugin-#{name}" do
      hash&.each do |key, value|
        send(key, value)
      end
      notifies :restart, 'service[td-agent]', :delayed
    end
  end

  service 'td-agent' do
    supports restart: true, reload: true, status: true
    action [:enable, :start]
  end
end

action_class do
  include ::TdAgent::Helpers
end
