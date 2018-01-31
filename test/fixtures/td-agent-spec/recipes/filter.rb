include_recipe 'td-agent::default'

td_agent_filter '01_filter' do
  action :create
  type 'record_transformer'
  tag 'test'
  parameters(
    record: {
      hostname: '"#{Socket.gethostname}"',
      tag: '${tag}'
    }
  )
end
