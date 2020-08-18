[back to resource list](https://github.com/treasure-data/chef-td-agent#resources)

# td_agent_source

Creates source configuration files

Introduced: v4.0.0

## Requires

- Chef >= 13

### Actions

- `:create` Creates source configuration files
- `:delete` Removes source configuration files

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `source_name` | String | name_property | Name of source |
| `type` | String | nil | Required: Type of source being created |
| `tag` | String | nil | Required: Tag to add to the data |
| `parameters` | Hash | {} | Additional parameters to pass to the source |
| `template_source` | String | 'td-agent' | Which cookbook to use for the template source |

### Examples

```ruby
td_agent_source 'test_in_tail' do
  type 'tail'
  tag 'syslog'
  parameters(
    format: 'syslog',
    path: '/var/log/syslog',
    pos_file: '/tmp/.syslog.pos'
  )
end
```
