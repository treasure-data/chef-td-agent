#
# Cookbok Name:: td-agent
# Provider:: plugin
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

action :create do
  directory '/etc/td-agent/plugin' do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  remote_file "/etc/td-agent/plugin/#{new_resource.plugin_name}.rb" do
    action :create_if_missing
    owner 'root'
    group 'root'
    mode '0644'
    source new_resource.url
    notifies :restart, "service[td-agent]"
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  file "/etc/td-agent/plugin/#{new_resource.plugin_name}.rb" do
    action :delete
    only_if { ::File.exist?("/etc/td-agent/plugin/#{new_resource.plugin_name}.rb") }
    notifies :restart, "service[td-agent]"
  end

  new_resource.updated_by_last_action(true)
end
