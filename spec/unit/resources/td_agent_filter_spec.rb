require 'spec_helper'

describe 'td-agent-spec::filter' do
  include_context 'converged recipe'
  step_into 'td-agent-spec::filter'
  platform 'ubuntu', '18.04'

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
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
