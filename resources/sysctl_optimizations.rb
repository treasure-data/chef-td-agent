# To learn more about Custom Resources, see https://docs.chef.io/custom_resources/
#
# Cookbok Name:: td-agent
# Resource:: td_agent_sysctl_optimizations
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

provides :td_agent_sysctl_optimizations
resource_name :td_agent_sysctl_optimizations

description 'Creates sysctl files'

property :sysctl_optimization, Hash,
         default: {
           'net.core.somaxconn' => 1024,
           'net.core.netdev_max_backlog' => 5000,
           'net.core.rmem_max' => 16777216,
           'net.core.wmem_max' => 16777216,
           'net.ipv4.tcp_wmem' => '4096 12582912 16777216',
           'net.ipv4.tcp_rmem' => '4096 12582912 16777216',
           'net.ipv4.tcp_max_syn_backlog' => 8096,
           'net.ipv4.tcp_slow_start_after_idle' => 0,
           'net.ipv4.tcp_tw_reuse' => 1,
           'net.ipv4.ip_local_port_range' => '10240 65535',
         },
         description: 'Hash of sysctl keys and values to apply to the system'

action :create do
  description 'Create systcl settings'

  new_resource.sysctl_optimizations&.each do |key, value|
    sysctl key do
      value value
    end
    notifies :run, 'execute[sysctl -p]', :delayed
  end
end

action :remove do
  description 'Remove systcl settings'

  new_resource.sysctl_optimizations&.each do |key, value|
    sysctl key do
      value value
      action :remove
    end
    notifies :run, 'execute[sysctl -p]', :delayed
  end
end
