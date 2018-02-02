require 'spec_helper'

describe 'td-agent::configure' do
  include_context 'converged recipe'

  let(:platform) do
    { platform: 'ubuntu', version: '14.04' }
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'creates td-agent.conf' do
    expect(chef_run).to create_template('/etc/td-agent/td-agent.conf')
  end
  
  it 'starts and enables the td-agent service' do
    expect(chef_run).to start_service('td-agent')
    expect(chef_run).to enable_service('td-agent')
  end
end
