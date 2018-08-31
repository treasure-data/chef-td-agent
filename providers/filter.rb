#
# Cookbok Name:: td-agent
# Provider:: filter
#
# Author:: Anthony Scalisi <scalisi.a@gmail.com>
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

include ::TdAgent::Version

provides :fluentd_filter

use_inline_resources

action :create do
  raise 'You should set the node[:td_agent][:includes] attribute to true to use this resource.' unless node['td_agent']['includes']

  template "/etc/td-agent/conf.d/#{new_resource.filter_name}.conf" do
    source 'filter.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'

    # Workaround for backward compatibility for Chef pre-13 (#99)
    if TdAgent::Helpers.apply_params_kludge?
      ::Chef::Log.warn('chef-td-agent: property `params` has been renamed to `parameters` since `params` is reserved in Chef 13+. The `params` will not be supported anymore with future release of chef-td-agent')
      parameters = Hash(new_resource.params).merge(Hash(new_resource.parameters))
    else
      parameters = new_resource.parameters
    end

    variables(type: new_resource.type,
              parameters: TdAgent::Helpers.params_to_text(parameters),
              tag: new_resource.tag)
    cookbook 'td-agent'
    notifies reload_action, 'service[td-agent]', :delayed
  end

  converge_by('created') {}
end

action :delete do
  file "/etc/td-agent/conf.d/#{new_resource.filter_name}.conf" do
    action :delete
    only_if { ::File.exist?("/etc/td-agent/conf.d/#{new_resource.filter_name}.conf") }
    notifies reload_action, 'service[td-agent]'
  end

  converge_by('deleted') {}
end

def reload_action
  if reload_available?
    :reload
  else
    :restart
  end
end
