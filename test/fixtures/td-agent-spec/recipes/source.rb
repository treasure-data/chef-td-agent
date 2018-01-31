include_recipe 'td-agent::default'

td_agent_source '01_input' do
  action :create
  type 'forward'
  tag 'test'
  parameters(port: 22222, bind: '0.0.0.0')
end
