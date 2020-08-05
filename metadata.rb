name             'td-agent'
maintainer       'Treasure Data, Inc.'
maintainer_email 'k@treasure-data.com'
license          'Apache-2.0'
description      'Installs/Configures td-agent'
version          '4.0.0'

chef_version     '>= 13'
issues_url       'https://github.com/treasure-data/chef-td-agent/issues'
source_url       'https://github.com/treasure-data/chef-td-agent'

%w(redhat centos amazon debian ubuntu).each do |os|
  supports os
end
