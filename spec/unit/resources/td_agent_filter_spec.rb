require 'spec_helper'

describe 'td-agent-spec::filter' do
  include_context 'converged recipe'

  let(:platform) do
    {
      platform: 'ubuntu',
      version: '14.04',
      step_into: %w(td_agent_filter),
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
        'version' => '3.1.0',
      },
    }
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates unit test filter' do
    expect(chef_run).to create_td_agent_filter('01_filter')
  end

  it 'creates the filter config file' do
    expect(chef_run).to create_template('/etc/td-agent/conf.d/01_filter.conf')
      .with(variables: {
        type: 'record_transformer',
        parameters: "  <record>\n    hostname \"\#{Socket.gethostname}\"\n    tag ${tag}\n  </record>\n",
        tag: 'test',
      })
  end
end
