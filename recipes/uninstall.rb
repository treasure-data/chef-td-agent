package "td-agent" do
  action :remove
end

%w[/var/run/td-agent /etc/td-agent /var/log/td-agent].each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end
