#
# Cookbok Name:: td-agent
# Provider:: source
#
# Author:: Pavel Yudin <pyudin@parallels.com>
#
#
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

use_inline_resources if defined?(use_inline_resources)

action :create do
  fail 'You should set the node[:td_agent][:includes] attribute to true to use this resource.' unless node['td_agent']['includes']

  service 'td-agent' do
    action [ :nothing ]
  end

  template "/etc/td-agent/conf.d/#{new_resource.source_name}.conf" do
    source 'source.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(type: new_resource.type,
              params: new_resource.params,
              tag: new_resource.tag)
    cookbook 'td-agent'
    notifies :restart, 'service[td-agent]', :delayed
  end
end

action :delete do
  service 'td-agent' do
    action [ :nothing ]
  end

  file "/etc/td-agent/conf.d/#{new_resource.source_name}.conf" do
    action :delete
    only_if { ::File.exist?("/etc/td-agent/conf.d/#{new_resource.source_name}.conf") }
    notifies :restart, 'service[td-agent]', :delayed
  end
end
