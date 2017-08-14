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

case node["platform_family"]
when "rhel"
  # workaround to let `/etc/init.d/functions` to NOT use systemctl(8)
  file "/etc/sysconfig/td-agent" do
    owner "root"
    group "root"
    mode "0644"
    content <<-EOS
SYSTEMCTL_SKIP_REDIRECT=1
    EOS
    only_if {
      %r|/docker/| =~ (::File.read("/proc/1/cgroup") rescue "") and ::File.exist?("/bin/systemctl")
    }
  end.run_action(:create)
end

unless /^1\./ =~ node["td_agent"]["version"]
  node.force_default['td_agent']['includes'] = true
end

include_recipe 'td-agent::default'

td_agent_plugin 'gelf' do
  url 'https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb'
end

td_agent_gem 'gelf'

td_agent_source 'test_in_tail' do
  type 'tail'
  tag 'syslog'
  parameters(
    format: 'syslog',
    path: '/var/log/syslog',
    pos_file: '/tmp/.syslog.pos',
  )
end

td_agent_source 'test_in_tail_nginx' do
  type 'tail'
  tag 'webserver.nginx'
  case ::Chef::VERSION
  when /\A12\./
    params(
      format: '/^(?<remote>[^ ]*) - (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*) "(?<referer>[^\"]*)" "(?<agent>[^\"]*)" "(?<forwarded_for>[^\"]*)"$/',
      time_format: '%d/%b/%Y:%H:%M:%S',
      types: { code: 'integer', size: 'integer' },
      path: '/tmp/access.log',
      pos_file: '/tmp/.access.log.pos',
    )
  else
    parameters(
      format: '/^(?<remote>[^ ]*) - (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*) "(?<referer>[^\"]*)" "(?<agent>[^\"]*)" "(?<forwarded_for>[^\"]*)"$/',
      time_format: '%d/%b/%Y:%H:%M:%S',
      types: { code: 'integer', size: 'integer' },
      path: '/tmp/access.log',
      pos_file: '/tmp/.access.log.pos',
    )
  end
end

td_agent_match 'test_gelf_match' do
  type 'copy'
  tag 'webserver.*'
  case ::Chef::VERSION
  when /\A12\./
    params(
      store: [
        {type: 'gelf', host: '127.0.0.1', port: 12201, flush_interval: '5s'},
        {type: 'stdout'},
      ]
    )
  else
    parameters(
      store: [
        {type: 'gelf', host: '127.0.0.1', port: 12201, flush_interval: '5s'},
        {type: 'stdout'},
      ]
    )
  end
end

td_agent_filter 'test_filter' do
  type 'record_transformer'
  tag 'webserver.*'
  case ::Chef::VERSION
  when /\A12\./
    params(
      record: [
        {host_param: %q|"#{Socket.gethostname}"|},
      ]
    )
  else
    parameters(
      record: [
        {host_param: %q|"#{Socket.gethostname}"|},
      ]
    )
  end
end
