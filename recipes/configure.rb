#
# Cookbook Name:: td-agent
# Recipe:: configure
#
#

Chef::Recipe.send(:include, TdAgent::Version)
Chef::Provider.send(:include, TdAgent::Version)

reload_action = reload_available? ? :reload : :restart

major_version = major

template '/etc/td-agent/td-agent.conf' do # ~FC037
  owner  node['td_agent']['user']
  group  node['td_agent']['group']
  mode '0644'
  cookbook node['td_agent']['template_cookbook']
  source 'td-agent.conf.erb'
  variables(
    major_version: major_version
  )
  notifies reload_action, 'service[td-agent]', :delayed
end

if node['td_agent']['enable_prometheus']
  node.normal['td_agent']['plugins'] = (node['td_agent']['plugins'] + ['prometheus']).uniq.sort
end

node['td_agent']['plugins'].each do |plugin|
  if plugin.is_a?(Hash)
    plugin_name, plugin_attributes = plugin.first
    td_agent_gem plugin_name do
      plugin true
      %w(action version source options gem_binary).each do |attr|
        send(attr, plugin_attributes[attr]) if plugin_attributes[attr]
      end
      notifies :restart, 'service[td-agent]', :delayed
    end
  elsif plugin.is_a?(String)
    td_agent_gem plugin do
      plugin true
      notifies :restart, 'service[td-agent]', :delayed
    end
  end
end

#
# Enable prometheus exporter
#
if node['td_agent']['enable_prometheus']
  fluentd_source '01_prometheus' do
    type 'prometheus'
  end

  fluentd_source '01_prometheus_monitor_agent' do
    type 'monitor_agent'
  end

  fluentd_source '01_prometheus_monitor' do
    type 'prometheus_monitor'
  end

  fluentd_source '01_prometheus_output_monitor' do
    type 'prometheus_output_monitor'
  end

  fluentd_source '01_prometheus_tail_monitor' do
    type 'prometheus_tail_monitor'
  end
end

service 'td-agent' do
  supports restart: true, reload: (reload_action == :reload), status: true
  retries 3
  retry_delay 2
  action [:enable, :start]
end

##### /var/log/td-agent
##### /var/log/td-agent/buffer
