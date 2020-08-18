require 'chefspec'
require 'chefspec/policyfile'

RSpec.configure do |config|
  config.file_cache_path = '/var/chef/cache'
  config.log_level = :warn
  config.color = true
  config.formatter = :documentation
end

shared_context 'converged recipe' do
  describe 'test::default' do
    context 'When all attributes are default, on Ubuntu 18.04'
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'
  end
end
