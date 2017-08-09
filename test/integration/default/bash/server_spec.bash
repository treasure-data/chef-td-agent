#!/usr/bin/env bash
set -eux -o pipefail
unset GEM_CACHE
unset GEM_HOME
unset GEM_PATH
export PATH="/opt/chef/embedded/bin:/opt/chef/bin:${PATH}"
cd "${BUSSER_ROOT}/suites/bash"
bundle install --path=vendor/bundle
env SPEC_OPTS="--format=RspecJunitFormatter --out=${BUSSER_ROOT}/result.xml --require=rspec_junit_formatter" bundle exec rake spec
