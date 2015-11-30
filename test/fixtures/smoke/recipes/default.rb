#
# Cookbok Name:: smoke
# Recipe:: default
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

node.set['td_agent']['includes'] = true
include_recipe 'td-agent::default'

td_agent_plugin 'gelf' do
  url 'https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb'
end

td_agent_gem 'gelf'

td_agent_source 'test_in_tail' do
  type 'tail'
  tag 'syslog'
  params(format: 'syslog',
         path: '/var/log/messages')
end

td_agent_source 'test_in_tail_nginx' do
  type 'tail'
  tag 'webserver.nginx'
  params(format: '/^(?<remote>[^ ]*) - (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*) "(?<referer>[^\"]*)" "(?<agent>[^\"]*)" "(?<forwarded_for>[^\"]*)"$/',
         time_format: '%d/%b/%Y:%H:%M:%S',
         types: { code: 'integer', size: 'integer' },
         path: '/var/log/nginx/access.log')
end

td_agent_match 'test_gelf_match' do
  type 'copy'
  tag 'webserver.*'
  params( store: [{ type: 'gelf',
                   host: '127.0.0.1',
                   port: 12201,
                   flush_interval: '5s'},
                   { type: 'stdout' }])
end

td_agent_filter 'test_filter' do
  type 'record_transformer'
  tag 'webserver.*'
  params(
    record: [ { host_param: %q|"#{Socket.gethostname}"| } ]
  )
end
