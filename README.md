# td-agent

[![Build Status](https://travis-ci.org/treasure-data/chef-td-agent.svg?branch=master)](https://travis-ci.org/treasure-data/chef-td-agent)

## DESCRIPTION

[Chef](https://www.chef.io/chef/) cookbook for td-agent (Treasure Data Agent). The release log of td-agent is available [here](http://docs.treasure-data.com/articles/td-agent-changelog).

NOTE: td-agent is open-sourced as the [Fluentd project](http://github.com/fluent/). If you want to use a stable version of Fluentd, using this cookbook is recommended.

## NOTICE

This cookbook may be used on Amazon Linux, but we cannot guarantee if td-agent will work properly because
AWS doesn't guarantee binary compatibility with RHEL (they aim to be "as compatible as possible").
If users encounter any compatibility issues with td-agent on Amazon Linux, they should contact AWS.

### Chef

- Chef >= 13
- Chef >= 14 if using td_agent_sysctl_optimizations resource

## Resources

- [td_agent_filter](https://github.com/treasure-data/chef-td-agent/tree/master/documentation/resources/td_agent_filter.md)
- [td_agent_install](https://github.com/treasure-data/chef-td-agent/tree/master/documentation/resources/td_agent_install.md)
- [td_agent_match](https://github.com/treasure-data/chef-td-agent/tree/master/documentation/resources/td_agent_match.md)
- [td_agent_plugin](https://github.com/treasure-data/chef-td-agent/tree/master/documentation/resources/td_agent_plugin.md)
- [td_agent_source](https://github.com/treasure-data/chef-td-agent/tree/master/documentation/resources/td_agent_source.md)
- [td_agent_sysctl_optimizations](https://github.com/treasure-data/chef-td-agent/tree/master/documentation/resources/td_agent_sysctl_optimizations.md)

## License

Copyright 2014-today Treasure Data, Inc.

The code is licensed under the Apache License 2.0 (see  LICENSE for details). 

