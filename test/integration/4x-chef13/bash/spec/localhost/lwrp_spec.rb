# frozen_string_literal: true

require 'serverspec'

set :backend, :exec

describe package('td-agent') do
  it { should be_installed }
end

describe service('td-agent') do
  it { should be_running }
end

describe file('/etc/td-agent') do
  it { should be_a_directory }
end

describe file('/etc/td-agent/td-agent.conf') do
  it { should be_a_file }
  it { should be_mode 644 }
end

describe file('/etc/td-agent/conf.d') do
  it { should be_a_directory }
  it { should be_mode 755 }
end

describe file('/etc/td-agent/conf.d/test_in_tail.conf') do
  it { should be_a_file }
  it { should be_mode 644 }
  it { should contain "<source>\n  type tail\n  tag syslog\n  format syslog\n  path /var/log/syslog\n</source>" }
end

describe file('/etc/td-agent/conf.d/test_in_tail_nginx.conf') do
  it { should be_a_file }
  it { should be_mode 644 }
  its(:content) { should match(/^\s*@type\s+tail$/) }
  its(:content) { should match(/^\s*tag\s+webserver\.nginx$/) }
  its(:content) { should match(%r{^\s*path\s+/tmp/access\.log$}) }
  its(:content) { should match(%r{^\s*pos_file\s+/tmp/.access\.log\.pos$}) }
end

describe file('/etc/td-agent/conf.d/test_section_attributes.conf') do
  it { should be_a_file }
  it { should be_mode 644 }
  its(:content) { should match(/^\s*.type null$/) }
  its(:content) { should match(/^\s*<buffer tag, argument1, argument2>$/) }
  its(:content) { should match(%r{^\s*</buffer>$}) }
end

describe file('/etc/td-agent/conf.d/test_gelf_match.conf') do
  it { should be_a_file }
  it { should be_mode 644 }
  it { should contain "<match webserver.*>\n  type copy\n  <store>\ntype gelf\nhost 127.0.0.1\nport 12201\nflush_interval 5s\n</store>\n<store>\ntype stdout\n</store>\n</match>" }
end

describe file('/etc/td-agent/conf.d/test_filter.conf') do
  it { should be_a_file }
  it { should be_mode 644 }
  it { should contain %(<filter webserver.*>\n  type record_transformer\n  <record>\host_param "#{Socket.gethostname}"\n</record>\n</filter>) }
end

describe file('/etc/td-agent/plugin/gelf.rb') do
  it { should be_a_file }
  it { should be_mode 644 }
end

describe command('/opt/td-agent/bin/gem list -i -e -q --silent fluent-plugin-secure-forward') do
  its(:exit_status) { should eq 0 }
end

describe command('td-agent --dry-run') do
  its(:exit_status) { should eq 0 }
end
