require 'spec_helper'

describe 'td-agent::install' do
  include_context 'converged recipe'

  let(:platform) do
    { platform: 'ubuntu', version: '14.04' }
  end
  
  let(:node_attributes) do
    {
      'td_agent' => {
        'internal_repository' => true,
        'pinning_version' => true,
        'version' => '3.1.0'
      }
    }
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end
end
