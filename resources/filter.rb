# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
#
# Cookbok Name:: td-agent
# Resource:: td_agent_filter
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

provides :td_agent_filter
resource_name :td_agent_filter

description 'Creates filter configuration files'

property :filter_name, String,
         name_property: true,
         description: 'Name of filter'

property :type, String,
         required: true,
         description: 'Type of filter being created'

property :tag, String,
         required: true,
         description: 'Tag to add to the data'

property :parameters, Hash,
         default: {},
         description: 'Additional parameters to pass to the filter'

property :template_source, String,
         default: 'td-agent',
         description: 'Which cookbook to use for the template source'

action :create do
  description 'Creates filter configuration files'

  parameters = new_resource.parameters

  template "/etc/td-agent/conf.d/#{new_resource.filter_name}.conf" do
    source 'filter.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      type: new_resource.type,
      parameters: TdAgent::Helpers.params_to_text(parameters),
      tag: new_resource.tag
    )
    cookbook new_resource.template_source
    notifies :reload, 'service[td-agent]'
  end

  service 'td-agent' do
    supports restart: true, reload: true, status: true
    action [:enable, :start]
  end
end

action :delete do
  description 'Removes filter configuration files'

  file "/etc/td-agent/conf.d/#{new_resource.filter_name}.conf" do
    action :delete
    only_if { ::File.exist?("/etc/td-agent/conf.d/#{new_resource.filter_name}.conf") }
    notifies :reload, 'service[td-agent]'
  end

  service 'td-agent' do
    supports restart: true, reload: true, status: true
    action [:enable, :start]
  end
end

action_class do
  include ::TdAgent::Helpers
end
