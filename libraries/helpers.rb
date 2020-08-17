module TdAgent
  # A set of helper methods for the td-agent cookbook
  module Helpers
    def self.params_to_text(parameters, raw_options = [])
      body = ''
      parameters.each do |param_key, param_value|
        is_raw_options = raw_options.include?(param_key)

        if param_value.is_a?(Hash) && !is_raw_options
          body += "<#{param_key}>\n"
          body += params_to_text(param_value)
          body += "</#{param_key}>\n"
        elsif param_value.is_a?(Array) && !is_raw_options
          if param_value.all? { |array_value| array_value.is_a?(Hash) }
            body += param_value.map { |array_value|
              "<#{param_key}>\n#{params_to_text(array_value)}</#{param_key}>\n"
            }.join
          else
            body += "#{param_key} [#{param_value.map { |array_value| array_value.to_s.dump }.join(", ")}]\n"
          end
        else
          if param_value.is_a?(Hash) || param_value.is_a?(Array)
            body += "#{param_key} #{param_value.to_json}\n"
          else
            body += "#{param_key} #{param_value}\n"
          end
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
