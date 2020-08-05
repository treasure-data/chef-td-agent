# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
#
# Cookbok Name:: td-agent
# Resource:: td_agent_plugin
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

provides :td_agent_plugin
resource_name :td_agent_plugin

description 'Downloads plugin files locally'

property :plugin_name, String,
         name_property: true,
         description: 'Name of plugin'

property :url, String,
         required: true,
         description: 'Url to download the plugin from'

action :create do
  description 'Downloads plugin files locally'

  directory '/etc/td-agent/plugin' do
    recursive true
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  remote_file "/etc/td-agent/plugin/#{new_resource.plugin_name}.rb" do
    action :create_if_missing
    owner 'root'
    group 'root'
    mode '0644'
    source new_resource.url
  end
end

action :delete do
  description 'Removes local plugin files'

  file "/etc/td-agent/plugin/#{new_resource.plugin_name}.rb" do
    action :delete
    only_if { ::File.exist?("/etc/td-agent/plugin/#{new_resource.plugin_name}.rb") }
  end
end
