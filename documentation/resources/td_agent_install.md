[back to resource list](https://github.com/treasure-data/chef-td-agent#resources)

# td_agent_install

Installs td-agent and creates default configuration

Introduced: v4.0.0

## Requires

- Chef >= 13

### Actions

- `:install` Installs the td-agent from repository
- `:configure` Creates default configuration and installs plugins
- `:remove` Removes td-agent and repository

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `major_version` | String | name_property | Major version of td-agent to install |
| `template_source` | String | 'td-agent' | Cookbook to source template from |
| `default_config` | [true, false] | true | Set default config in /etc/td-agent/td-agent.conf file |
| `in_forward` | Hash | {port: 24224, bind: '0.0.0.0',} | Port to listen for td-agent forwarded messages |
| `in_http` | Hash | {port: 8888, bind: '0.0.0.0',} | Setup HTTP site for diagnostics |
| `api_key` | String | nil | Adds api key for td cloud analytics |
| `plugins` | [String, Hash, Array] | nil | Plugins to install, fluent-plugin- auto added to plugin name, Hash can be used to specify gem_package options as key value pairs |

### Examples

To install and setup default configuration

```ruby
# Install AWS Cloudwatch agent
td_agent_install '4' do
  action [:install, :configure]
end
```

To install, setup default configuration, and install plugins

```ruby
# Install AWS Cloudwatch agent
td_agent_install '4' do
  plugins 'gelf'
  action [:install, :configure]
end
```
