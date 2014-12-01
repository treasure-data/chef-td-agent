# DESCRIPTION

[Opscode Chef](http://www.opscode.com/chef/) cookbook for td-agent (Treasure Data Agent). The release log of td-agent is available [here](http://help.treasure-data.com/kb/installing-td-agent-daemon/changelog-of-td-agent).

NOTE: td-agent is open-sourced as [Fluentd project](http://github.com/fluent/). If you want to use stable version of Fluentd, using this cookbook is recommended.

# INSTALLATION

The [knife-github-cookbooks](https://github.com/websterclay/knife-github-cookbooks) gem is a plugin for knife that supports installing cookbooks directly from a GitHub repository. To install with this plugin, please follow these steps:

```sh
$ gem install knife-github-cookbooks
$ cd chef-repo
$ knife cookbook github install treasure-data/chef-td-agent
```

## NOTICE

This cookbook may be used on Amazon Linux but we cannot guarantee if td-agent will work properly because
AWS doesn't guarantee binary compatibility with RHEL (they aim to be "as compatible as possible").
If users encounter any compatibility issues with td-agent on Amazon Linux, they should contact AWS.

# REQUIREMENTS

This cookbook has these external dependencies.

* apt cookbook
* yum cookbook

# ATTRIBUTES

## api\_key

API Key, and the Secret Key are required.

* `node[:td_agent][:api_key]` (required)

## plugins

A list of fluentd plugins to install. The `fluent-plugin-` prefix is automatically added. Additional variables can be passed.

- `node[:td_agent][:plugins]`

### Example

This installs the latest version of `fluent-plugin-flowcounter` and version 0.0.9 of `fluent-plugin-rewrite`.

```ruby
node[:td_agent][:plugins] = [
  "flowcounter",
  { "rewrite" => { "version" => "0.0.9" } }
]
```

## version

You can install latest td-agent 2 using `version` attribute and major version.

```ruby
node[:td_agent][:version] = '2'
```

You can also specify full version.

```ruby
node[:td_agent][:version] = '2.0.4'
```

## pinning\_version and version

If `pinning_version` is true, then `versoin`s td-agent will be installed. The default `version` is latest version.

* `node[:td_agent][:pinning_version]`
* `node[:td_agent][:version]`

In this case, you should set full version to `node[:td_agent][:version]`.

### Limitation

`pinning_version` and `version` attributes are now available for `rpm` package.
The td-agent repository now use `reprepro` for building Deb repository.
`reprepro` can not handle multiple versions of the same package.

## uid

UID of td-agent user. Automatically assigned by default.

## gid

GID of td-agent group. Automatically assigned by default.

# RESOURCES / PROVIDERS

## td\_agent\_gem

Installs a gem or fluentd plugin using the embedded `fluent-gem`

### Actions

| Action  | Description                                                                             |
| ------- | --------------------------------------------------------------------------------------- |
| install | Install the gem, optinally with a specific version. Default.                            |
| upgrade | Upgrade to the latest gem                                                               |
| remove  | Remove the gem                                                                          |
| purge   | Purge the gem                                                                           |

### Attributes

| Attribute      | Description                                                                      |
| -------------- | -------------------------------------------------------------------------------- |
| package\_name  |  Gem name. Defaults to `name`                                                    |
| version        | Gem version. Installs the latest if none specified                               |
| source         | Local .gem file                                                                  |
| options        | Options passed to the gem command                                                |
| gem\_binary    | Override path to the gem command                                                 |
| response\_file | Not supported                                                                    |
| plugin         | If true, no need to prefix the gem name w/ "fluent-plugin-". Defaults to `false` |

### Examples

This installs `fluent-plugin-datacounter` (v0.2.0)

```ruby
td_agent_gem "datacounter" do
  version "0.2.0"
  plugin true
end
```

This installs the latest version of `aws-sdk`

```ruby
td_agent_gem "aws-sdk" do
  plugin false
end
```

## includes

Optionally include `/etc/td-agent/conf.d/*.conf` files (i.e. symlinks, other recipes, etc.)

* `node[:td_agent][:includes] = false`

## default\_config

Optionally prevent `/etc/td-agent/td-agent.conf` from including default config.

* `node[:td_agent][:default_config] = true`

# USAGE

This is an example role file.

```ruby
name "base"
description "base server role."
run_list(
  "recipe[apt]",
  "recipe[yum]",
  "recipe[td-agent]",
)
override_attributes(
  # for td-agent
  :td_agent => {
    :api_key => 'foo_bar_buz',
    :plugins => [
      'rewrite'
    ]
  }
)
```

# HTTP API Options

* `node[:td_agent][:in_http][:enable_api] = true`

Access to the API may be turend off by setting `enable_api` to `false`. This may be of particular use when 
td-agent is being used on endpoint systems that are forwarding logs to a centralized td-agent server.

