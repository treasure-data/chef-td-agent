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
