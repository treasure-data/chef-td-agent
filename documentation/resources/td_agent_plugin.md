[back to resource list](https://github.com/treasure-data/chef-td-agent#resources)

# td_agent_plugin

Downloads plugin files locally

Introduced: v4.0.0

## Requires

- Chef >= 13

### Actions

- `:create` Downloads plugin files locally
- `:delete` Removes local plugin files

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `plugin_name` | String | name_property | Name of plugin |
| `url` | String | nil | Required: Url to download the plugin from |

### Examples

```ruby
td_agent_plugin 'gelf' do
  url 'https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb'
end
```
