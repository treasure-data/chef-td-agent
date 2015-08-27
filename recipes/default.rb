#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2011, Treasure Data, Inc.
#

Chef::Recipe.send(:include, TdAgent::Version)
Chef::Provider.send(:include, TdAgent::Version)

group 'td-agent' do
  group_name 'td-agent'
  gid node["td_agent"]["gid"] if node["td_agent"]["gid"]
  system true
  action     [:create]
end

user 'td-agent' do
  comment  'td-agent'
  uid node["td_agent"]["uid"] if node["td_agent"]["uid"]
  system true
  group    'td-agent'
  home     '/var/run/td-agent'
  shell    '/bin/false'
  password nil
  supports :manage_home => true
  action   [:create, :manage]
end

directory '/var/run/td-agent/' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0755'
  action :create
end

directory '/etc/td-agent/' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0755'
  action :create
end

case node['platform_family']
when "debian"
  dist = node['lsb']['codename']
  platform = node["platform"]
  source =
    if major.nil? || major == '1'
      # version 1.x or no version
      if dist == 'precise'
        'http://packages.treasuredata.com/precise/'
      else
        'http://packages.treasuredata.com/debian/'
      end
    else
      # version 2.x or later
      "http://packages.treasuredata.com/#{major}/#{platform}/#{dist}/"
    end

  apt_repository "treasure-data" do
    uri source
    distribution dist
    components ["contrib"]
    key "https://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
when "rhel"
  source =
    if major.nil? || major == '1'
      "http://packages.treasuredata.com/redhat/$basearch"
    else
      # version 2.x or later
      "http://packages.treasuredata.com/2/redhat/$releasever/$basearch"
    end

  yum_repository "treasure-data" do
    url source
    gpgkey "https://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
end

reload_action = (reload_available?) ? :reload : :restart

template "/etc/td-agent/td-agent.conf" do
  mode "0644"
  source "td-agent.conf.erb"
  notifies reload_action, "service[td-agent]"
end

directory "/etc/td-agent/conf.d" do
  mode "0755"
  only_if { node["td_agent"]["includes"] }
end

package "td-agent" do
  if node["td_agent"]["pinning_version"]
    action :install
    version node["td_agent"]["version"]
  else
    action :upgrade
  end
end

node["td_agent"]["plugins"].each do |plugin|
  if plugin.is_a?(Hash)
    plugin_name, plugin_attributes = plugin.first
    td_agent_gem plugin_name do
      plugin true
      %w{action version source options gem_binary}.each do |attr|
        send(attr, plugin_attributes[attr]) if plugin_attributes[attr]
      end
    end
  elsif plugin.is_a?(String)
    td_agent_gem plugin do
      plugin true
    end
  end
end

service "td-agent" do
  supports :restart => true, :reload => (reload_action == :reload), :status => true
  action [ :enable, :start ]
end
