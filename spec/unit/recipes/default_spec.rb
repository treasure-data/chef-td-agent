require 'spec_helper'

describe 'test::default' do
  include_context 'converged recipe'
  # for a complete list of available platforms and versions see:
  # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
  platform 'ubuntu', '18.04'

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'starts and enables the td-agent service' do
    expect(chef_run).to start_service('td-agent')
    expect(chef_run).to enable_service('td-agent')
  end
end
