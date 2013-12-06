%w[/var/run/td-agent /etc/td-agent /var/log/td-agent].each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end

package "td-agent" do
  action :purge
end
