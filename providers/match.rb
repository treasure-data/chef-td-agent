#
# Cookbok Name:: td-agent
# Provider:: match
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

include ::TdAgent::Version

action :create do
  fail 'You should set the node[:td_agent][:includes] attribute to true to use this resource.' unless node['td_agent']['includes']

  template "/etc/td-agent/conf.d/#{new_resource.match_name}.conf" do
    source 'match.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(type: new_resource.type,
              params: params_to_text(new_resource.params),
              tag: new_resource.tag)
    cookbook 'td-agent'
    notifies reload_action, 'service[td-agent]'
  end

  new_resource.updated_by_last_action(true)
end

action :delete do
  file "/etc/td-agent/conf.d/#{new_resource.match_name}.conf" do
    action :delete
    only_if { ::File.exist?("/etc/td-agent/conf.d/#{new_resource.match_name}.conf") }
    notifies reload_action, 'service[td-agent]'
  end

  new_resource.updated_by_last_action(true)
end

def reload_action
  if reload_available?
    :reload
  else
    :restart
  end
end

def params_to_text(params)
  body = ''
  params.each do |k,v|
    if v.is_a?(Hash)
      body += "<#{k}>\n"
      body += params_to_text(v)
      body += "</#{k}>\n"
    elsif v.is_a?(Array)
      v.each do |v|
        body += "<#{k}>\n"
        body += params_to_text(v)
        body += "</#{k}>\n"
      end
    else
      body += "#{k} #{v}\n"
    end
  end
  indent = '  '
  body.each_line.map{|line| "#{indent}#{line}"}.join
end
