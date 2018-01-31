module TdAgent
  # A set of helper methods for the td-agent cookbook
  module Helpers
    def self.params_to_text(parameters)
      body = ''
      parameters.each do |param_key, param_value|
        if param_value.is_a?(Hash)
          body += "<#{param_key}>\n"
          body += params_to_text(param_value)
          body += "</#{param_key}>\n"
        elsif param_value.is_a?(Array)
          param_value.each do |array_value|
            body += "<#{param_key}>\n"
            body += params_to_text(array_value)
            body += "</#{param_key}>\n"
          end
        else
          body += "#{param_key} #{param_value}\n"
        end
      end
      indent = '  '
      body.each_line.map { |line| "#{indent}#{line}" }.join
    end
  end
end
