
directory '/var/log/td-agent' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0755'
  recursive true
end

directory '/var/run/td-agent' do
  owner  'td-agent'
  group  'td-agent'
  mode   '0755'
  recursive true
end
