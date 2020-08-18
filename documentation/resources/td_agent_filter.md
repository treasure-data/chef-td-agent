[back to resource list](https://github.com/treasure-data/chef-td-agent#resources)

# td_agent_filter

Creates filter configuration files

Introduced: v4.0.0

## Requires

- Chef >= 13

### Actions

- `:create` Creates filter configuration files
- `:delete` Removes filter configuration files

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `filter_name` | String | name_property | Name of filter |
| `type` | String | nil | Required: Type of filter being created |
| `tag` | String | nil | Required: Tag to add to the data |
| `parameters` | Hash | {} | Additional parameters to pass to the filter |
| `template_source` | String | 'td-agent' | Which cookbook to use for the template source |

### Examples

```ruby
td_agent_filter 'test_filter' do
  type 'record_transformer'
  tag 'webserver.*'
  parameters(
    record: [
      { host_param: "#{Socket.gethostname}" },
    ]
  )
end
```
