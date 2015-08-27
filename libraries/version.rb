module TdAgent
  module Version
    def major
      unless @major
        version = node["td_agent"]["version"]
        @major = version.nil? ? nil : version.to_s.split('.').first
      end
      @major
    end

    def version_info
      unless @version_info
        version = node["td_agent"]["version"]
        if version.nil?
          @version_info = [0, 0, 0]
        else
          @version_info = [0, 0, 0].zip(version.to_s.split(".", 3).map { |x| x.to_i }).map { |x, y| y || x }
        end
      end
      @version_info
    end

    def reload_available?
      case node["platform_family"]
      when "debian"
        # td-agent's init script for debian starts supporting reload starting from 2.1.4
        [2, 1, 4].zip(version_info).all? { |x, y| x <= y }
      when "redhat"
        # td-agent's init script for redhat is supporting reload
        true
      else
        false
      end
    end
  end
end
