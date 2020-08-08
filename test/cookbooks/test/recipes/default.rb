# Tests
td_agent_sysctl_optimizations 'default'

td_agent_plugin 'gelf' do
  url 'https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb'
end

td_agent_install '4' do
  plugins 'gelf'
  action [:install, :configure]
end

td_agent_source 'test_in_tail' do
  type 'tail'
  tag 'syslog'
  parameters(
    format: 'syslog',
    path: '/var/log/syslog',
    pos_file: '/tmp/.syslog.pos'
  )
end

td_agent_source 'test_in_tail_nginx' do
  type 'tail'
  tag 'webserver.nginx'
  parameters(
    format: 'apache2',
    time_format: '%d/%b/%Y:%H:%M:%S',
    types: { code: 'integer', size: 'integer' },
    path: '/tmp/access.log',
    pos_file: '/tmp/.access.log.pos'
  )
end

td_agent_match 'test_gelf_match' do
  type 'copy'
  tag 'webserver.*'
  parameters(
    store: [
      { type: 'gelf', host: '127.0.0.1', port: 12201, flush_interval: '5s' },
      { type: 'stdout' },
    ]
  )
end

td_agent_filter 'test_filter' do
  type 'record_transformer'
  tag 'webserver.*'
  parameters(
    record: [
      { host_param: "#{Socket.gethostname}" },
    ]
  )
end
