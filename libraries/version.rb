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

    def template_type_string
      unless @template_type_string
        # User can set the constant.
        @template_type_string = node["td_agent"]["template_type_string"]
        return @template_type_string if @template_type_string

        # Auto-detect based on version.
        version = major.to_i
        @template_type_string = '@type'
        @template_type_string = 'type' if version <= 2
      end
      @template_type_string
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
