td_agent_install '4' do
  action [:install, :configure]
end

td_agent_filter '01_filter' do
  action :create
  type 'record_transformer'
  tag 'test'
  parameters(
    record: {
      hostname: "#{Socket.gethostname}",
      tag: '${tag}',
    }
  )
end
