# Version History

## Unreleased

* none

## 2.5.0

* Fix support for Amazon Linux with Chef 13.x (#95)

## 2.4.1

* Restored support of `params` property for Chef pre-13.x to keep backward compatibility with previous releases (#93, #99)

## 2.4.0

* Renamed params to parameters to support chef v13 (#93)

## 2.3.0

* Split recipes into multiple pieces to allow wrapper cookbooks to override behavior (#90)

## 2.2.2

* Add Fedora support (#84)
* Add `retry` to `package` resource (#86)
* Fix a deprecation warning of usage of `manage_home` of `user` resource (#89)

## 2.2.1 

* Make system user & group as attributes (#80)
* Allow using custom template for `source` provider (#83)

## 2.2.0

* Add `filter` LWRP (#74)

## 2.1.4

* Fix wrong expectation on `platform_family` attribute on RedHat familiers (#71)
* Fix indentation of generated template via `match` (#71)

## 2.1.3

* Add support for Amazon Linux (#60, #70)

## 2.1.2

* Use `@include` when configuring td-agent 2.x 
* Delay the reload in case a wrapper cookbook has other `conf.d` files to change (#69)
* Specify arch='amd64' to the `apt_repository` resource (#53, #69)
* Use `@include` directive when using td-agent 2.x (#62)

## 2.1.1

* Retrieve GPG signing key via HTTPS (#54)
* Prevent unnecessary service restart after LWRP updates (#58, #59)
* Added support for debian for td-agent 2.x (#56)
* Use `Gem::Version` to compare version string properly

## 2.1.0

* (same content as v2.0.2 except version string)

## 2.0.2

* Convert the `td_agent_gem` LWRP to a full resource
* Add Vagrantfile to test recipe in vagrant box

## 2.0.1

* Minor improvement in platform detection (#48)

## 2.0.0

* Change default td-agent version from 1.x to 2.x (#44)
