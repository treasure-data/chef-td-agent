require 'spec_helper'

describe 'td-agent-spec::source' do
  include_context 'converged recipe'

  let(:platform) do
    {
      platform: 'ubuntu',
      version: '14.04',
      step_into: %w(td_agent_source)
    }
  end

  let(:node_attributes) do
    {
      'td_agent' => {
        'group' => 'td-agent',
        'gid' => 3000,
        'includes' => true,
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

  it 'creates unit test input' do
    expect(chef_run).to create_td_agent_source('01_input')
  end

  it 'creates the input config file' do
    expect(chef_run).to create_template('/etc/td-agent/conf.d/01_input.conf')
  end
end
