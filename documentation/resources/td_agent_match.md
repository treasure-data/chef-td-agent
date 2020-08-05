[back to resource list](https://github.com/treasure-data/chef-td-agent#resources)

# td_agent_match

Creates Matcher configuration files

Introduced: v4.0.0

## Requires

- Chef >= 13

### Actions

- `:create` Creates matcher configuration files
- `:delete` Removes matcher configuration files

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `match_name` | String | name_property | Name of matcher |
| `type` | String | nil | Required: Type of matcher being created |
| `tag` | String | nil | Required: Tag to add to the data |
| `parameters` | Hash | {} | Additional parameters to pass to the matcher |
| `template_source` | String | 'td-agent' | Which cookbook to use for the template source |

### Examples

```ruby
td_agent_match 'test_gelf_match' do
  type 'copy'
  tag 'webserver.*'
  parameters(
    store: [
      { type: 'gelf', host: '127.0.0.1', port: 12201, flush_interval: '5s' },
      { type: 'stdout' },
    ]
  )
end
```
