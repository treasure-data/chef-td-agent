#
# Cookbook Name:: td-agent
# Recipe:: install
#
#

Chef::Recipe.send(:include, TdAgent::Version)
Chef::Provider.send(:include, TdAgent::Version)

group node["td_agent"]["group"] do
  group_name node["td_agent"]["group"]
  gid node["td_agent"]["gid"] if node["td_agent"]["gid"]
  system true
  action     [:create]
end

user node["td_agent"]["user"] do
  comment  'td-agent'
  uid node["td_agent"]["uid"] if node["td_agent"]["uid"]
  system true
  group    node["td_agent"]["group"]
  home     '/var/run/td-agent'
  shell    '/bin/false'
  password nil
  manage_home true
  action   [:create, :manage]
end

directory '/var/run/td-agent/' do
  owner  node["td_agent"]["user"]
  group  node["td_agent"]["group"]
  mode   '0755'
  action :create
end

directory '/etc/td-agent/' do
  owner  node["td_agent"]["user"]
  group  node["td_agent"]["group"]
  mode   '0755'
  action :create
end

case node['platform_family']
when "debian"
  dist = node['lsb']['codename']
  platform = node["platform"]
  source =
    if major.nil? || major == '1'
      # version 1.x or no version
      if dist == 'precise'
        'http://packages.treasuredata.com/precise/'
      else
        'http://packages.treasuredata.com/debian/'
      end
    else
      # version 2.x or later
      "http://packages.treasuredata.com/#{major}/#{platform}/#{dist}/"
    end

  apt_repository "treasure-data" do
    uri source
    arch node["td_agent"]["apt_arch"]
    distribution dist
    components ["contrib"]
    key "https://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
when "fedora"
  platform = node["platform"]
  source =
    if major.nil? || major == '1'
      "http://packages.treasuredata.com/redhat/$basearch"
    else
      # version 2.x or later
        "http://packages.treasuredata.com/#{major}/redhat/7/$basearch"
    end

  yum_repository "treasure-data" do
    description "TreasureData"
    url source
    gpgkey "https://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
when "rhel", "amazon"
  # platform_family of Amazon Linux is judged as amazon in new version of ohai: https://github.com/chef/ohai/pull/971

  platform = node["platform"]
  source =
    if major.nil? || major == '1'
      "http://packages.treasuredata.com/redhat/$basearch"
    else
      # version 2.x or later
      if platform == "amazon"
        if node["td_agent"]["yum_amazon_releasever"] != "$releasever"
          Chef::Log.warn("Treasure Data doesn't guarantee td-agent works on older Amazon Linux releases. td-agent could be used on such environment at your own risk.")
        end
        "http://packages.treasuredata.com/#{major}/redhat/#{node["td_agent"]["yum_amazon_releasever"]}/$basearch"
      else
        "http://packages.treasuredata.com/#{major}/redhat/$releasever/$basearch"
      end
    end

  yum_repository "treasure-data" do
    description "TreasureData"
    url source
    gpgkey "https://packages.treasuredata.com/GPG-KEY-td-agent"
    action :add
  end
end

directory "/etc/td-agent/conf.d" do
  owner node["td_agent"]["user"]
  group node["td_agent"]["group"]
  mode "0755"
  only_if { node["td_agent"]["includes"] }
end

# Fetch the source package if selected.
if node["td_agent"]["install_url"]
  remote_name = ::File.basename(
    ::URI.parse(node["td_agent"]["install_url"]).path
  )
  remote_file 'td-agent install source' do
    path ::File.join(Chef::Config[:file_cache_path], remote_name)
    source node["td_agent"]["install_url"]
  end
end

# To support URL installs on .deb systems we need to use the dpkg_package
# See https://docs.chef.io/resource_package.html#providers
pkg_resource = :package
if node["td_agent"]["install_resource"]
  pkg_resource = node["td_agent"]["install_resource"]
end
declare_resource(pkg_resource, "td-agent") do
  retries 3
  retry_delay 10
  if node["td_agent"]["install_url"]
    action :install
    remote_name = ::File.basename(
      ::URI.parse(node["td_agent"]["install_url"]).path
    )
    local_path = ::File.join(Chef::Config[:file_cache_path], remote_name)
    source local_path
  elsif node["td_agent"]["pinning_version"]
    action :install
    version node["td_agent"]["version"]
  else
    action :upgrade
  end
end
