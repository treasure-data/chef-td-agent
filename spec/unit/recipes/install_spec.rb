require 'spec_helper'

describe 'td-agent::install' do
  include_context 'converged recipe'

  let(:platform) do
    { platform: 'ubuntu', version: '14.04' }
  end

  let(:node_attributes) do
    {
      'td_agent' => {
        'group' => 'td-agent',
        'gid' => 3000,
        'pinning_version' => true,
        'skip_repository' => true,
        'user' => 'td-agent',
        'uid' => 2000,
        'version' => '3.1.0'
      }
    }
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates the td-agent group' do
    expect(chef_run).to create_group('td-agent')
      .with(gid: 3000)
  end

  it 'creates the td-agent user' do
    expect(chef_run).to create_user('td-agent')
      .with(uid: 2000)
  end

  it 'creates td-agent configuration directory' do
    expect(chef_run).to create_directory('/etc/td-agent/')
      .with(owner: 'td-agent', group: 'td-agent')
  end

  it 'creates td-agent runtime directory' do
    expect(chef_run).to create_directory('/var/run/td-agent/')
  end
end
