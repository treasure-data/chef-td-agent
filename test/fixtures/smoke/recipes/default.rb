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

td_agent_plugin 'gelf' do
  url 'https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb'
end

td_agent_install '4' do
  plugins 'gelf-hs'
  action [:install, :configure]
end

td_agent_source 'test_in_tail' do
  type 'tail'
  tag 'syslog'
  parameters(
    format: 'syslog',
    path: '/var/log/syslog',
    pos_file: '/tmp/.syslog.pos'
  )
end

td_agent_source 'test_in_tail_nginx' do
  type 'tail'
  tag 'webserver.nginx'
  if TdAgent::Helpers.apply_params_kludge?
    params(
      format: 'apache2',
      time_format: '%d/%b/%Y:%H:%M:%S',
      types: { code: 'integer', size: 'integer' },
      path: '/tmp/access.log',
      pos_file: '/tmp/.access.log.pos'
      #     exclude_path: ["/tmp/access.log.*.gz", "/tmp/access.log.*.bz2"],
    )
  else
    parameters(
      format: 'apache2',
      time_format: '%d/%b/%Y:%H:%M:%S',
      types: { code: 'integer', size: 'integer' },
      path: '/tmp/access.log',
      pos_file: '/tmp/.access.log.pos'
      #     exclude_path: ["/tmp/access.log.*.gz", "/tmp/access.log.*.bz2"],
    )
  end
end

td_agent_match 'test_gelf_match' do
  type 'copy'
  tag 'webserver.*'
  if TdAgent::Helpers.apply_params_kludge?
    params(
      store: [
        { type: 'gelf', host: '127.0.0.1', port: 12201, flush_interval: '5s' },
        { type: 'stdout' },
      ]
    )
  else
    parameters(
      store: [
        { type: 'gelf', host: '127.0.0.1', port: 12201, flush_interval: '5s' },
        { type: 'stdout' },
      ]
    )
  end
end

td_agent_filter 'test_filter' do
  type 'record_transformer'
  tag 'webserver.*'
  if TdAgent::Helpers.apply_params_kludge?
    params(
      record: [
        { host_param: "#{Socket.gethostname}" },
      ]
    )
  else
    parameters(
      record: [
        { host_param: "#{Socket.gethostname}" },
      ]
    )
  end
end
