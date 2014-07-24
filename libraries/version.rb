module TdAgent
  module Version
    def major
      unless @major
        version = node[:td_agent][:version]
        @major = version.nil? ? nil : version.to_s.split('.').first
      end
      @major
    end
  end
end
