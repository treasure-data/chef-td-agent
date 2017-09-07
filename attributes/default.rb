default["td_agent"]["api_key"] = ''

default["td_agent"]["plugins"] = []

default["td_agent"]["uid"] = nil
default["td_agent"]["gid"] = nil

default["td_agent"]["user"] = 'td-agent'
default["td_agent"]["group"] = 'td-agent'

default["td_agent"]["includes"] = false
default["td_agent"]["default_config"] = true
default["td_agent"]["template_cookbook"] = 'td-agent'
default["td_agent"]["in_http"]["enable_api"] = true
default["td_agent"]["version"] = "2.2.0"
default["td_agent"]["pinning_version"] = false
default["td_agent"]["apt_arch"] = 'amd64'
default["td_agent"]["in_forward"] = {
  port: 24224,
  bind: '0.0.0.0'
}
default["td_agent"]["in_http"] = {
  port: 8888,
  bind: '0.0.0.0'
}
default["td_agent"]["yum_amazon_releasever"] = "$releasever"

default["td_agent"]["install_url"] = nil
default["td_agent"]["install_resource"] = nil

# Determine the constant value of the `type` parameter.
# Possible values are:
#   - @type (for fluentd 0.14+)
#   - type  (for fluentd 0.12)
#   - nil   (auto detect based on node["td_agent"]["version"])
default["td_agent"]["template_type_string"] = nil
