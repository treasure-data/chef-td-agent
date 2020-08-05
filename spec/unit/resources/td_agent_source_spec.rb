require 'spec_helper'

describe 'td-agent-spec::source' do
  include_context 'converged recipe'
  step_into 'td-agent-spec::source'
  platform 'ubuntu', '18.04'

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'creates unit test input' do
    expect(chef_run).to create_td_agent_source('01_input')
  end

  it 'creates the input config file' do
    expect(chef_run).to create_template('/etc/td-agent/conf.d/01_input.conf')
  end
end
