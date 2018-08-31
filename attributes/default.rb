default['td_agent']['api_key'] = ''

# Enable td-agent Prometheus monitoring
default['td_agent']['enable_prometheus'] = false

default['td_agent']['plugins'] = []

default['td_agent']['uid'] = nil
default['td_agent']['gid'] = nil

default['td_agent']['user'] = 'td-agent'
default['td_agent']['group'] = 'td-agent'

default['td_agent']['includes'] = true
default['td_agent']['default_config'] = true
default['td_agent']['template_cookbook'] = 'td-agent'
default['td_agent']['in_http']['enable_api'] = true
default['td_agent']['version'] = '3.1.1'
default['td_agent']['pinning_version'] = false
default['td_agent']['apt_arch'] = 'amd64'
default['td_agent']['in_forward'] = {
  port: 24224,
  bind: '0.0.0.0',
}
default['td_agent']['in_http'] = {
  port: 8888,
  bind: '0.0.0.0',
}
default['td_agent']['yum_amazon_releasever'] = '$releasever'
default['td_agent']['skip_repository'] = false
