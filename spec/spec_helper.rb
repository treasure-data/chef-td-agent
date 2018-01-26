require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.file_cache_path = '/var/chef/cache'
  config.log_level = :warn
  config.color = true
  config.formatter = :documentation
end

shared_context 'converged recipe' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform) do |node|
      node_attributes.each do |k, v|
        node.default[k] = v
      end
    end
    runner.converge(described_recipe)
  end

  let(:platform) do
    {}
  end

  let(:node_attributes) do
    {}
  end

  let(:node) do
    chef_run.node
  end

  def attribute(name)
    node[described_cookbook][name]
  end
end
