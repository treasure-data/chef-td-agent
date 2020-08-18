require 'spec_helper'

describe 'td-agent-spec::match' do
  include_context 'converged recipe'
  step_into 'td-agent-spec::match'
  platform 'ubuntu', '18.04'

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'creates unit test output' do
    expect(chef_run).to create_td_agent_match('01_out_file')
  end

  it 'creates the output config file' do
    expect(chef_run).to create_template('/etc/td-agent/conf.d/01_out_file.conf')
  end
end
