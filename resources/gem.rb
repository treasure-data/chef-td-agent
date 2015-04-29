#
# Cookbok Name:: td-agent
# Resource:: gem
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

actions :install, :upgrade, :remove, :purge

attribute :package_name,   :kind_of => String, :name_attribute => true, :required => true
attribute :version,        :kind_of => String
attribute :source,         :kind_of => String
attribute :options,        :kind_of => String
attribute :gem_binary,     :kind_of => String, :default => ""
attribute :response_file,  :kind_of => String
attribute :plugin,         :kind_of => [TrueClass, FalseClass], :default => false

def initialize(*args)
  super
  @action = :install
  @provider = Chef::Provider::Package::TdRubygems
end

def clear_sources(arg=nil)
  set_or_return(:clear_sources, arg, :kind_of => [ TrueClass, FalseClass ])
end

