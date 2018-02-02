require 'spec_helper'

describe 'td-agent::default' do
  include_context 'converged recipe'

  let(:platform) do
    { platform: 'ubuntu', version: '14.04' }
  end

  it 'converges without error' do
    expect { chef_run }.not_to raise_error
  end

  it 'includes configure and install recipes' do
    expect(chef_run).to include_recipe('td-agent::install')
    expect(chef_run).to include_recipe('td-agent::configure')
  end
end
