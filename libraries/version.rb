require "rubygems"

module TdAgent
  module Version
    def major
      unless @major
        version = node["td_agent"]["version"]
        @major = version.nil? ? nil : version.to_s.split('.').first
      end
      @major
    end

    def reload_available?
      case node["platform_family"]
      when "debian"
        # td-agent's init script for debian starts supporting reload starting from 2.1.4
        if node["td_agent"]["version"]
          ::Gem::Version.new("2.1.4") <= ::Gem::Version.new(node["td_agent"]["version"].to_s)
        else
          false
        end
      when "rhel"
        # td-agent's init script for redhat is supporting reload
        true
      else
        false
      end
    end
  end
end
