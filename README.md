# DESCRIPTION

[Chef](https://www.chef.io/chef/) cookbook for td-agent (Treasure Data Agent). The release log of td-agent is available [here](http://docs.treasure-data.com/articles/td-agent-changelog).

NOTE: td-agent is open-sourced as the [Fluentd project](http://github.com/fluent/). If you want to use a stable version of Fluentd, using this cookbook is recommended.

# INSTALLATION

## Installing with Berkshelf

This cookbook is released on [Chef Supermarket](https://supermarket.chef.io/). You can install the cookbook using [Berkshelf](http://berkshelf.com/).

```sh
$ echo 'cookbook "td-agent"' >> Berksfile
$ berks install
```

## Installing with knife-github-cookbooks

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

You can install the latest td-agent 2 using the `version` attribute and major version.

```ruby
node[:td_agent][:version] = '2'
```

You can also specify the full version.

```ruby
node[:td_agent][:version] = '2.0.4'
```

## pinning\_version and version

If `pinning_version` is true, then `version`'s td-agent will be installed. The default `version` is the latest version.

* `node[:td_agent][:pinning_version]`
* `node[:td_agent][:version]`

In this case, you should set the full version in `node[:td_agent][:version]`.

### Limitation

`pinning_version` and `version` attributes are now available for `rpm` packages.
They are unsupported for `deb` packages because the td-agent repository currently
uses `reprepro` for building deb repositories, which can not handle multiple versions
of the same package.

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

## td_agent_source

Create file with source definition in `/etc/td-agent/conf.d` directory. It works only if `node[:td_agent][:includes]` is `true`

Notice: If you use some plugins in your sources, you should install it before you call lwrp.

### Actions

| Action | Description |
|----------|----------------|
| :create | Create a file |
| :delete | Delete a file |

### Attributes

| Attribute | Description |
|-------------|----------------|
| source_name | File name. To its value will be added `.conf`. Defaults to `name`  |
| type | Type of source. This is name of input plugin. |
| tag | Tag, what uses in fluentd routing. |
| params | Parameters of source. Hash. |

### Example

This example creates the source with `tail` type and  `syslog` tag which reads from `/var/log/messages` and parses it as `syslog`.

```ruby
td_agent_source 'test_in_tail' do
  type 'tail'
  tag 'syslog'
  params(format: 'syslog',
         path: '/var/log/messages')
end
```

## td_agent_match

Create file with match definition in `/etc/td-agent/conf.d` directory. It works only if `node[:td_agent][:includes]` is `true`

Notice: Notice: If you use some plugins in your matches, you should install it before you call lwrp.

### Actions

| Action | Description |
|----------|----------------|
| :create | Create a file |
| :delete | Delete a file |

### Attributes

| Attribute | Description |
|-------------|----------------|
| match_name | File name. To its value will be added `.conf`. Defaults to `name`  |
| type | Type of match. This is name of output plugin. |
| tag | Tag, what uses in fluentd routing. |
| params | Parameters of match. Hash. |

### Example
This example creates the match with type `copy` and tag `webserver.*` which sends log data to local graylog2 server.

```ruby
td_agent_match 'test_gelf_match' do
  type 'copy'
  tag 'webserver.*'
  params( store: [{ type: 'gelf',
                   host: '127.0.0.1',
                   port: 12201,
                   flush_interval: '5s'},
                   { type: 'stdout' }])
end
```

## td_agent_filter

Create file with filter definition in `/etc/td-agent/conf.d` directory. It works only if `node[:td_agent][:includes]` is `true`

Notice: Notice: If you use some plugins for your filters, you should install them before you call lwrp.

### Actions

| Action | Description |
|----------|----------------|
| :create | Create a filter |
| :delete | Delete a filter |

### Attributes

| Attribute | Description |
|-------------|----------------|
| filter_name | File name. To its value will be added `.conf`. Defaults to `name`  |
| type | Type of filter. This is name of output plugin. |
| tag | Tag, what uses in fluentd routing. |
| params | Parameters of filter. Hash. |

### Example
This example creates the filter with type `record_transformer` and tag `webserver.*` which adds the `hostname` field with the server's hostname as its value:

```ruby
td_agent_filter 'filter_webserver' do
  type 'record_transformer'
  tag 'webserver.*'
  params(
    record: [ { host_param: %q|"#{Socket.gethostname}"| } ]
  )
end
```

## td_agent_plugin

Install plugin from url to `/etc/td-agent/plugin` dir.

### Actions

| Action | Description |
|----------|----------------|
| :create | Install plugin |
| :delete | Uninstall plugin |

### Attributes

| Attribute | Description |
|-------------|----------------|
| plugin_name | File name. To its value will be added `.rb`. Defaults to `name`  |
| url | Url what contains plugin file. Value of this attribute may be the same as remote_file resource.  |

### Example

Install plugin `gelf.rb` from url `https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb`

```ruby
td_agent_plugin 'gelf' do
  url 'https://raw.githubusercontent.com/emsearcy/fluent-plugin-gelf/master/lib/fluent/plugin/out_gelf.rb'
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

Access to the API may be disabled by setting `enable_api` to `false`. This may be of particular use when
td-agent is being used on endpoint systems that are forwarding logs to a centralized td-agent server.

# License

Copyright 2014 Treasure Data, Inc.

The code is licensed under the Apache License 2.0 (see  LICENSE for details).
