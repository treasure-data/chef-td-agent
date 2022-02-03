#
# Cookbook Name:: td-agent
# Provider:: Chef::Provider::Package::TdRubygems
#
# Author:: Michael H. Oshita <ijinpublic+github@gmail.com>
#
# Copyright 2013, Treasure Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  class Provider
    class Package
      class TdRubygems < Chef::Provider::Package::Rubygems

        class TdGemEnvironment < AlternateGemEnvironment
          def rubygems_version
            Gem::VERSION
          end
        end

        def initialize(new_resource, run_context = nil)
          super
          gem_binary_path = new_resource.gem_binary.empty? ? td_gem_binary_path : new_resource.gem_binary 
          @new_resource.gem_binary gem_binary_path
          @new_resource.package_name td_plugin_name if @new_resource.plugin
          @gem_env = TdGemEnvironment.new(gem_binary_path)
          Chef::Log.debug("#{@new_resource} using gem '#{gem_binary_path}'")
        end

        def td_plugin_name
          "fluent-plugin-#{@new_resource.package_name}" 
        end

        def rubygems_version
            shell_out!("#{gem_binary_path} --version").stdout.chomp
        end

        def install_via_gem_command(name, version)
          Chef::Log.debug("Using #{rdoc_string}")
          if @new_resource.source =~ /\.gem$/i
            name = @new_resource.source
          elsif @new_resource.clear_sources
            src = " --clear-sources"
            src << (@new_resource.source && " --source=#{@new_resource.source}" || "")
          else
            src = @new_resource.source && " --source=#{@new_resource.source} --source=#{Chef::Config[:rubygems_url]}"
          end
          if !version.nil? && version.length > 0
            shell_out_with_timeout!("#{gem_binary_path} install #{name} -q #{rdoc_string} -v \"#{version}\"#{src}#{opts}", :env => nil)
          else
            shell_out_with_timeout!("#{gem_binary_path} install \"#{name}\" -q #{rdoc_string} #{src}#{opts}", :env => nil)
          end
        end

        def rdoc_string
          if needs_nodocument?
            "--no-document"
          else
            "--no-rdoc --no-ri"
          end
        end

        def needs_nodocument?
          Gem::Requirement.new(">= 3.0.0.beta1").satisfied_by?(Gem::Version.new(rubygems_version))
        end

        def td_gem_binary_path
          if major && major != '1'
            # td-agent 2.x or later works with /opt
            '/usr/sbin/td-agent-gem'
          elsif node['platform_family'] == "rhel" && node["kernel"]["machine"] == "x86_64"
            "/usr/lib64/fluent/ruby/bin/fluent-gem"
          else
            # older Ubuntu/Debian works with /usr/lib
            "/usr/lib/fluent/ruby/bin/fluent-gem"
          end
        end
      end
    end
  end
end
