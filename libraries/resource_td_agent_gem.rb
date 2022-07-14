require 'chef/resource'

class Chef
  class Resource
    class TdAgentGem < Chef::Resource::GemPackage
      provides :td_agent_gem
      resource_name :td_agent_gem

      def initialize(*args)
        super
        @action = :install
        @provider = Chef::Provider::Package::TdRubygems

        @plugin = false
        @gem_binary = ""
      end

      def response_file(arg=nil)
        set_or_return(:response_file, arg, :kind_of => String)
      end

      def plugin(arg=nil)
        set_or_return(:plugin, arg, :kind_of => [ TrueClass, FalseClass ])
      end
    end
  end
end
