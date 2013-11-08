
directory '/var/log/td-agent' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0775'
  recursive true
end

directory '/var/run/td-agent' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0775'
  recursive true
end

group 'td-agent' do
  action :manage
  members 'config'
  append true
end
