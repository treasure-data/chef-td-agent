[back to resource list](https://github.com/treasure-data/chef-td-agent#resources)

# td_agent_sysctl_optimizations

Creates sysctl files

Introduced: v4.0.0

## Requires

- Chef >= 14

### Actions

- `:create` Create systcl settings
- `:remove` Remove systcl settings

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `sysctl_optimization` | Hash | {'net.core.somaxconn' => 1024, 'net.core.netdev_max_backlog' => 5000, 'net.core.rmem_max' => 16777216, 'net.core.wmem_max' => 16777216, 'net.ipv4.tcp_wmem' => '4096 12582912 16777216', 'net.ipv4.tcp_rmem' => '4096 12582912 16777216', 'net.ipv4.tcp_max_syn_backlog' => 8096, 'net.ipv4.tcp_slow_start_after_idle' => 0, 'net.ipv4.tcp_tw_reuse' => 1, 'net.ipv4.ip_local_port_range' => '10240 65535',}, | Hash of sysctl keys and values to apply to the system |

### Examples

```ruby
td_agent_sysctl_optimizations 'default'
```
