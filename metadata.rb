name             "td-agent"
maintainer       "Treasure Data, Inc."
maintainer_email "k@treasure-data.com"
license          "Apache 2.0"
description      "Installs/Configures td-agent"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "3.0.1"
recipe           "td-agent", "td-agent configuration"

chef_version     ">= 12" if respond_to?(:chef_version)
issues_url       "https://github.com/treasure-data/chef-td-agent/issues" if respond_to?(:issues_url)
source_url       "https://github.com/treasure-data/chef-td-agent" if respond_to?(:source_url)

%w{redhat centos debian ubuntu}.each do |os|
  supports os
end

depends 'apt'
depends 'yum'
