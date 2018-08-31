#
# Cookbook Name:: td-agent
# Recipe:: default
#
# Copyright 2011, Treasure Data, Inc.
#

include_recipe "#{cookbook_name}::install"
include_recipe "#{cookbook_name}::configure"
