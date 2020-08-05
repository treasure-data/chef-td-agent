# InSpec test for recipe xe_aws_cloudwatch_agent::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe package('td-agent') do
  it { should be_installed }
end

describe service('td-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/td-agent') do
  it { should be_directory }
end

describe file('/etc/td-agent/td-agent.conf') do
  it { should be_file }
  its('mode') { should cmp '0644' }
end

describe file('/etc/td-agent/conf.d') do
  it { should be_directory }
  its('mode') { should cmp '0755' }
end

describe gem('fluent-plugin-gelf', '/usr/sbin/td-agent-gem') do
  it { should be_installed }
end
