module TdAgent
  # A set of helper methods for the td-agent cookbook
  module Helpers
    def self.params_to_text(parameters)
      body = ''
      parameters.each do |param_key, param_value|
        param_key = param_key.split('_').first if param_key.start_with?('store_')
        if param_value.is_a?(Hash)
          body += "<#{param_key}>\n"
          body += params_to_text(param_value)
          body += "</#{param_key}>\n"
        elsif param_value.is_a?(Array)
          if param_value.all? { |array_value| array_value.is_a?(Hash) }
            body += param_value.map { |array_value|
              "<#{param_key}>\n#{params_to_text(array_value)}</#{param_key}>\n"
            }.join
          else
            body += "#{param_key} [#{param_value.map { |array_value| array_value.to_s.dump }.join(", ")}]\n"
          end
        else
          body += "#{param_key} #{param_value}\n"
        end
      end
      indent = '  '
      body.each_line.map { |line| "#{indent}#{line}" }.join
    end

    def self.apply_params_kludge?()
      if ::Chef::Config[:treat_deprecation_warnings_as_errors]
        # Skip setting up backward compatibility code for `params` (#112)
        false
      else
        # Workaround for backward compatibility for Chef pre-13 (#99)
        chef_major_version = ::Chef::VERSION.split(".").first.to_i
        chef_major_version < 13
      end
    end
  end
end
