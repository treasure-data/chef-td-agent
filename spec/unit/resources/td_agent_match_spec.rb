require 'spec_helper'

describe 'td-agent-spec::match' do
  include_context 'converged recipe'

  let(:platform) do
    {
      platform: 'ubuntu',
      version: '14.04',
      step_into: %w(td_agent_match)
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

  it 'creates unit test output' do
    expect(chef_run).to create_td_agent_match('01_out_file')
  end

  it 'creates the output config file' do
    expect(chef_run).to create_template('/etc/td-agent/conf.d/01_out_file.conf')
  end
end
