include_recipe 'td-agent::default'

td_agent_match '01_out_file' do
  action :create
  type 'file'
  tag 'my.data'
  parameters(
    path: '/var/log/fluent/myapp',
    compress: 'gzip',
    buffer: {
      timekey: '1d',
      timekey_use_utc: true,
      timekey_wait: '10m'
    }
  )
end

td_agent_match '02_buffer_with_arguments' do
  action :create
  type 'null'
  tag 'output.null'
  parameters(
    'buffer tag, argument1, argument2' => {
      timekey: '1d'
    }
  )
end
